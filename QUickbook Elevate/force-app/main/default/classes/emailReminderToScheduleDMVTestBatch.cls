public class emailReminderToScheduleDMVTestBatch implements Database.Batchable<sobject> {
    
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        string riderRecTypeId= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Rider').getRecordTypeId();
        integer noOfDays= integer.valueOf(label.No_Of_Days_for_DMV_Test_schedule_reminder_Email);//5
        date dtFilter= system.today().addDays(noOfDays*(-1));
        
        return Database.getQueryLocator([select id,name,FirstName,Email,AccountId from Contact
                                         where recordTypeId=:riderRecTypeId and
                                         Inactive__c=false and
                                         Email<>null and DMV_Test_Date__c=null  and
                                         Scooter_School_Completed_Date__c=:dtFilter]);
    }
    
    public void execute(Database.BatchableContext BC,list<Contact>listContact){
        List<Messaging.SingleEmailMessage>emailsToBeSend  = new List<Messaging.SingleEmailMessage>(); 
        try{
            
            if(listContact.size()>0){
                List<EmailTemplate> templateList = [Select id,body,HTMLValue,subject from EmailTemplate where DeveloperName = :label.DMV_Test_schedule_reminder_Email_Template limit 1];
                list<OrgWideEmailAddress> listOWDEmail = [select id from OrgWideEmailAddress where id=:label.OrgWideEmailAddressId];
                
                if(templateList.size()>0 && listOWDEmail.size()>0){
                    string body='';
                    string templateBody= templateList[0].HTMLValue;
                    string subject= templateList[0].subject;
                    for(Contact objCon:listContact){
                        body= templateBody;
                        body= body.replace('{!Contact.FirstName}', objCon.FirstName);
                        
                        Messaging.SingleEmailMessage objEmailMsg= new Messaging.SingleEmailMessage();                                    
                        objEmailMsg.setHtmlBody(body);                            
                        objEmailMsg.setToAddresses(new list<string>{objCon.email}); 
                        objEmailMsg.setOrgWideEmailAddressId(listOWDEmail[0].Id);
                        objEmailMsg.setTargetObjectId(objCon.Id);
                        objEmailMsg.setSubject(subject);
                        objEmailMsg.setSaveAsActivity(true);
                        emailsToBeSend.add(objEmailMsg);
                        
                    }
                    
                    if(emailsToBeSend.size()>0){
                        system.debug('emailsToBeSend.size()= '+emailsToBeSend.size());
                        Messaging.sendEmail(emailsToBeSend);
                        
                        
                    }
                    
                }
            }
        }
        catch(Exception ex){}
    }
    
    public void finish(Database.BatchableContext BC) { 
        
    }
    
}