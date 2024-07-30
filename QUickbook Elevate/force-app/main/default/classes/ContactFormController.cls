/*
Name             : ContactFormControllerOld
Author           :
Date             : 06/29/2017
Description      : Contact Form Controller Class we are using to Save the data from Sign up Form
// Updated by ankit garg to as per the rquirement and best practice
// @date latest updated 20/07/2018

Updated by   : Sampath Suranji
Description  : Maintain 1:1 relationship with rider contact and rider account
Updated date : 04/12/2019

Updated by   : Sampath Suranji
Description  : Add Lead Source picklist
Updated date : 06/06/2019

Updated by   : Sampath Suranji
Description  : Update Valid_Class_M_endorsement__c field
Updated date : 08/07/2019

*/
public class ContactFormController {
    public contact conObj{get;set;}
    public String ph1{get;set;}
    public String ph2{get;set;}
    public String ph3{get;set;}
    
    public String mob1{get;set;}
    public String mob2{get;set;}
    public String mob3{get;set;}
    
    public String ssn{set;get;}
    
    public String Ref1ph1{get;set;}
    public String Ref1ph2{get;set;}
    public String Ref1ph3{get;set;}
    
    public String Ref2ph1{get;set;}
    public String Ref2ph2{get;set;}
    public String Ref2ph3{get;set;}
    
    public String eph1{get;set;}
    public String eph2{get;set;}
    public String eph3{get;set;}
    
    public String mailingLine2{get;set;}
    public String otherLine2{get;set;}
    public String dob{set;get;}
    public String error{get;set;}
    public boolean val1{get;set;}
    public boolean val2{get;set;}
    public boolean val3{get;set;}
    public boolean val4{set;get;}
    public boolean empFor90Days{get;set;}
    public boolean agreeDisclosure{get;set;}
    
