/*
Same POI upload component for the J1 Program
*/
public  without sharing class riderFileUploadJ1Controller {
    
    @auraEnabled
    public static contactWrapper getContactDetailsById(string contactId){
        contactWrapper objWrapper = new contactWrapper();
        System.debug(contactId);
        if(!string.isEmpty(contactId)){
            
            list<Contact> listContact = [select id,name from contact where id=:contactId];
            if(listContact.size()>0){
                objWrapper.objContact= listContact[0];
            }
            
            list<Temp_Files__c> listTempFile =[select id from Temp_Files__c where contact__c=:contactId ];
            if(listTempFile.size()>0){
                
                objWrapper.tempRecId= listTempFile[0].id;
                list<ContentDocumentLink> listCDLink =[ select ContentDocumentId  from ContentDocumentLink  where linkedEntityId=:listTempFile[0].id ];
                
                if(listCDLink.size()>0){
                    delete listCDLink;
                }
                
            }
            else{
                Temp_Files__c objTemp= new Temp_Files__c();
                objTemp.Contact__c= contactId;
                objTemp.Shared_with_Guest_User__c = true;
                insert objTemp;
                objWrapper.tempRecId= objTemp.id;
            }
        }
        return objWrapper;
    }
    
    @auraEnabled
    public static contactWrapper getContactDetails(string email, date DOB){
        contactWrapper objWrapper = new contactWrapper();
        
        if(!string.isEmpty(email)){
            system.debug(email);
            system.debug(DOB);
            list<Contact> listContact = [select id,name from contact where email=:email and Birthdate=:DOB];
            if(listContact.size()>0){
                objWrapper.objContact= listContact[0];
                
                list<Temp_Files__c> listTempFile =[select id from Temp_Files__c where contact__c=:listContact[0].Id ];
                if(listTempFile.size()>0){
                    
                    objWrapper.tempRecId= listTempFile[0].id;
                    list<ContentDocumentLink> listCDLink =[ select ContentDocumentId  from ContentDocumentLink  where linkedEntityId=:listTempFile[0].id ];
                    
                    if(listCDLink.size()>0){
                        delete listCDLink;
                    }
                }
                else{
                    Temp_Files__c objTemp= new Temp_Files__c();
                    objTemp.Contact__c= listContact[0].Id;
                    objTemp.Shared_with_Guest_User__c = true;
                    insert objTemp;
                    objWrapper.tempRecId= objTemp.id;
                }
            }
            
        }
        return objWrapper;
    }
    
    @auraEnabled
    public static contactWrapper getContactDetailsMobile(string email, string DOB){
        contactWrapper objWrapper = new contactWrapper();
        
        if(!string.isEmpty(email)){
            system.debug('DOB='+DOB);
            date dtDOB= date.parse(DOB);
            system.debug('dtDOB='+dtDOB);
            
            list<Contact> listContact = [select id,name from contact where email=:email and Birthdate=:dtDOB];
            if(listContact.size()>0){
                objWrapper.objContact= listContact[0];
                
                list<Temp_Files__c> listTempFile =[select id from Temp_Files__c where contact__c=:listContact[0].Id ];
                if(listTempFile.size()>0){
                    
                    objWrapper.tempRecId= listTempFile[0].id;
                    list<ContentDocumentLink> listCDLink =[ select ContentDocumentId  from ContentDocumentLink  where linkedEntityId=:listTempFile[0].id ];
                    
                    if(listCDLink.size()>0){
                        delete listCDLink;
                    }
                }
                else{
                    Temp_Files__c objTemp= new Temp_Files__c();
                    objTemp.Contact__c= listContact[0].Id;
                    objTemp.Shared_with_Guest_User__c = true;
                    insert objTemp;
                    objWrapper.tempRecId= objTemp.id;
                }
            }
            
        }
        return objWrapper;
    }
    
    
    @auraEnabled
    public static void deleteFile (string documentId){
        if(!string.isempty(documentId)){
            ContentDocument  contDoc = new ContentDocument(Id = documentId) ;
            delete contDoc  ;
        }
        
        
    }
    
    @auraEnabled
    public static map<string,string> deleteNewFiles (list<string> documentIds){
        map<string,string> mapMsg = new map<string,string>();
        system.debug(documentIds);
        try{
            if( documentIds.size()>0 ){
                
                list<ContentDocument>listCD= [select id from ContentDocument where Id in :documentIds];
                if(listCD.size()>0){
                    delete listCD  ;
                }
                mapMsg.put('success', 'true');
            }
        }
        catch(Exception ex){
            mapMsg.put('error', 'true');
        }
        return mapMsg;
    }
    
    @auraEnabled
    public static map<string,string> pocessFileUpload(string contactId, string tempRecId){
        map<string,string> mapMsg = new map<string,string>();
        
        try{
            if(!string.isEmpty(contactId)){
                
                list<Contact> listContact = [select id,name from contact where id=:contactId];
                
                if(listContact.size()>0){
                    
                    list<string> listEmails= new list<string>();
                    list<user> listUser = new list<user>();
                    set<string> userIds = new set<string>();
                    
                    for(user objUser: [select id, name,Email from user where id in 
                                       (select userorgroupid from groupmember where group.developername = 'J1_POI_Upload_Notification') ])
                    {
                        listEmails.add(objUser.Email);
                        listUser.add(objUser);
                        userIds.add(objUser.Id);
                    }
                    
                    if(listEmails.size()==0){
                        mapMsg.put('invalidOfficerEmail','true');
                        return mapMsg;
                    }
                    
                    List<EmailTemplate> templateList = [Select id,body,HTMLValue,subject from EmailTemplate where DeveloperName = 'Notification_of_File_Uploads_by_Rider' limit 1];
                    list<OrgWideEmailAddress> listOWDEmail = [select id from OrgWideEmailAddress where id=:label.OrgWideEmailAddressId];
                    
                    if(templateList.size()>0 && listOWDEmail.size()>0){
                        List<Messaging.SingleEmailMessage>emailsToBeSend  = new List<Messaging.SingleEmailMessage>(); 
                        
                        System.debug(tempRecId);
                        if(! string.isEmpty(tempRecId)){
                            set<id> contentDocIds = new set<id>();
                            set<id> existingContentDocIds = new set<id>();
                            set<id> existingContentDocIdsForUser = new set<id>();
                            list<ContentDocumentLink> listCDLink = new  list<ContentDocumentLink>();
                            list<ContentDocumentLink> listCDLinkToUser = new  list<ContentDocumentLink>();
                            
                            for(ContentDocumentLink objCD:[ select ContentDocumentId  from ContentDocumentLink  where linkedEntityId=:contactId ]){
                                existingContentDocIds.add(objCD.ContentDocumentId);
                            }
                            
                            if(listUser.size()>0){
                                for(ContentDocumentLink objCD:[ select ContentDocumentId  from ContentDocumentLink  where linkedEntityId=:listUser[0].Id ]){
                                    existingContentDocIdsForUser.add(objCD.ContentDocumentId);
                                }
                            }
                            
                            for(ContentDocumentLink objCD:[ select ContentDocumentId  from ContentDocumentLink  where linkedEntityId=:tempRecId ]){
                                contentDocIds.add(objCD.ContentDocumentId);
                                system.debug(objCD.ContentDocumentId);
                                
                                if(!existingContentDocIds.contains(objCD.ContentDocumentId)){
                                    ContentDocumentLink objCDLink = new ContentDocumentLink();
                                    objCDLink.ContentDocumentId = objCD.ContentDocumentId;
                                    objCDLink.LinkedEntityId= contactId;
                                    objCDLink.ShareType='V';                                     
                                    listCDLink.add(objCDLink);
                                }
                                
                                if(listUser.size()>0 && !existingContentDocIdsForUser.contains(objCD.ContentDocumentId)){
                                    ContentDocumentLink objCDLink = new ContentDocumentLink();
                                    objCDLink.ContentDocumentId = objCD.ContentDocumentId;
                                    objCDLink.LinkedEntityId= listUser[0].Id;
                                    objCDLink.ShareType='V';                                     
                                    // listCDLinkToUser.add(objCDLink);
                                } 
                            }
                            
                            if(contentDocIds.size()>0){
                                
                                list<ContentVersion>listCVToUpdate = new list<ContentVersion>();
                                for(ContentVersion objCV: [select id,Proof_of_Income__c,SharingPrivacy,FirstPublishLocationId from ContentVersion where ContentDocumentId in:contentDocIds]){
                                    objCV.Proof_of_Income__c=true;
                                    //objCV.FirstPublishLocationId='05854000000XVVtAAO';
                                    objCV.SharingPrivacy='P';
                                    listCVToUpdate.add(objCV);
                                }
                                
                                if(listCVToUpdate.size()>0){
                                    update listCVToUpdate;
                                }
                                
                                
                                Messaging.SingleEmailMessage objEmailMsg= new Messaging.SingleEmailMessage();
                                List<Messaging.EmailFileAttachment> listEFAtt = new List<Messaging.EmailFileAttachment>();
                                string body= templateList[0].HTMLValue;
                                string subject=templateList[0].subject;
                                
                                subject= subject.replace('{!contactName}',listContact[0].Name);                                
                                body= body.replace('{!contactName}',listContact[0].Name);
                                body= body.replace('{!date}',System.now().format('MM-dd-yyyy'));
                                
                                String Recordlink = URL.getOrgDomainUrl().toExternalForm()+'/'+listContact[0].Id;
                                body= body.replace('{!linkToContact}',Recordlink);
                                objEmailMsg.setHtmlBody(body);                            
                                objEmailMsg.setToAddresses(listEmails);//(new list<string>{(label.Rider_File_Upload_Email_Recipient).trim()});   
                                objEmailMsg.setOrgWideEmailAddressId(listOWDEmail[0].Id);
                                //objEmailMsg.setTargetObjectId(contactId);
                                objEmailMsg.setSubject(subject);
                                objEmailMsg.setSaveAsActivity(true);
                                emailsToBeSend.add(objEmailMsg);
                                
                                
                                if(listCDLink.size()>0){
                                    insert listCDLink;
                                }
                                if(listCDLinkToUser.size()>0){
                                    // insert listCDLinkToUser;
                                }
                                
                                list<ContentWorkspaceDoc> listCDWorkspace= new  list<ContentWorkspaceDoc>();
                                list<ContentWorkspace> listContentWrkSpace= [select id from ContentWorkspace where name='POI'];
                                
                                if(listContentWrkSpace.size()>0){
                                    
                                    for(id CDId:contentDocIds){
                                        ContentWorkspaceDoc obj= new ContentWorkspaceDoc();
                                        obj.ContentDocumentId= CDId;
                                        obj.ContentWorkspaceId= listContentWrkSpace[0].id;
                                        listCDWorkspace.add(obj);
                                    }
                                    insert listCDWorkspace;
                                }
                                
                                
                                
                                
                                if(emailsToBeSend.size()>0){
                                    Messaging.SendEmailResult []er=  Messaging.sendEmail(emailsToBeSend);
                                    System.debug(er);
                                }
                            }
                        }                        
                        
                    }
                    mapMsg.put('success','true');
                }
            }
            
        }
        catch(Exception ex){
            system.debug(ex);
            mapMsg.put('error','true');
        }
        return mapMsg;
    }
    
    
    public class contactWrapper{
        @AuraEnabled public contact objContact{get;set;}
        @AuraEnabled public string tempRecId{get;set;}
    } 
    
}