public class J1emailReminderToRegisterSSBatch   implements Database.Batchable<sobject> {
    
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        string J1RecTypeId= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('J1').getRecordTypeId();
        integer noOfDays= integer.valueOf(label.No_Of_Days_for_SS_registration_reminder_Email_J1); //4
        date dtFilter= system.today().addDays(noOfDays*(-1));
        
        return Database.getQueryLocator([select id,name,FirstName,Email,AccountId from Contact
                                         where recordTypeId=:J1RecTypeId and
                                         Inactive__c=false and
                                         Email<>null and SchoolDate__c=null and SS_Classroom_Completed__c=:dtFilter]);
    }
    
    public void execute(Database.BatchableContext BC,list<Contact>listContact){
        List<Messaging.SingleEmailMessage>emailsToBeSend  = new List<Messaging.SingleEmailMessage>(); 
        try{
            
            if(listContact.size()>0){
                
                List<EmailTemplate> templateList = [Select id,body,HTMLValue,subject from EmailTemplate where DeveloperName = 'J1_Scooter_School_Sign_Up_Reminder' limit 1];
                list<OrgWideEmailAddress> listOWDEmail = [select id from OrgWideEmailAddress where id=:label.OrgWideEmailAddressId];
                list<task>listTask = new list<task>();
                
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
                        // objEmailMsg.setWhatId(objCon.Id);
                        objEmailMsg.setSubject(subject);
                        objEmailMsg.setSaveAsActivity(true);
                        //objEmailMsg.setTemplateId(templateList[0].Id);
                        emailsToBeSend.add(objEmailMsg);
                        
                        Task objTask = new Task();
                        objTask.Subject = 'Schedule Scooter School Reminder email sent';
                        objTask.Status = 'Closed';
                        objTask.Priority = 'Normal';
                        objTask.WhoId = objCon.ID;
                        //tsk.OwnerId = accObj.OwnerId;
                        listTask.add(objTask);
                        
                    }
                    
                    if(emailsToBeSend.size()>0){
                        system.debug('emailsToBeSend.size()= '+emailsToBeSend.size());                        
                        
                        Messaging.sendEmail(emailsToBeSend);
                        
                        if(listTask.size()>0){
                            insert listTask;
                        }
                        
                    }
                    
                }
            }
        }
        catch(Exception ex){}
    }
    
    public void finish(Database.BatchableContext BC) { 
        
    }
}