    public set<string> setFinanceOption = new Set<string>();
    public string fieldname;
    public boolean contactCreated{get;set;}
    public boolean allErrors{get;set;}
    public Boolean displayPopUp{set;get;}
    public List<String> errorMessages{set;get;}
    public String EMAIL_PATTERN = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})' ;
    public String tempMailingStreet ;
    public String tempOtherStreet ;
    public String dateOfHire{set;get;}
    public string fileUploadURL{get;set;}
    
    
    @TestVisible
    private boolean hasBeenClickedAlready = false;
    
    public PageReference captureButtonClick() {
        hasBeenClickedAlready = true;
        return null;
    }
    public Boolean disableSaveButton {
        get {
            return hasBeenClickedAlready;
        }
    }
    
    public ContactFormController() {
        conObj = new contact();
        error ='';
        allErrors = false;
        mailingLine2 = '';
        otherLine2 = '' ;
        dob = '' ; 
        error = '' ;
        errorMessages = new List<String>() ;
        displayPopUp = false ;
        tempMailingStreet = '' ;
        tempOtherStreet  = '' ;
        agreeDisclosure = false ;
        
        boolean isSB=false;
        list<organization> listOrg=[SELECT IsSandbox FROM Organization LIMIT 1];
        if(listOrg.size()>0){
            if(listOrg[0].IsSandbox){
                isSB=true;
            }
        }
        
        if(isSB){
             fileUploadURL= label.Flyer_File_Upload_URL_SB;
        }
        else{
             fileUploadURL= label.Flyer_File_Upload_URL;
        }
       
    }
    
    public PageReference showPopup(){
        errorMessages = new List<String>() ;
        displayPopUp = false ;
        //system.debug('conObj.email='+conObj.email);
        //system.debug('ssn='+ssn);
        
        if( Pattern.matches(EMAIL_PATTERN, conObj.email) == false){
            errorMessages.add('Please enter a valid email Id in format abc@mail.com') ;
            return null ;
        }
        
        if(ph1 == '000' && ph2 == '000' && ph3 == '0000'){
            errorMessages.add('Please enter the correct phone number.') ;
            return null ;
        }
        if(mob1 == '000' && mob2 == '000' && mob3 == '0000'){
            errorMessages.add('Please enter the correct mobile number.') ;
            return null ;
        }
        
 
        
        if(ssn == null || ssn == ''){
            errorMessages.add('Please enter the social security number.') ;
            return null ;
        }
    
        String ssnText = ssn.replace('-', '') ;
        Integer ssnLen = ssnText.length() ;
        if(ssnLen < 9 ){
            errorMessages.add('Please enter the valid social security number.') ;
            return null ;
            
        }   
        
        String ref1Name = conObj.Reference_1_Name__c ;
        String ref2Name = conObj.Reference_2_Name__c ;
        
       /*
        if(ref1Name != null && ref1Name.trim().length() < 4){
            errorMessages.add('Reference 1 Name must contain at least 4 characters') ;
            return null ;
        }
        
        if(ref2Name != null && ref2Name.trim().length() < 4){
            errorMessages.add('Reference 2 Name must contain at least 4 characters') ;
            return null ;
        }
        
        if(Ref1ph1 == '000' && Ref1ph2 == '000' && Ref1ph3 == '0000'){
            errorMessages.add('Please enter the correct Reference 1 Phone number.') ;
            return null ;
        }
        
        if(Ref2ph1 == '000' && Ref2ph2 == '000' && Ref2ph3 == '0000'){
            errorMessages.add('Please enter the correct Reference 2 phone number.') ;
            return null ;
        }
        
        if(string.isempty(conObj.Reference_1_Relationship__c)){
            errorMessages.add('Relationship is required at Reference 1.') ;
            return null ;
        }
        if(string.isempty(conObj.Reference_2_Relationship__c)){
            errorMessages.add('Relationship is required at Reference 2.') ;
            return null ;
        }
        if( conObj.Reference_1_Zip_Code__c ==null){
            errorMessages.add('Zip Code is required at Reference 1.') ;
            return null ;
        }
        if( conObj.Reference_2_Zip_Code__c ==null){
            errorMessages.add('Zip Code is required at Reference 2.') ;
            return null ;
        }  */
        
        
        displayPopUp = true ;
        errorMessages = new List<String>() ;
        system.debug('displayPopUp='+displayPopUp);
        return null ;
    }
    
    public PageReference bindInputValues(){
        try{
            string ssnNew= Apexpages.currentPage().getParameters().get('ssnVal');
            string dobNew= Apexpages.currentPage().getParameters().get('dobVal');
            string ph1New= Apexpages.currentPage().getParameters().get('ph1Val');
            string ph2New= Apexpages.currentPage().getParameters().get('ph2Val');
            string ph3New= Apexpages.currentPage().getParameters().get('ph3Val');
            string mob1New= Apexpages.currentPage().getParameters().get('mob1Val');
            string mob2New= Apexpages.currentPage().getParameters().get('mob2Val');
            string mob3New= Apexpages.currentPage().getParameters().get('mob3Val');
          
           /*
            string Ref1ph1New= Apexpages.currentPage().getParameters().get('Ref1ph1Val');
            string Ref1ph2New= Apexpages.currentPage().getParameters().get('Ref1ph2Val');
            string Ref1ph3New= Apexpages.currentPage().getParameters().get('Ref1ph3Val');
            string Ref2ph1New= Apexpages.currentPage().getParameters().get('Ref2ph1Val');
            string Ref2ph2New= Apexpages.currentPage().getParameters().get('Ref2ph2Val');
            string Ref2ph3New= Apexpages.currentPage().getParameters().get('Ref2ph3Val'); */
            
            string postalNew= Apexpages.currentPage().getParameters().get('postalVal');
            string postal1New= Apexpages.currentPage().getParameters().get('postal1Val');
            /*
            string postalRef1New= Apexpages.currentPage().getParameters().get('postalRef1Val');
            string postalRef2New= Apexpages.currentPage().getParameters().get('postalRef2Val'); */
            
            
            string postalHireNew= Apexpages.currentPage().getParameters().get('postalHireVal');
            
            ssn= ssnNew==null?'':ssnNew;
            dob= dobNew==null?'':dobNew;
            ph1= ph1New==null?'':ph1New;
            ph2= ph2New==null?'':ph2New;
            ph3= ph3New==null?'':ph3New;
            
            mob1= mob1New==null?'':mob1New;
            mob2= mob2New==null?'':mob2New;
            mob3= mob3New==null?'':mob3New;
          
           /* Ref1ph1= Ref1ph1New==null?'':Ref1ph1New;
            Ref1ph2= Ref1ph2New==null?'':Ref1ph2New;
            Ref1ph3= Ref1ph3New==null?'':Ref1ph3New;
            Ref2ph1= Ref2ph1New==null?'':Ref2ph1New;
            Ref2ph2= Ref2ph2New==null?'':Ref2ph2New;
            Ref2ph3= Ref2ph3New==null?'':Ref2ph3New; */
            
            
            conObj.MailingPostalCode  = postalNew==null?'':postalNew;
            conObj.OtherPostalCode   = postal1New==null?'':postal1New;
           
           /*
            if(postalRef1New!=null){
                conObj.Reference_1_Zip_Code__c   = decimal.valueOf(postalRef1New );
            }
            if(postalRef2New!=null){
                conObj.Reference_2_Zip_Code__c   = decimal.valueOf(postalRef2New );
            }  */
            
            
            if(postalHireNew!=null){
                conObj.Workplace_Postal_Code__c   = decimal.valueOf(postalHireNew );
            }
            
            errorMessages = new List<String>() ;
            
            
        }
        catch(Exception ex){}
        
        return null ;
    }
    
    public void closePopup() {
        displayPopup = false;
        errorMessages = new List<String>() ;
    }
    
   
    public PageReference submit() {
        savepoint sp;
        try{
            error = '';
            displayPopup = false;
            Decimal countFinCheck = 0  ;
            conObj.Financing_option__c = '' ;
            fieldname = 'onsubmit';
            errorMessages = new List<String>() ;
            
            if(val1 == true) {
                conObj.Financing_option__c ='Payroll deduction if offered by my employer';
            }
            
            if(val4 == true){
                if(conObj.Financing_option__c !='' ) {
                    conObj.Financing_option__c+=';';
                }
                conObj.Financing_option__c+='Putting a card (credit/debit) on file for a monthly recurring payment';
            }
            
            conObj.RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Rider').getRecordTypeId();
            conObj.Phone = (ph1!=null? '('+ph1+') ':'')+ '' +(ph2!=null?ph2+'-':'')+ '' +(ph3!=null?ph3+'':'');
            
            if(conObj.Is_the_mobile_no_given__c == 'Yes'){
                conObj.MobilePhone = conObj.Phone ;
            }else{
                conObj.MobilePhone = (mob1!=null? '('+mob1+') ':'')+ '' +(mob2!=null?mob2+'-':'')+ '' +(mob3!=null?mob3+'':'');
            }
            
            
            //conObj.Reference_1_Phone__c  = (Ref1ph1!=null? '('+Ref1ph1+') ':'')+ '' +(Ref1ph2!=null?Ref1ph2+'-':'')+ '' +(Ref1ph3!=null?Ref1ph3+'':'');
            //conObj.Reference_2_Phone__c  = (Ref2ph1!=null? '('+Ref2ph1+') ':'')+ '' +(Ref2ph2!=null?Ref2ph2+'-':'')+ '' +(Ref2ph3!=null?Ref2ph3+'':'');
            
            conObj.Employer_Phone_number__c = (eph1!=null? '('+eph1+') ':'')+ '' +(eph2!=null?eph2+'-':'')+ '' +(eph3!=null? eph3+'':'');
            
            if(dob != null && dob != ''){
                try{
                    conObj.Birthdate = Date.parse(dob) ;
                }
                catch(Exception ex){
                    errorMessages.add('Invalid Date of Birth.') ;
                    return null ;
                }
                
            }
            
            if(conObj.Birthdate > DATE.TODAY()){
                errorMessages.add('The date of birth cannot be in future.') ;
                return null ;
            }
            
            Integer days = (conObj.Birthdate).daysBetween(Date.Today());
            Integer age = Integer.valueOf(days/365);
            
            if(age < 18){
                errorMessages.add('The date of birth can not be minor.') ;
                return null ;
            }
            
            try{
                if(dateOfHire != null){
                    conobj.Date_Of_Hire__c = Date.parse(dateOfHire) ;
                }
            }catch(Exception e){
                errorMessages.add('Please enter a valid date of hire in format mm/dd/yyyy ') ;
                return null ;
            }
            
            if(conObj.Date_of_Hire__c != null && Integer.valueOf((conObj.Date_of_Hire__c).year()) > System.Today().year()){
                errorMessages.add('The date of hire cannot be in the furure.') ;
                return null ;
            }
            
            if(conObj.Employer_Contact__c != null && conObj.Employer_Contact__c != '' && conObj.Employer_Contact__c.length() < 2){
                errorMessages.add('Please enter the correct value for employer contact') ;
                return null ;
            }
            
            
            
            if(conObj.Employer_Contact_Title__c != null && conObj.Employer_Contact_Title__c != '' && conObj.Employer_Contact_Title__c.length() < 2){
                errorMessages.add('Please enter the correct value for employer contact title') ;
                return null ;
            }
            
            
            System.debug('-------------'+conObj.Birthdate) ;
            if(mailingLine2 !=null ){
                tempMailingStreet  = conObj.MailingStreet ;
                conObj.MailingStreet = (conObj.MailingStreet !=null?conObj.MailingStreet:' ') + ' '+mailingLine2+' ';
                
            }
            if(otherLine2!=null ){
                tempOtherStreet = conObj.OtherStreet ;
                conObj.OtherStreet = (conObj.OtherStreet!=null?conObj.OtherStreet:'') + ' '+otherLine2+' ';
            }
            
            if(empFor90Days){
                conObj.Have_been_Employed_for_90_Days__c=true;
            }
            
            
            if(errorMessages.size() == 0){
                conObj.AccountId =  Label.RegistrationAccount ;
                
                // updated by ankit garg 
                List<Contact> conObjList = [select id from contact where email=:conObj.email  AND BirthDate=:conObj.Birthdate];  
                
                
                if(conObjList.size() > 0 ){
                    errorMessages.add('Duplicate registration. Please contact MyCityRides for assistance.') ;
                    return null ;
                }
                
                if(conObj.Valid_Class_M_endorsement__c == null || conObj.Valid_Class_M_endorsement__c == ''){
                    conObj.Valid_Class_M_endorsement__c = 'No';
                }
                //Maintain 1:1 with Rider contact and Account
                sp = database.setSavepoint();
                Account objAccount = new Account();
                // objAccount.Name= conObj.firstname+ '-'+ conObj.LastName + '-'+ String.valueOf(dob).replace('/','');
                objAccount.Name= conObj.firstname+ ' '+ conObj.LastName ;
                objAccount.SSFCU__c = true ;
                
                objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Rider').getRecordTypeId();
                insert objAccount;
                // fetch the account Number
                
                List<Account> accDetail = [Select id , Name , Account_Number__c from Account where id=:objAccount.Id] ;
                if(accDetail.size() > 0){
                    // conObj.LastName =   conObj.LastName +' '+  accDetail[0].Account_Number__c ; 
                    objAccount.Name =    objAccount.Name + ' ' + accDetail[0].Account_Number__c ; 
                }
                
                conObj.Loan_Disclosure_Accepted__c =  agreeDisclosure ;
                conObj.MailingState = conObj.Mailing_State_PickList__c ;
                //conObj.Reference_2_State__c = conObj.Reference_2_State_PickList__c;
               // conObj.Reference_1_State__c = conObj.Reference_1_State_PickList__c ;
                conObj.Workplace_State__c =   conObj.Employer_State_PickList__c ;
                conObj.OtherState = conObj.OtherState_PickList__c ;
                conObj.Drivers_License_State__c = conObj.Drivers_License_State_PickList__c ;
                
                conObj.AccountId = objAccount.Id;
                
                conObj.Social_Security_Number__c = ssn ;
                System.debug('-------'+conObj.Social_Security_Number__c) ;
                
                if(conObj.Do_you_have_a_valid_driver_s_license__c=='Yes'){
                    conObj.State_ID_Number__c=null;
                    conObj.State_ID_State__c=null;
                }
                
                if(conObj.Do_you_have_a_valid_driver_s_license__c=='No'){
                    conObj.Drivers_License_State__c=null;
                    conObj.Drivers_License_Number_with_state__c=null;
                }
                
                if(conObj.Do_you_have_a_State_ID__c =='No'){
                    conObj.State_ID_Number__c=null;
                    conObj.State_ID_State__c=null;
                }
                
                insert conObj;
                
                contactCreated = true;
                
                objAccount.Rider_Contact__c = conObj.Id;
                update objAccount;
                
                
            }
        } catch(Exception e) {
            
            conObj.MailingStreet = tempMailingStreet ;
            conObj.OtherStreet  = tempOtherStreet ;
            
            if(e.getMessage().contains('DUPLICATES_DETECTED')){
                errorMessages.add('Your information already exists in our database.') ;
                
            }else{
                errorMessages.add('Error occurrred '+e.getMessage()) ;
            }
            if(sp!=null){
                Database.rollback(sp);
            }
            
            system.debug('**E**'+e.getmessage()+'***l**'+e.getlinenumber());
        }
        return null ;
    }
    
    public pagereference dummyAction(){
        system.debug('called dmmy');
        
        errorMessages = new List<String>() ;
      
        
       /*
        if(string.isempty(conObj.Reference_1_Relationship__c)){
            errorMessages.add('Relationship is required at Reference 1.') ;
            return null ;
        }
        if(string.isempty(conObj.Reference_2_Relationship__c)){
            errorMessages.add('Relationship is required at Reference 2.') ;
            return null ;
        }
        if( conObj.Reference_1_Zip_Code__c ==null){
            errorMessages.add('Zip Code is required at Reference 1.') ;
            return null ;
        }
        if( conObj.Reference_2_Zip_Code__c ==null){
            errorMessages.add('Zip Code is required at Reference 2.') ;
            return null ;
        }  */
        //displayPopUp = true ;
        errorMessages = new List<String>() ;
        system.debug('displayPopUp='+displayPopUp);
        return null ;
        
        
    }
}