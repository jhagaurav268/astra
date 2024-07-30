/*
BATCH JOB - REMINDER FOR SCOOTER PICKUP
*/
public class J1emailReminderToScooterPickupBatch implements Database.Batchable<sobject> {
    
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        string J1RecTypeId= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('J1').getRecordTypeId();
        integer noOfDays= integer.valueOf(label.No_of_Days_for_Scooter_pickup_reminder);//5
        date dtFilter= system.today().addDays(noOfDays*(-1));
        
        return Database.getQueryLocator([select id,name,FirstName,Email,AccountId from Contact
                                         where recordTypeId=:J1RecTypeId and
                                         Inactive__c=false and
                                         Email<>null and Date_of_Scooter_Delivery__c=null and 
                                         Scooter_School_Completed_Date__c=:dtFilter]);
    }
    
    public void execute(Database.BatchableContext BC,list<Contact>listContact){
        List<Messaging.SingleEmailMessage>emailsToBeSend  = new List<Messaging.SingleEmailMessage>(); 
        try{
            
            if(listContact.size()>0){
                List<EmailTemplate> templateList = [Select id,body,HTMLValue,subject from EmailTemplate where DeveloperName = 'J1_Reminder_To_Schedule_Scooter_Pick_Up' limit 1];
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