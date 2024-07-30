@istest
class TrainingScheduleFormControllerTest{
    
    
    @istest
    public static void TraningSchedulePositiveScenario(){
        
        Account a = new Account(name='test acc',phone='9494146144');
        insert a;
        Contact con = new Contact(accountid=a.id,lastname='test con',BirthDate=date.valueof('1988-01-01') ,  email='abc@gmail.com');
        insert con;
        
        School_Date__c sdate = new School_Date__c() ;
        sdate.Active__c = true ;
        sdate.Day_One_Date__c = Date.parse('01/01/1988') ;
        
        insert sdate ;
        
        TrainingScheduleFormController tc = new TrainingScheduleFormController() ;
        
        tc.studentEmail = 'abc@gmail.com' ;
        tc.studDateOfBirth= '01/01/1988' ;
        
        tc.showPopup() ;
        tc.selecteDate = sdate.id+','+'1988-01-01' ;
        tc.closePopup() ;
        tc.submit() ;
        
    }
    
    
    @istest
    public static void TraningScheduleNegativeScenario(){
        
        Account a = new Account(name='test acc',phone='9494146144');
        insert a;
        Contact con = new Contact(accountid=a.id,lastname='test con',BirthDate=date.valueof('1988-01-01') ,  email='abc@gmail.com');
        insert con;
        
        School_Date__c sdate = new School_Date__c() ;
        sdate.Active__c = true ;
        sdate.Day_One_Date__c = Date.parse('01/01/1988') ;
        
        insert sdate ;
        
        TrainingScheduleFormController tc = new TrainingScheduleFormController() ;
        
        tc.studentEmail = 'abc@gmail.com' ;
        
        date d = date.valueOF('1988-01-01') ;
        tc.selecteDate = sdate.id+','+d ;
        tc.showPopup() ;
        tc.closePopup() ;
        tc.submit() ;
        
        
    }
    
    
}