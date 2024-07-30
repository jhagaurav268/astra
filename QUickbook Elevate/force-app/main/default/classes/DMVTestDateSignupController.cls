/*
Updated By : Cmentor/ Sampath Suranji
Date       : 05/27/2020
Description: Updated the code to process when Contact id Query string is blank
*/
public class DMVTestDateSignupController{
    public list<selectOption> ActiveDateList{get;set;}
    public string selecteDate{get;set;}
    public string contactId;
    public boolean contactCreated{get;set;}
    public String studentEmail{set;get;}
    public String studDateOfBirth{set;get;}
    public List<String> errorMessages{set;get;}
    public Date selectedDateonly{set;get;}
    public Boolean displayPopUp{set;get;}
    public String EMAIL_PATTERN = '[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}' ;
    public string conId;
    public string msg{get;set;}
    public boolean isPassmsg{get;set;}
    public Map<String,DMV_Date__c> MapDMVDate; // Added by narveer
    public Boolean SSCDateNull;
    public Boolean isConflict;
    public String conflictionDate; 
    
    public List<Contact> contactList;
    
    public DMVTestDateSignupController(){
        
        conflictionDate = '';
        isConflict = False;
        SSCDateNull = False;
        ActiveDateList = new list<selectOption>();
        errorMessages = new List<String>();   
        contactCreated = false;
        isPassmsg = false;
        displayPopUp = false ;   
        
        contactId = apexpages.currentpage().getparameters().get('id');
        
        ActiveDateList.add(new selectOption('','----None----'));
        MapDMVDate = new Map<String,DMV_Date__c>(); // Added by narveer
        for(DMV_Date__c objDate : [select id,Active__c,Date__c,Location__c from DMV_Date__c where Active__c = 'Yes' order by name ASC]){
           //ActiveDateList.add(new selectOption(objDate.id,String.valueOf(objDate.Date__c)));
           MapDMVDate.put(String.ValueOf(objDate.Date__c),objDate);  // Added by narveer
          // ActiveDateList.add(new selectOption(String.valueOf(objDate.Date__c),String.valueOf(objDate.Date__c)));
           ActiveDateList.add(new selectOption(String.valueOf(objDate.Date__c),String.valueOf(objDate.Date__c)+'('+objDate.Location__c+')'));//updated by Sampath
        }
        
       // System.debug('contactId----'+contactId);
        if(String.isNotBlank(contactId)){
            contactList = [SELECT id,MailingState,(select id,Test_Result__c,Test_Date__c from DMV_Tests__r),Scooter_School_Result__c,Scooter_School_Completed_Date__c FROM Contact WHERE Id=:contactId];
            System.debug('contactList---'+contactList);
            for(Contact con : contactList){
                if(con.Scooter_School_Completed_Date__c == Null){
                    SSCDateNull = True;
                }
                 System.debug(con.DMV_Tests__r+'------contactList---'+con.DMV_Tests__r.isEmpty());
                if(!con.DMV_Tests__r.isEmpty()){
                    for(DMV_Test__c dmvt : con.DMV_Tests__r){
                        if(dmvt.Test_Result__c =='Pass' || String.isEmpty(dmvt.Test_Result__c)){
                            isConflict = True;
                            conflictionDate = String.valueOf(dmvt.Test_Date__c);
                            breaK;
                        }
                    }
                }
            }
        }
        
       // System.debug('SSCDateNull--'+SSCDateNull);
      //  System.debug('isConflict--'+isConflict);
    }   
    
    public Pagereference showPopup(){
        errorMessages = new List<String>() ;
        
        if(selecteDate != null){
            selectedDateonly = Date.valueOf(selecteDate);
        }else {
            selectedDateonly  = null ;
            errorMessages.add('Please select DMV Date') ;
            return null ;
        }
        
        displayPopUp = true;       
        return null ;
    }
    
    public void closePopup() {
        displayPopup = false;
        errorMessages = new List<String>() ;
    }
    
