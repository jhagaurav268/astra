@isTest
public class J1SignUpFormCtrlTest {
    
    @isTest
    public static void testRiderSignUpPoitiveScenario(){
        
        J1SignUpFormCtrl  con = new J1SignUpFormCtrl() ;
        con.val1 = true ;
        con.val2 = true ;
        con.val3 = true ;
        con.val4 = true ;
        con.mailingLine2 ='test1' ;
        con.otherLine2 = 'testt';
        con.conObj.email = 'abc@gmail.com' ;
        con.conObj.LeadSource='Advertisement';
        con.dob = '12/27/1988' ;
        con.ph1 = '121' ;
        con.ph2 = '234' ;
        con.ph3 = '1234' ;
       // con.empFor90Days = true ;
        
        con.conObj.Have_been_Employed_for_90_Days__c=true;
        con.showPopup() ;
        con.closePopup() ;
        
        con.ssn='121-11-1212';
        con.showPopup() ;
        
        con.submit() ;
        
        
        
        
    }
    
    @isTest
    public static void testRiderSignUpNegativeScenario(){
        
        J1SignUpFormCtrl  con = new J1SignUpFormCtrl() ;
        con.conObj.Do_you_have_a_valid_driver_s_license__c = 'No';
        con.val1 = false ;
        con.val2 = true ;
        con.val3 = true ;
        con.val4 = false ;
        con.conObj.email = 'abc@gmail.com' ;
        con.conObj.LeadSource='Advertisement';
        con.conObj.BirthDate = Date.valueOf('2021-12-12') ;
        con.ph1 = '000' ;
        con.ph2 = '000' ;
        con.ph3 = '0000' ;
        
        // con.showDriverLicenseError() ;
        con.submit() ;
        
        
        
        
    }
    
    
    @isTest
    public static void testRiderSignUpNegativeScenario2(){
        
        J1SignUpFormCtrl  con = new J1SignUpFormCtrl() ;
        con.val1 = true ;
        con.val2 = true ;
        con.val3 = true ;
        con.val4 = true ;
        con.contactCreated = false ;
        con.conObj.email = 'abc@gmail.com' ;
        con.conObj.LeadSource='Advertisement';
        con.conObj.BirthDate = Date.valueOf('2021-12-12') ;
        con.ph1 = '121' ;
        con.ph2 = '234' ;
        con.ph3 = '1234' ;
        con.eph1 = '000' ;
        con.eph2 = '000' ;
        con.eph3 = '0000' ;
        // con.showDriverLicenseError() ;
        con.submit() ;
        
        
        
        
    }
    
    
    @isTest
    public static void testRiderSignUpNegativeScenario3(){
        
        J1SignUpFormCtrl  con = new J1SignUpFormCtrl() ;
        con.val1 = true ;
        con.val2 = true ;
        con.val3 = true ;
        con.val4 = true ;
        con.contactCreated = false ;
        con.conObj.email = 'abc' ;
        con.ph1 = '000' ;
        con.ph2 = '000' ;
        con.ph3 = '0000' ;
        con.conObj.LeadSource='Advertisement';
        // con.showDriverLicenseError() ;
        con.submit() ;
        
        con.conObj.email = 'abc@gmail.com' ;
        con.conobj.Employer_Email__c = 'abc@gmail.com' ;
        con.conObj.Date_of_Hire__c = Date.valueOf('2002-08-05')  ;
        con.conObj.Employer_Contact__c =  '' ;
        con.dateOfHire = '2022-08-05' ; 
        con.conObj.Employer_Contact_Title__c = '' ;
        con.conObj.Birthdate = Date.valueOf('2000-08-05') ; 
        
        con.submit() ;
        Boolean val = con.disableSaveButton ;
        con.captureButtonClick() ;
        
        con.dateOfHire = '12/27/2029';
        con.submit() ;
        
        con.bindInputValues() ;
        con.dummyAction() ;
        
    }
    
    
}