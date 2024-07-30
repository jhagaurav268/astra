/*
This class contains unit tests for validating the behavior of DMVTestDateSignupController Apex class
Updated by : Cmentor/ Sampath Suranji
Date       : 05/27/2020
*/
@isTest
public class DMVTestDateSignupControllerTest {
    
    @testSetup 
    static void testData(){
        
        /****************** Create DMV Date Records ****************/
        
        List<DMV_Date__c> dmvDateList = new List<DMV_Date__c>();
        
        // 0
        dmvDateList.add(
            new DMV_Date__c(
                Active__c = 'Yes',
                Date__c = Date.today()
            )
        );
        
        // 1
        dmvDateList.add(
            new DMV_Date__c(
                Active__c = 'Yes',
                Date__c = Date.today().addDays(1)
            )
        );
        
        // 2
        dmvDateList.add(
            new DMV_Date__c(
                Active__c = 'Yes',
                Date__c = Date.today().addDays(2)
            )
        );
        
        Insert dmvDateList;
        
        
        /****************** Create Contact Records ****************/
        
        ID RecordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Rider').getRecordTypeId();
        // Contact List
        List<Contact> contactList = new List<Contact>();
        
        // 0
        contactList.add(
            new Contact(
                FirstName = 'TestFirst',
                LastName = 'TestLast',
                BirthDate = Date.parse('12/01/2020') ,
                email = 'Test@abc.com',
                Insurance_Verification_Date__c = date.today() ,
                RecordTypeId = RecordType,
                Scooter_School_Date__c = date.today() ,
                Scooter_School_Completed_Date__c = date.today(),
                SS_Classroom_Completed__c=date.today()
            )
        );
        
        // 1
        contactList.add(
            new Contact(
                FirstName = 'TestFirst',
                LastName = 'TestLast',
                Insurance_Verification_Date__c = date.today() ,
                Scooter_School_Date__c = date.today() ,
                Scooter_School_Completed_Date__c = null,
                SS_Classroom_Completed__c=date.today()
            )
        );
        
        // 2
        contactList.add(
            new Contact(
                FirstName = 'TestFirst',
                LastName = 'TestLast',
                BirthDate = Date.parse('12/01/2020') ,
                email = 'Test@abc.com',
                Insurance_Verification_Date__c = date.today() ,
                RecordTypeId = RecordType,
                Scooter_School_Date__c = date.today() ,
                Scooter_School_Completed_Date__c = null,
                SS_Classroom_Completed__c=date.today()
            )
        );
        
        // 3 No conflict record
        contactList.add(
            new Contact(
                FirstName = 'NoConflictFirst',
                LastName = 'NoConflictLast',
                BirthDate = Date.parse('12/01/2020') ,
                email = 'Test@abc.com',
                Insurance_Verification_Date__c = date.today() ,
                RecordTypeId = RecordType,
                Scooter_School_Date__c = date.today() ,
                Scooter_School_Completed_Date__c = date.today(),
                SS_Classroom_Completed__c=date.today()
               
            )
        );
       
       Insert contactList;
        
        /******************* Create DMV Test Records ***********************************/
        
        // DMVTest List
        List<DMV_Test__c> dmvTestList = new List<DMV_Test__c>();
        
        // 0
        dmvTestList.add(
            new DMV_Test__c(
                Contact__c = contactList[0].id,
                Test_Date__c = date.today(),
                Test_Result__c = ''
            )
        );
        
        // 0
        dmvTestList.add(
            new DMV_Test__c(
                Contact__c = contactList[3].id,
                Test_Date__c = date.today(),
                Test_Result__c = 'Fail',
                Driving_Test__c = 'Pass',
                Written_Test__c = 'Fail'
            )
        );
        
        Insert dmvTestList;
    }
    
