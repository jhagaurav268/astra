@isTest
public class J1emailReminderToScooterPickupBatchTest {
    
    public static testmethod void testAll(){
        
        string riderRecTypeId= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('J1').getRecordTypeId();
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Rider').getRecordTypeId();
        
        Account objAcc = new Account();
        objAcc.Name  = 'Test Account';
        objAcc.RecordTypeId = accRecordTypeId;
        insert objAcc;        
        
        integer noOfDays= integer.valueOf(label.No_of_Days_for_Scooter_pickup_reminder);//5
        date dtFilter= system.today().addDays(noOfDays*(-1));
        
        School_Date__c objSchDate = new School_Date__c();
        objSchDate.Active__c=true;
        objSchDate.Day_One_Date__c= system.Date.today();
        objSchDate.Day_Two_Date__c= system.Date.today().addDays(1);
        insert objSchDate;
        
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
        objContact.SchoolDate__c= objSchDate.Id;
        objContact.Scooter_School_Date__c= system.Date.today();
        insert objContact;
        
        
        objContact.Scooter_School_Completed_Date__c= dtFilter;
        update objContact;
        
        J1emailReminderToScooterPickupBatch objBatch = new J1emailReminderToScooterPickupBatch() ;
        Database.executeBatch(objBatch) ;
        
        System.SchedulableContext sc;
        J1emailReminderToScooterPickupSchedule objSch = new J1emailReminderToScooterPickupSchedule() ;
        objSch.execute(sc) ;
        
    }
    
    
}