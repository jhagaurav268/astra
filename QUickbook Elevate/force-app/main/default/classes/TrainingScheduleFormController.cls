public  without sharing class TrainingScheduleFormController{
    
    public list<selectOption> schoolActiveDateList{get;set;}
    public string selecteDate{get;set;}
    public string contactId;
    public contact conObj{set;get;}
    public boolean contactCreated{get;set;}
    public String studentEmail{set;get;}
    public String studDateOfBirth{set;get;}
    public List<String> errorMessages{set;get;}
    public Date selectedDateonly{set;get;}
    public Boolean displayPopUp{set;get;}
    public String EMAIL_PATTERN = '[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}' ;
    
    public TrainingScheduleFormController(){
        
        schoolActiveDateList = new list<selectOption>();
        errorMessages = new List<String>() ;
        
        conObj = new contact();
        contactCreated = false;
        displayPopUp = false ;
        
        schoolActiveDateList.add(new selectOption('','----None----'));
        
        set<string> listSchoolDates = new set<string>();
        map<string,integer> mapSchooldDateWithCount = new  map<string,integer>();
        
        for(School_Date__c objSchoolDate : [select id,Active__c, From_Date_Time_to_End_Date_time__c ,Day_One_Date__c from School_Date__c where Active__c =: true order by Day_One_Date__c ASC]){
            listSchoolDates.add(objSchoolDate.Id);
        }
        
        string schooldDtId='';
        integer noOfRecs=0;
        for(AggregateResult ARDates:[select SchoolDate__c schooldDate,count(id)noOfRecs from Contact 
                                     where SchoolDate__c in:listSchoolDates group by SchoolDate__c])
        {
            schooldDtId = (string)(ARDates.get('schooldDate')==null?'':ARDates.get('schooldDate'));
            noOfRecs= (integer)(ARDates.get('noOfRecs')==null?'':ARDates.get('noOfRecs'));
            mapSchooldDateWithCount.put(schooldDtId,noOfRecs);
        }
        
        System.debug(mapSchooldDateWithCount);
        for(School_Date__c objSchoolDate : [select id,Active__c, From_Date_Time_to_End_Date_time__c ,Day_One_Date__c from School_Date__c
                                            where Active__c =: true order by Day_One_Date__c ASC])
        {
            
            if(mapSchooldDateWithCount.containsKey(objSchoolDate.Id)){
                if(mapSchooldDateWithCount.get(objSchoolDate.Id) < 8){
                    schoolActiveDateList.add(new selectOption(String.valueOf(objSchoolDate.id+','+objSchoolDate.Day_One_Date__c),objSchoolDate.From_Date_Time_to_End_Date_time__c ));
                }
            }
            else{
                schoolActiveDateList.add(new selectOption(String.valueOf(objSchoolDate.id+','+objSchoolDate.Day_One_Date__c),objSchoolDate.From_Date_Time_to_End_Date_time__c ));
            }
            
        }
        
        
    }
    
    public Pagereference showPopup(){
        errorMessages = new List<String>() ; 
        if(selecteDate != null){
            List<String>  strList = selecteDate.split(',') ;
            if(strList.size() > 1){
                selectedDateonly = Date.valueOf(strList[1]) ;
            }
        }else{
            selectedDateonly  = null ;
            errorMessages.add('Please select a valid training date ') ;
            return null ;
        }
        
        displayPopUp = true ;
        
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
            errorMessages.add('Please select a valid training date ') ;
            return null ;
        }
        
        Date dateofBirth ;
        try{
            dateofBirth = Date.parse(studDateOfBirth) ;
        }catch(Exception e){
            errorMessages.add('Please enter a valid date of birth in format mm/dd/yyyy ') ;
            return null ;
        }
        
        // updated by ankit garg 
        List<Contact> conObjList = [select id,Scooter_School_Date__c,SchoolDate__c, /*Formatted_School_Date__c, Estimated_Jacket_Size__c,*/ Insurance_Verification_Date__c
                                    from contact where email=:studentEmail  AND BirthDate=:dateofBirth];  
        
        if(conObjList.size() > 0 ){
            
            if(conObjList[0].Scooter_School_Date__c != null && conObjList[0].SchoolDate__c != null){
                string mydate = String.valueOf(conObjList[0].Scooter_School_Date__c.format()) ;
                //errorMessages.add('You are already enrolled for the session on '+conObjList[0].Formatted_School_Date__c + '. Call MyCityRides for assistance with changing your date.');
                errorMessages.add('You are already enrolled for the session on '+mydate + '. Call MyCityRides for assistance with changing your date.');
                
                return null ;
            }
            
            if(selecteDate != null){
                List<String>  strList = selecteDate.split(',') ;
                if(strList.size() > 1){
                    conObjList[0].SchoolDate__c = strList[0]; 
                    conObjList[0].Scooter_School_Date__c = Date.valueOF(strList[1]) ;
                }
            }
            
            
            //  conObjList[0].Estimated_Jacket_Size__c = conObj.Estimated_Jacket_Size__c ;
            try{
                update conObjList ;
                contactCreated = true;
            }catch(Exception e){
                system.debug('**message**'+e.getmessage()+ '***line number***'+e.getlinenumber());
                errorMessages.add('Error Occurred '+e.getMessage());
            }
        }else{
            errorMessages.add('No match found - please try with valid email and date of birth used during registration or call MyCityRides for assistance.');
        }        
        
        return null ; 
    }
    
}