    @isTest
    static void default_Test(){
        
        Test.startTest();
        List<Contact> conList = [SELECT Id,Scooter_School_Date__c,FirstName,LastName,Scooter_School_Completed_Date__c FROM Contact Limit 200];
        apexpages.currentpage().getparameters().put('id',conList[0].id);
        DMVTestDateSignupController ctrl = new DMVTestDateSignupController();
        Test.stopTest();

    }
    
    @isTest
    static void default_Test_1(){
        
        Test.startTest();
        List<Contact> conList = [SELECT Id,Scooter_School_Date__c,FirstName,LastName,Scooter_School_Completed_Date__c FROM Contact WHERE Scooter_School_Completed_Date__c=: Null Limit 200];
        apexpages.currentpage().getparameters().put('id',conList[0].id);
        DMVTestDateSignupController ctrl = new DMVTestDateSignupController();
        Test.stopTest();
    }
    
    @isTest
    static void showPopup_Test(){
        
        Test.startTest();
        List<Contact> conList = [SELECT Id,Scooter_School_Date__c,FirstName,LastName,Scooter_School_Completed_Date__c FROM Contact Limit 200];
        apexpages.currentpage().getparameters().put('id',conList[0].id);
        DMVTestDateSignupController ctrl = new DMVTestDateSignupController();
        ctrl.showPopup();
        Test.stopTest();
        
    }
    
    @isTest
    static void showPopup_Test_1(){
        
        Test.startTest();
        List<Contact> conList = [SELECT Id,Scooter_School_Date__c,FirstName,LastName,Scooter_School_Completed_Date__c FROM Contact Limit 200];
        apexpages.currentpage().getparameters().put('id',conList[0].id);
        DMVTestDateSignupController ctrl = new DMVTestDateSignupController();
        ctrl.selecteDate = String.valueOf(Date.today());
        ctrl.showPopup();
        Test.stopTest();
        
    }
    
    @isTest
    static void closePopup_Test(){
        
        Test.startTest();
        List<Contact> conList = [SELECT Id,Scooter_School_Date__c,FirstName,LastName,Scooter_School_Completed_Date__c FROM Contact Limit 200];
        apexpages.currentpage().getparameters().put('id',conList[0].id);
        DMVTestDateSignupController ctrl = new DMVTestDateSignupController();
        ctrl.closePopup();
        Test.stopTest();
        
    }
    
    
    @isTest
    static void submit_Test(){
        
        Test.startTest();
        List<Contact> conList = [SELECT Id,Scooter_School_Date__c,FirstName,LastName,Scooter_School_Completed_Date__c FROM Contact Limit 200];
        apexpages.currentpage().getparameters().put('id',conList[0].id);
        DMVTestDateSignupController ctrl = new DMVTestDateSignupController();
        ctrl.submit();
        Test.stopTest();
        
    }
    
    @isTest
    static void submit_Test_1(){
        
        Test.startTest();
        List<Contact> conList = [SELECT Id,Scooter_School_Date__c,FirstName,LastName,Scooter_School_Completed_Date__c FROM Contact Limit 200];
        apexpages.currentpage().getparameters().put('id',conList[0].id);
        DMVTestDateSignupController ctrl = new DMVTestDateSignupController();
        ctrl.studentEmail = 'Test@abc.com';
        ctrl.submit();
        Test.stopTest();
        
    }
    
    @isTest
    static void submit_Test_2(){
        
        Test.startTest();
        List<Contact> conList = [SELECT Id,Scooter_School_Date__c,FirstName,LastName,Scooter_School_Completed_Date__c FROM Contact Limit 200];
        apexpages.currentpage().getparameters().put('id',conList[0].id);
        DMVTestDateSignupController ctrl = new DMVTestDateSignupController();
        ctrl.studentEmail = 'Test@abc.com';
        ctrl.studDateOfBirth = String.valueOf(Date.today());
        ctrl.submit();
        Test.stopTest();
        
    }
    
