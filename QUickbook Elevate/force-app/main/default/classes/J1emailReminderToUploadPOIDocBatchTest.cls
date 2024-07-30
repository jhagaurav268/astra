@isTest
public class J1emailReminderToUploadPOIDocBatchTest {
    
    public static testmethod void testAll(){
        
        string J1RecTypeId= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('J1').getRecordTypeId();
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Rider').getRecordTypeId();
        string riderRecTypeId= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Rider').getRecordTypeId();
        
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
        
        Contact objContact2 = new Contact();
        objContact2.LastName = 'ContactJ1 LastName';
        objContact2.AccountId = objAcc.Id;
        objContact2.RecordTypeId = J1RecTypeId;
        objContact2.Graduated_Override__c ='Graduated';
        objContact2.FirstName='test';
        objContact2.Email ='test@test.com';
        objContact2.Insurance_Verification_Date__c  =system.today();
        objContact2.Employment_Verification_Date__c  =system.today();
        objContact2.SS_Classroom_Completed__c= dtFilter;
        //objContact.Funnel_Stage__c='1-IV&EV Complete';
        insert objContact2;
        
        J1emailReminderToUploadPOIDocBatch objBatch = new J1emailReminderToUploadPOIDocBatch() ;
        Database.executeBatch(objBatch) ;
        
        System.SchedulableContext sc;
        J1emailReminderToUploadPOIDocSchedule objSch = new J1emailReminderToUploadPOIDocSchedule() ;
        objSch.execute(sc) ;
        
    }
    
    
}