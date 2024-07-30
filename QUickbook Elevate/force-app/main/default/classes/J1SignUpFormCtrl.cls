/*
Name             : J1SignUpFormCtrl 
Author           :
Date             : 12/02/2023
Description      : J1 Form Controller Class we are using to Save the data from Sign up Form on site

*/


public without sharing class J1SignUpFormCtrl {
    public contact conObj{get;set;}
    public String ph1{get;set;}
    public String ph2{get;set;}
    public String ph3{get;set;}
    
    public String mob1{get;set;}
    public String mob2{get;set;}
    public String mob3{get;set;}
    
    public String ssn{set;get;}
    public String eph1{get;set;}
    public String eph2{get;set;}
    public String eph3{get;set;}
    
    public String mailingLine2{get;set;}
    public String mailingPostalCode{get;set;}
    public String sponsormailingLine2{get;set;}
    
    
    public String otherLine2{get;set;}
    public String dob{set;get;}
    public String arvltoBransonDate{set;get;}
    public String depFromBransonDate{set;get;}
    
    public String error{get;set;}
    public boolean val1{get;set;}
    public boolean val2{get;set;}
    public boolean val3{get;set;}
    public boolean val4{set;get;}
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
    
    public J1SignUpFormCtrl() {
        conObj = new contact();
        error ='';
        allErrors = false;
        mailingLine2 = '';
        mailingPostalCode='';
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
            fileUploadURL= label.Flyer_File_Upload_URL_SB_J1;
        }
        else{
            fileUploadURL= label.Flyer_File_Upload_URL_J1;
        }
        
    }
    
    public PageReference showPopup(){
        errorMessages = new List<String>() ;
        displayPopUp = false ;
        
        
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
        
        
        displayPopUp = true ;
        errorMessages = new List<String>() ;
        system.debug('displayPopUp='+displayPopUp);
        return null ;
    }
    
    public PageReference bindInputValues(){
        system.debug('called bindInputValues');
        try{
            string dobNew= Apexpages.currentPage().getParameters().get('dobVal');
            string ph1New= Apexpages.currentPage().getParameters().get('ph1Val');
            string ph2New= Apexpages.currentPage().getParameters().get('ph2Val');
            string ph3New= Apexpages.currentPage().getParameters().get('ph3Val');
            string mob1New= Apexpages.currentPage().getParameters().get('mob1Val');
            string mob2New= Apexpages.currentPage().getParameters().get('mob2Val');
            string mob3New= Apexpages.currentPage().getParameters().get('mob3Val');
            string arvltoBransonDateNew = Apexpages.currentPage().getParameters().get('arvltoBransonDate');
            string depFromBransonDateNew = Apexpages.currentPage().getParameters().get('depFromBransonDate'); 
            string postal1New= Apexpages.currentPage().getParameters().get('postal1Val');
            
            
            string postalHireNew= Apexpages.currentPage().getParameters().get('postalHireVal');
            
            dob= dobNew==null?'':dobNew;
            ph1= ph1New==null?'':ph1New;
            ph2= ph2New==null?'':ph2New;
            ph3= ph3New==null?'':ph3New;
            
            mob1= mob1New==null?'':mob1New;
            mob2= mob2New==null?'':mob2New;
            mob3= mob3New==null?'':mob3New;
            
           
            arvltoBransonDate = arvltoBransonDateNew==null?'':arvltoBransonDateNew;
            depFromBransonDate = depFromBransonDateNew==null?'':depFromBransonDateNew;
            
            conObj.MailingPostalCode   = postal1New==null?'':postal1New;
            
            
            if(postalHireNew!=null){
                conObj.Workplace_Postal_Code__c   = decimal.valueOf(postalHireNew );
            }
            
            errorMessages = new List<String>() ;
            
            System.debug('End bindInputValues');
            
        }
        catch(Exception ex){}
        
        return null ;
    }
    
    public void closePopup() {
        displayPopup = false;
        errorMessages = new List<String>() ;
    }
    
    
    
    public PageReference submit() {
        system.debug('called submit');
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
            
            conObj.RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('J1').getRecordTypeId();
            
            conObj.Phone = (ph1!=null? '('+ph1+') ':'')+ '' +(ph2!=null?ph2+'-':'')+ '' +(ph3!=null?ph3+'':'');
            
            if(conObj.Is_the_mobile_no_given__c == 'Yes'){
                conObj.MobilePhone = conObj.Phone ;
            }
            else{
                if(!string.isempty(mob1) && !string.isempty(mob2)){
                    conObj.MobilePhone = (mob1!=null? '('+mob1+') ':'')+ '' +(mob2!=null?mob2+'-':'')+ '' +(mob3!=null?mob3+'':'');
                }
            }
            
            conObj.Employer_Phone_number__c = (eph1!=null? '('+eph1+') ':'')+ '' +(eph2!=null?eph2+'-':'')+ '' +(eph3!=null? eph3+'':'');
            
            if(dob != null && dob != ''){
                try{
                    conObj.Birthdate = Date.parse(dob) ;
                }
                catch(Exception ex){
                    errorMessages.add('Invalid value for Date of Birth.') ;
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
            
            if(arvltoBransonDate != null && arvltoBransonDate != ''){
                try{
                    conObj.Arrival_To_Branson_Date__c = Date.parse(arvltoBransonDate) ;
                }
                catch(Exception ex){
                    errorMessages.add('Invalid date for Arrival to Branson Date.') ;
                    return null ;
                }
                
            }
            
            if(depFromBransonDate != null && depFromBransonDate != ''){
                try{
                    conObj.Departure_From_Branson_Date__c = Date.parse(depFromBransonDate) ;
                }
                catch(Exception ex){
                    errorMessages.add('Invalid date for  Departure from Branson Date.') ;
                    return null ;
                }
                
                if( Date.parse(depFromBransonDate) < System.Today()){
                    errorMessages.add('The Departure from Branson Date cannot be a past Date.') ;
                    return null ;
                }
            }
            
            
            if(conObj.Arrival_To_Branson_Date__c!=null && conObj.Departure_From_Branson_Date__c!=null){
                if(conObj.Arrival_To_Branson_Date__c  > conObj.Departure_From_Branson_Date__c){
                    errorMessages.add('The Departure from Branson Date should be later than Arrival to Branson Date.') ;
                    return null ;
                }
            }
            
            if(mailingLine2 !=null ){
                tempMailingStreet  = conObj.MailingStreet ;
                conObj.MailingStreet = (conObj.MailingStreet !=null?conObj.MailingStreet:' ') + ' '+mailingLine2+' ';
                
            }
            if(otherLine2!=null ){
                tempOtherStreet = conObj.OtherStreet ;
                string homeStreet = conObj.Home_Country_Street_JI__c;
                conObj.Home_Country_Address_2_J1__c=  otherLine2;
                // conObj.Home_Country_Address_2_J1__c= (homeStreet!=null?homeStreet:' ')+ ' '+otherLine2;
                //conObj.Home_Country_Street_JI__c='';
                // conObj.OtherStreet = (conObj.OtherStreet!=null?conObj.OtherStreet:'') + ' '+otherLine2+' ';
            }
            
            
            
            if(errorMessages.size() == 0){
                conObj.AccountId =  Label.RegistrationAccount ;
                
                // updated by ankit garg 
                List<Contact> conObjList = [select id from contact where email=:conObj.email  AND BirthDate=:conObj.Birthdate];  
                
                
                if(conObjList.size() > 0 ){
                    errorMessages.add('Duplicate registration. Please contact branson for assistance.') ;
                    return null ;
                }
                
                if(conObj.Valid_Class_M_endorsement__c == null || conObj.Valid_Class_M_endorsement__c == ''){
                    conObj.Valid_Class_M_endorsement__c = 'No';
                }
                
                //Maintain 1:1 with Rider contact and Account
                sp = database.setSavepoint();
                
                Account objAccount = new Account();
                objAccount.Name= conObj.firstname+ ' '+ conObj.LastName ;
                objAccount.SSFCU__c = true ;
                
                objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('J1').getRecordTypeId();
                insert objAccount;
                
                List<Account> accDetail = [Select id , Name , Account_Number__c from Account where id=:objAccount.Id] ;
                
                if(accDetail.size() > 0){
                    objAccount.Name =    objAccount.Name + ' ' + accDetail[0].Account_Number__c ; 
                }
                
                conObj.MailingState = conObj.Mailing_State_PickList__c ;
                conObj.Workplace_State__c =   conObj.Employer_State_PickList__c ;
                //conObj.OtherState = conObj.OtherState_PickList__c ;
                conObj.Drivers_License_State__c = conObj.Drivers_License_State_PickList__c ;
                
                if(conObj.Do_you_have_a_valid_driver_s_license__c=='No'){
                    conObj.Drivers_License_Number_with_state__c=null;
                    conObj.Drivers_License_Country__c=null;
                    conObj.Drivers_License_State_PickList__c=null;
                }
                
                conObj.AccountId = objAccount.Id;
                conObj.Program_Name__c = 'J1' ;
                
                system.debug( conObj.MobilePhone);
                insert conObj;
                
                contactCreated = true;
                
                objAccount.Rider_Contact__c = conObj.Id;
                update objAccount;
                
                
            }
        } catch(Exception e) {
            
            conObj.MailingStreet = tempMailingStreet ;
            //conObj.OtherStreet  = tempOtherStreet ;
            
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
        
        errorMessages = new List<String>() ;
        
        
        return null ;
        
        
    }
}