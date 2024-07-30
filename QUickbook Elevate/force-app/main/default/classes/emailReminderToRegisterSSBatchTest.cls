@isTest
public class emailReminderToRegisterSSBatchTest {
    
    
    public static testmethod void testAll(){
        
        string riderRecTypeId= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Rider').getRecordTypeId();
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Rider').getRecordTypeId();
        
        Account objAcc = new Account();
        objAcc.Name  = 'Test Account';
        objAcc.RecordTypeId = accRecordTypeId;
        insert objAcc;
        
        integer noOfDays= integer.valueOf(label.No_Of_Days_for_SS_registration_reminder_Email);
        date dtFilter= system.today().addDays(noOfDays*(-1));
        
        Contact objContact = new Contact();
        objContact.LastName = 'Contact LastName';
        objContact.AccountId = objAcc.Id;
        objContact.RecordTypeId = riderRecTypeId;
        objContact.Graduated_Override__c ='Graduated';
        objContact.FirstName='test';
        objContact.Email ='test@test.com';
        objContact.Insurance_Verification_Date__c  =system.today();
        objContact.Employment_Verification_Date__c  =system.today();
        objContact.SS_Classroom_Completed__c= dtFilter;
        //objContact.Funnel_Stage__c='1-IV&EV Complete';
        insert objContact;
        
        emailReminderToRegisterSSBatch objBatch = new emailReminderToRegisterSSBatch() ;
        Database.executeBatch(objBatch) ;
        
        System.SchedulableContext sc;
        emailReminderToRegisterSSSchedule objSch = new emailReminderToRegisterSSSchedule() ;
        objSch.execute(sc) ;
        
    }
    
}