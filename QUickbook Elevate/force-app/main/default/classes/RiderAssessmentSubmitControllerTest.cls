@isTest
public class RiderAssessmentSubmitControllerTest {
    
    @isTest
    static void default_Test(){
        
        Test.startTest();
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
        
        apexpages.currentpage().getparameters().put('id',objContact.id);
        RiderAssessmentSubmitController ctrl = new RiderAssessmentSubmitController();
        
        Test.stopTest();
    }
    
    
    @isTest
    static void default_Test_1(){
        
        Test.startTest();
        
        ID J1RecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('J1').getRecordTypeId();
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Rider').getRecordTypeId();
        string riderRecTypeId= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Rider').getRecordTypeId();
        integer noOfDays= integer.valueOf(label.No_Of_Days_for_SS_registration_reminder_Email);
        date dtFilter= system.today().addDays(noOfDays*(-1));
        
        Account objAcc = new Account();
        objAcc.Name  = 'Test Account';
        objAcc.RecordTypeId = accRecordTypeId;
        insert objAcc;
        
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
        
        List<Contact> conList = [SELECT Id,Scooter_School_Date__c,FirstName,LastName,Scooter_School_Completed_Date__c FROM Contact WHERE Scooter_School_Date__c=:null Limit 1];
        if(conList.size()>0){
            apexpages.currentpage().getparameters().put('id',conList[0].id);
            RiderAssessmentSubmitController ctrl = new RiderAssessmentSubmitController();
        }
        Test.stopTest();
    }
    
    @isTest
    static void validateForm_Test(){
        
        Test.startTest();
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
        
        apexpages.currentpage().getparameters().put('id',objContact.id);
        RiderAssessmentSubmitController ctrl = new RiderAssessmentSubmitController();
        ctrl.validateForm();
        ctrl.showFormPanel();
        ctrl.showConfirmPanel();
        ctrl.showCancelPanel();
        
        Test.stopTest();
    }
    
    
    @isTest
    static void showFormPanel_Test(){
        
        Test.startTest();
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
        
        
        List<Contact> conList = [SELECT Id,Scooter_School_Date__c,FirstName,LastName,Scooter_School_Completed_Date__c FROM Contact WHERE Scooter_School_Date__c=:null Limit 200];
        if(conList.size()>0){
            apexpages.currentpage().getparameters().put('id',conList[0].id);
            RiderAssessmentSubmitController ctrl = new RiderAssessmentSubmitController();
            ctrl.showFormPanel();
        }
        Test.stopTest();
    }
    
    
    @isTest
    static void showConfirmPanel_Test(){
        
        Test.startTest();
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
        
        List<Contact> conList = [SELECT Id,Scooter_School_Date__c,FirstName,LastName,Scooter_School_Completed_Date__c FROM Contact WHERE Scooter_School_Date__c=:null Limit 200];
        if(conList.size()>0){
            apexpages.currentpage().getparameters().put('id',conList[0].id);
            RiderAssessmentSubmitController ctrl = new RiderAssessmentSubmitController();
            ctrl.showConfirmPanel();
        }
        Test.stopTest();
    }
    
    @isTest
    static void showCancelPanel_Test(){
        
        Test.startTest();
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
        
        List<Contact> conList = [SELECT Id,Scooter_School_Date__c,FirstName,LastName,Scooter_School_Completed_Date__c FROM Contact WHERE Scooter_School_Date__c=:null Limit 200];
        if(conList.size()>0){
            apexpages.currentpage().getparameters().put('id',conList[0].id);
            RiderAssessmentSubmitController ctrl = new RiderAssessmentSubmitController();
            ctrl.showCancelPanel();
        }
        Test.stopTest();
    }
    
    @isTest
    static void submit_Test(){
        
        Test.startTest();
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
        insert objContact;
        apexpages.currentpage().getparameters().put('id',objContact.id);
        RiderAssessmentSubmitController ctrl = new RiderAssessmentSubmitController();
        ctrl.formFilled = true;
        ctrl.submit();
        
        Test.stopTest();
    }
    
    
    @isTest
    static void sendEmail_Test(){
        
        Test.startTest();
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
        
        apexpages.currentpage().getparameters().put('id',objContact.id);
        RiderAssessmentSubmitController ctrl = new RiderAssessmentSubmitController();
        ctrl.formFilled=true;
        ctrl.sendEmail('Pass','test@abc.com', String.valueOf(objContact.id),objContact.RecordTypeId);
        
        Test.stopTest();
    }
    
    
    @isTest
    static void sendEmail_Test_2(){
        
        Test.startTest();
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
        
        apexpages.currentpage().getparameters().put('id',objContact.id);
        RiderAssessmentSubmitController ctrl = new RiderAssessmentSubmitController();
        ctrl.sendEmail('Need Improvement','test@abc.com', String.valueOf(objContact.id),objContact.RecordTypeId);
        
        Test.stopTest();
    }
    
    @isTest
    static void back_Test(){
        
        Test.startTest();
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
        
        List<Contact> conList = [SELECT Id,Scooter_School_Date__c,FirstName,LastName,Scooter_School_Completed_Date__c FROM Contact WHERE Scooter_School_Date__c=:null Limit 200];
        if(conList.size()>0){
            apexpages.currentpage().getparameters().put('id',conList[0].id);
            RiderAssessmentSubmitController ctrl = new RiderAssessmentSubmitController();
            ctrl.back();
        }
        Test.stopTest();
    }
    
}