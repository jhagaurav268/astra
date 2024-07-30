@isTest
public class emailReminderToScheduleDMVTestBatchTest {
    
    public static testmethod void testAll(){
        
        string riderRecTypeId= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Rider').getRecordTypeId();
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Rider').getRecordTypeId();
        
        Account objAcc = new Account();
        objAcc.Name  = 'Test Account';
        objAcc.RecordTypeId = accRecordTypeId;
        insert objAcc;
        
        integer noOfDays= integer.valueOf(label.No_Of_Days_for_SS_registration_reminder_Email);
        date dtFilter= system.today().addDays(noOfDays*(-1));
        
        integer noOfDaysSSC= integer.valueOf(label.No_Of_Days_for_DMV_Test_schedule_reminder_Email);
        date dtFilterSSC= system.today().addDays(noOfDaysSSC*(-1));
        
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
        objContact.Scooter_School_Date__c= dtFilterSSC.addDays(-10);
        objContact.Scooter_School_Completed_Date__c = dtFilterSSC;
        //objContact.Funnel_Stage__c='1-IV&EV Complete';
        insert objContact;
        
        list<Contact> listCon = [select id,Funnel_Stage__c,DMV_Test_Date__c,Scooter_School_Completed_Date__c from contact where id=:objContact.id];
        system.debug(listCon);
        
        emailReminderToScheduleDMVTestBatch objBatch = new emailReminderToScheduleDMVTestBatch() ;
        Database.executeBatch(objBatch) ;
        
        System.SchedulableContext sc;
        emailReminderToScheduleDMVTestSchedule objSch = new emailReminderToScheduleDMVTestSchedule() ;
        objSch.execute(sc) ;
        
    }
    
    
}