    @isTest
    static void submit_Test_3(){
        
        Test.startTest();
        List<Contact> conList = [SELECT Id,Scooter_School_Date__c,FirstName,LastName,Scooter_School_Completed_Date__c FROM Contact Limit 200];
        apexpages.currentpage().getparameters().put('id',conList[0].id);
        DMVTestDateSignupController ctrl = new DMVTestDateSignupController();
        ctrl.studentEmail = 'Test@abc.com';
        ctrl.studDateOfBirth = String.valueOf(Date.today());
        ctrl.selecteDate = String.valueOf(Date.today());
        ctrl.submit();
        Test.stopTest();
        
    }
    
    @isTest
    static void submit_Test_4(){
        
        Test.startTest();
        List<Contact> conList = [SELECT Id,Scooter_School_Date__c,FirstName,LastName,Scooter_School_Completed_Date__c FROM Contact Limit 200];
        apexpages.currentpage().getparameters().put('id',conList[0].id);
        DMVTestDateSignupController ctrl = new DMVTestDateSignupController();
        ctrl.studentEmail = 'Test@abc.com';
        ctrl.studDateOfBirth = '12/01/2020';  // mm/dd/yyyy
        ctrl.selecteDate = String.valueOf(Date.today());
        ctrl.submit();
        Test.stopTest();
        
    }

    @isTest
    static void submit_Test_5(){
        
        Test.startTest();
        List<Contact> conList = [SELECT Id,Scooter_School_Date__c,FirstName,LastName,Scooter_School_Completed_Date__c FROM Contact WHERE Email != Null Limit 200];
        apexpages.currentpage().getparameters().put('id',conList[0].id);
        DMVTestDateSignupController ctrl = new DMVTestDateSignupController();
        ctrl.studentEmail = 'Test@abc.com';
        ctrl.studDateOfBirth = '12/01/2020';  // mm/dd/yyyy
        ctrl.selecteDate = String.valueOf(Date.today());
        ctrl.submit();
        Test.stopTest();
        
    }
    
    @isTest
    static void submit_Test_6(){
        
        Test.startTest();
        List<Contact> conList = [SELECT Id,Scooter_School_Date__c,FirstName,LastName,Scooter_School_Completed_Date__c FROM Contact WHERE Email != Null AND Scooter_School_Completed_Date__c=:null Limit 200];
        apexpages.currentpage().getparameters().put('id',conList[0].id);
        DMVTestDateSignupController ctrl = new DMVTestDateSignupController();
        ctrl.studentEmail = 'Test@abc.com';
        ctrl.studDateOfBirth = '12/01/2020';  // mm/dd/yyyy
        ctrl.selecteDate = String.valueOf(Date.today());
        ctrl.submit();
        Test.stopTest();
        
    }
    
    @isTest
    static void submit_Test_7(){
        
        Test.startTest();
        List<Contact> conList = [SELECT Id,Scooter_School_Date__c,FirstName,LastName,Scooter_School_Completed_Date__c FROM Contact WHERE LastName=:'NoConflictLast' Limit 200];
        apexpages.currentpage().getparameters().put('id',conList[0].id);
        DMVTestDateSignupController ctrl = new DMVTestDateSignupController();
        ctrl.studentEmail = 'Test@abc.com';
        ctrl.studDateOfBirth = '12/01/2020';  // mm/dd/yyyy
        ctrl.selecteDate = String.valueOf(Date.today());
        ctrl.submit();
        Test.stopTest();
        
    }
    
     @isTest
    static void submit_Test_8(){
        
        Test.startTest();
        List<Contact> conList = [SELECT Id,Scooter_School_Date__c,FirstName,LastName,Scooter_School_Completed_Date__c FROM Contact WHERE LastName=:'NoConflictLast' Limit 200];
        //apexpages.currentpage().getparameters().put('id',conList[0].id);
        DMVTestDateSignupController ctrl = new DMVTestDateSignupController();
        ctrl.studentEmail = 'Test@abc.com';
        ctrl.studDateOfBirth = '12/01/2020';  // mm/dd/yyyy
        ctrl.selecteDate = String.valueOf(Date.today());
        ctrl.submit();
        Test.stopTest();
        
    }

}