    public PageReference submit(){
        
        errorMessages = new List<String>() ;
        displayPopup = false;
        if(studentEmail == null || Pattern.matches(EMAIL_PATTERN, studentEmail) == false){
            errorMessages.add('Please enter a valid email Id in format abc@mail.com') ;
            return null ;
        }
        
        if(studDateOfBirth == '' ||  studDateOfBirth == null){
            errorMessages.add('Please select date of birth') ;
            return null ;
        } 
        
        if(selecteDate == null || selecteDate == ''){
            errorMessages.add('Please select a valid training date.') ;
            return null ;
        }
        
        Date dateofBirth;
        try{
            dateofBirth = Date.parse(studDateOfBirth) ;
        }catch(Exception e){
            errorMessages.add('Please enter a valid date of birth in format mm/dd/yyyy ') ;
            return null ;
        }
        
        List<Contact> conObjList = [select id,(select id,Test_Result__c,Test_Date__c from DMV_Tests__r),
                                    Scooter_School_Result__c,Scooter_School_Completed_Date__c,MailingState from contact 
                                    where email=:studentEmail AND BirthDate=:dateofBirth And 
                                    RecordTypeId =: Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Rider').getRecordTypeId()];  
        
        if(!conObjList.isEmpty()){
            //when contactId is not provided in URL
            if(contactList==null){
                for(Contact con : conObjList){
                    if(con.Scooter_School_Completed_Date__c == Null){
                        SSCDateNull = True;
                    }
                    
                    if(!con.DMV_Tests__r.isEmpty()){
                        for(DMV_Test__c dmvt : con.DMV_Tests__r){
                            if(dmvt.Test_Result__c =='Pass' || String.isEmpty(dmvt.Test_Result__c)){
                                isConflict = True;
                                conflictionDate = String.valueOf(dmvt.Test_Date__c);
                                breaK;
                            }
                        }
                    }
                }
                
            }
            
            if(SSCDateNull){
                errorMessages.add('Please complete Scooter School before signing up for DMV Date');
            }else if(isConflict){
                errorMessages.add('You have already scheduled your DMV test or may have passed the test. Please email or call My City Rides for assistance with changing your date.');
            } else {
                
                try{
                    DMV_Test__c objDMV = new DMV_Test__c();
                    //objDMV.DMV_Date__c = selecteDate;  // commented by narveer
                    if(MapDMVDate.containsKey(selecteDate)) //  Added by narveer
                    {
                        objDMV.DMV_Date__c = MapDMVDate.get(selecteDate).Id;
                        objDMV.Location__c = MapDMVDate.get(selecteDate).Location__c;
                    }
                    
                    /*if(contactList!=null){
                        if(String.isNotBlank(contactList[0].MailingState) && contactList[0].MailingState == 'TN'){
                            objDMV.Location__c = 'Tennessee_Summer';
                        }else{
                            objDMV.Location__c = 'Mississippi_OliveBranch';
                        }
                    }
                    else{
                        if(String.isNotBlank(conObjList[0].MailingState) && conObjList[0].MailingState == 'TN'){
                            objDMV.Location__c = 'Tennessee_Summer';
                        }else{
                            objDMV.Location__c = 'Mississippi_OliveBranch';
                        }
                    }*/
                    
                    
                    if(String.isNotBlank(selecteDate)){
                        objDMV.Test_Date__c = Date.valueOf(selecteDate);
                    }
                    
                    objDMV.Contact__c = conObjList[0].id;
                    
                    insert objDMV;
                    
                    contactCreated = true;
                }catch(Exception e){
                   // system.debug('**message**'+e.getmessage()+ '***line number***'+e.getlinenumber());
                    errorMessages.add('Error Occurred '+e.getMessage());
                }
            }
            
        }else{
            errorMessages.add('No match found - please try with valid email and date of birth used during registration or call MyCityRides for assistance.');
        }      
        
        return null; 
    }
}