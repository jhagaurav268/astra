/*
BATCH JOB - REMINDER TO UPLOAD POI DOCUMENTS
*/
public class J1emailReminderToUploadPOIDocBatch implements Database.Batchable<sobject> {
    
    
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        string J1RecTypeId= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('J1').getRecordTypeId();
        string riderRecTypeId= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Rider').getRecordTypeId();
        integer noOfDays= integer.valueOf(label.No_of_Days_for_Document_upload_reminder);//5
        date dtFilter= system.today().addDays(noOfDays*(-1));
        
        if(System.Test.isRunningTest()){
            dtFilter= system.today();
        }
        
        return Database.getQueryLocator([select id,name,FirstName,Email,AccountId,recordTypeId from Contact
                                         where (recordTypeId=:J1RecTypeId or recordTypeId=:riderRecTypeId) and
                                         Email<>null and Inactive__c=false and
                                         DAY_ONLY(convertTimezone(CreatedDate))=:dtFilter 
                                         order by createddate]);
    }
    
    public void execute(Database.BatchableContext BC,list<Contact>listContact){
        List<Messaging.SingleEmailMessage>emailsToBeSend  = new List<Messaging.SingleEmailMessage>(); 
        list<Contact>listRiderContact = new list<Contact>();
        list<Contact>listJ1Contact = new list<Contact>();
        
        try{
            
            if(listContact.size()>0){
                
                set<string> contactIds = new set<string>();
                set<string> contentDocIds = new set<string>();
                map<string,set<string>> mapContactWithCDIds = new  map<string,set<string>>();
                map<string,string> mapCDIdWithCVIds = new  map<string,string>();
                
                system.debug(listContact.size());
                string J1RecTypeId= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('J1').getRecordTypeId();
                string riderRecTypeId= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Rider').getRecordTypeId();
                
                for(Contact objContact:listContact){
                    
                    system.debug('objContact.Name=' +objContact.Name);
                    contactIds.add(objContact.Id);
                    if(objContact.recordTypeId==J1RecTypeId){
                        listJ1Contact.add(objContact);
                    }
                    else if(objContact.recordTypeId==riderRecTypeId){
                        listRiderContact.add(objContact);
                    }
                }
                
                
                for(ContentDocumentLink objCD:[ select ContentDocumentId,linkedEntityId  from ContentDocumentLink  where linkedEntityId in:contactIds ]){
                    
                    contentDocIds.add(objCD.ContentDocumentId);
                    if(!mapContactWithCDIds.containsKey(objCD.linkedEntityId)){
                        mapContactWithCDIds.put(objCD.linkedEntityId, new set<string>{objCD.ContentDocumentId});
                    }
                    else{
                        set<string>listExist= mapContactWithCDIds.get(objCD.linkedEntityId);
                        listExist.add(objCD.ContentDocumentId);
                        mapContactWithCDIds.put(objCD.linkedEntityId,listExist);
                    }
                    system.debug('objCD.linkedEntityId= '+objCD.linkedEntityId);
                }
                
                if(contentDocIds.size()>0){
                    system.debug(contentDocIds.size());
                    for(ContentVersion objCV: [select id,Proof_of_Income__c,ContentDocumentId from ContentVersion 
                                               where ContentDocumentId in:contentDocIds and Proof_of_Income__c=true])
                    {
                        system.debug(objCV);
                        mapCDIdWithCVIds.put(objCV.ContentDocumentId,objCV.Id);
                    }
                }
                
                EmailTemplate template,j1Template ;
                for(EmailTemplate objTemplate: [Select id,body,HTMLValue,subject,DeveloperName from EmailTemplate where DeveloperName = 'J1_Document_Upload_Reminder'
                                                or DeveloperName = 'Document_Upload_Reminder'limit 2])
                {
                    if(objTemplate.DeveloperName=='J1_Document_Upload_Reminder'){
                        j1Template= objTemplate;
                    }
                    if(objTemplate.DeveloperName=='Document_Upload_Reminder'){
                        template= objTemplate;
                    }
                }
                list<OrgWideEmailAddress> listOWDEmail = [select id from OrgWideEmailAddress where id=:label.OrgWideEmailAddressId];
                
                if(template!=null && listOWDEmail.size()>0 && listRiderContact.size()>0){
                    
                    string body='';
                    string templateBody= template.HTMLValue;
                    string subject= template.subject;                    
                    set<string> CDIds = new set<string>();
                    boolean POIUploaded=false;
                    
                    for(Contact objCon:listRiderContact){
                        
                        POIUploaded=false;
                        if(mapContactWithCDIds.containsKey(objCon.Id)){
                            for(string CDId:mapContactWithCDIds.get(objCon.Id)){
                                if(mapCDIdWithCVIds.containsKey(CDId)){
                                    POIUploaded=true;
                                    break;
                                }
                            }
                            
                            
                        }
                        
                        if(!POIUploaded){
                            body= templateBody;
                            body= body.replace('{!Contact.FirstName}', objCon.FirstName);
                            system.debug(objCon.email);
                            Messaging.SingleEmailMessage objEmailMsg= new Messaging.SingleEmailMessage();                                    
                            objEmailMsg.setHtmlBody(body);                            
                            objEmailMsg.setToAddresses(new list<string>{objCon.email}); 
                            objEmailMsg.setOrgWideEmailAddressId(listOWDEmail[0].Id);
                            objEmailMsg.setTargetObjectId(objCon.Id);
                            objEmailMsg.setSubject(subject);
                            objEmailMsg.setSaveAsActivity(true);
                            emailsToBeSend.add(objEmailMsg);
                        }
                        
                    }
                    
                    
                    
                }
                
                
                if(j1Template!=null && listOWDEmail.size()>0 && listJ1Contact.size()>0){
                    
                    string body='';
                    string templateBody= j1Template.HTMLValue;
                    string subject= j1Template.subject;                    
                    set<string> CDIds = new set<string>();
                    boolean POIUploaded=false;
                    
                    for(Contact objCon:listJ1Contact){
                        
                        POIUploaded=false;
                        if(mapContactWithCDIds.containsKey(objCon.Id)){
                            for(string CDId:mapContactWithCDIds.get(objCon.Id)){
                                if(mapCDIdWithCVIds.containsKey(CDId)){
                                    POIUploaded=true;
                                    break;
                                }
                            }
                            
                            
                        }
                        
                        if(!POIUploaded){
                            body= templateBody;
                            body= body.replace('{!Contact.FirstName}', objCon.FirstName);
                            system.debug(objCon.email);
                            Messaging.SingleEmailMessage objEmailMsg= new Messaging.SingleEmailMessage();                                    
                            objEmailMsg.setHtmlBody(body);                            
                            objEmailMsg.setToAddresses(new list<string>{objCon.email}); 
                            objEmailMsg.setOrgWideEmailAddressId(listOWDEmail[0].Id);
                            objEmailMsg.setTargetObjectId(objCon.Id);
                            objEmailMsg.setSubject(subject);
                            objEmailMsg.setSaveAsActivity(true);
                            emailsToBeSend.add(objEmailMsg);
                        }
                        
                    }
                    
                    
                    
                }
                
                if(emailsToBeSend.size()>0){
                    system.debug('emailsToBeSend.size()= '+emailsToBeSend.size());
                    Messaging.sendEmail(emailsToBeSend);
                    
                    
                }
                
            }
        }
        catch(Exception ex){}
    }
    
    public void finish(Database.BatchableContext BC) { 
        
    }
    
}