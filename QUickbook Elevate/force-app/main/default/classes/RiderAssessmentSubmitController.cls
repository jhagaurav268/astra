public class RiderAssessmentSubmitController {
    
    public Rider_Assessment__c objRider{get;set;}
    public Contact con {get;set;}
    public string conId;
    public Boolean formFilled = false;
    Public Boolean testResultBlank = False;
    Public Boolean hideForm {get;set;}
    public Boolean isBlankSSDate = False;
    public Boolean isBlankSSCDate = True;
    public Boolean isError {get;set;}
    public Boolean bothFalse {get;set;}
    public Boolean showConfirmPanel {get;set;}
    public Boolean showCancelPanel {get;set;}
    public String error {get;set;}
    public String errorMsg {get;set;}
    
    public RiderAssessmentSubmitController(){
        
        showCancelPanel = False;
        showConfirmPanel = False;
        bothFalse = False;
        error = '';
        hideForm = True;
        isError = False;
        
        
        conId = apexpages.currentpage().getparameters().get('id');
        objRider = new Rider_Assessment__c ();
        
        con = [select id,Scooter_School_Date__c,FirstName,LastName,Scooter_School_Completed_Date__c from Contact Where id=: conId];
        /*
List<Rider_Assessment__c> riderAssessmentList = [Select id,Name,Contact__c,Result__c,CreatedDate from Rider_Assessment__c Where Contact__c= :conId Limit 1];
System.debug('riderAssessmentList---'+riderAssessmentList);
if(!riderAssessmentList.isEmpty()){
for(Rider_Assessment__c rs : riderAssessmentList){
if(String.isBlank(rs.Result__c) && String.isEmpty(rs.Result__c)){
testResultBlank = True;
}
}

}

if(testResultBlank){
error = 'You have  already scheduled your DMV test for '+riderAssessmentList[0].CreatedDate+'. Please email or call My City Rides for assistance with changing your date.';
isError = True;
}else*/
        if(con.Scooter_School_Date__c == NULL){
            isBlankSSDate = True;
            error = 'Scooter School Date is required before Rider Assessment.';
            isError = True;
        }else if(con.Scooter_School_Completed_Date__c != NULL){
            isBlankSSCDate = False;
            error = 'You have already successfully completed Scooter School.';
            isError = True;
        }
        
        if(!isBlankSSDate && isBlankSSCDate){
            bothFalse = True;
        }
        
        if(error != '' && String.isNotBlank(error)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
        }
        
    }
    
    public void validateForm(){
        errorMsg = '';
        if(objRider.Attentive__c == '' || String.isBlank(objRider.Attentive__c) || String.isEmpty(objRider.Attentive__c)){
            errorMsg =  'Please select all required options';
        }
        
        if(objRider.Follow_General_Instruction__c == '' || String.isBlank(objRider.Follow_General_Instruction__c) || String.isEmpty(objRider.Follow_General_Instruction__c)){
            errorMsg =  'Please select all required options';
        }
        
        if(objRider.Demonstrate_Proper_Riding_Techniques__c == '' || String.isBlank(objRider.Demonstrate_Proper_Riding_Techniques__c) || String.isEmpty(objRider.Demonstrate_Proper_Riding_Techniques__c)){
            errorMsg =  'Please select all required options';
        }
        
        if(objRider.Dangerous_Riding_Characteristics__c == '' || String.isBlank(objRider.Dangerous_Riding_Characteristics__c) || String.isEmpty(objRider.Dangerous_Riding_Characteristics__c)){
            errorMsg =  'Please select all required options';
        }
        
        if(objRider.Crash_During_Driving__c == '' || String.isBlank(objRider.Crash_During_Driving__c) || String.isEmpty(objRider.Crash_During_Driving__c)){
            errorMsg =  'Please select all required options';
        }
        
        if(objRider.Result__c == '' || String.isBlank(objRider.Result__c) || String.isEmpty(objRider.Result__c)){
            errorMsg =  'Please select all required options';
        }
        
        if(errorMsg != '' || String.isNotBlank(errorMsg) || String.isNotEmpty(errorMsg)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMsg));
        }
        
        formFilled = errorMsg == '' ? True : False;
    }
    
    public void showFormPanel(){
        hideForm = False;
        bothFalse = False;
        showCancelPanel = False;
        showConfirmPanel = False;
    }
    
    public void showConfirmPanel(){
        validateForm();
        
        if(formFilled){
            showConfirmPanel = True;
            hideForm = True;
        }
    }
    
    public void showCancelPanel(){
        showCancelPanel = True;
        hideForm = True;
    }
    
    public PageReference submit(){
        try{
            if(formFilled){
                objRider.Contact__c = conId;
                insert objRider;
                
                if(conId != null){
                    contact con = [select id,Scooter_School_Result__c,Scooter_School_Completed_Date__c,Email,recordType.Name from contact where id =: conId];
                    System.debug('con---'+con.Scooter_School_Result__c);
                    System.debug('val---'+objRider.Result__c);
                    
                    if(objRider.Result__c == 'Pass' && objRider.Result__c <> con.Scooter_School_Result__c){
                        con.Scooter_School_Completed_Date__c = Date.today();
                        if(String.isNotBlank(con.Email)){
                            sendEmail('Pass',String.valueOf(con.Email),String.valueOf(con.id), String.valueOf(con.recordType.Name));
                        } 
                    }
                    
                    if(objRider.Result__c == 'Fail' && objRider.Result__c <> con.Scooter_School_Result__c){
                        if(String.isNotBlank(con.Email)){
                            sendEmail('Fail',String.valueOf(con.Email),String.valueOf(con.id),String.valueOf(con.recordType.Name));
                        }
                    }else if(objRider.Result__c == 'Need Improvement' && objRider.Result__c <> con.Scooter_School_Result__c){
                        if(String.isNotBlank(con.Email)){
                            sendEmail('Need Improvement',String.valueOf(con.Email),String.valueOf(con.id),String.valueOf(con.recordType.Name));
                        }
                    }
                    
                    con.Scooter_School_Result__c = objRider.Result__c;
                    update con;
                    
                }
                return new PageReference('/'+conId);
            }
            return null;
        }catch(Exception ex){
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
            return null;
        }
        
    }
    
    public void sendEmail(String result, String email, String contactId, string recordType){
        Try{
            if(String.isNotBlank(result) && String.isNotBlank(email) && String.isNotBlank(contactId)){
                
                String emailTemplateName;
                if(result.trim() == 'Pass'){
                    
                    if(recordType=='J1'){
                        emailTemplateName = 'J1 - Scooter School Pass Pick Up';
                    }
                    else{
                        emailTemplateName = 'MVA Signup form';
                    }
                    
                }
                else if (result.trim() == 'Fail'){
                    
                    if(recordType=='J1'){
                        emailTemplateName = 'J1 - School Fail';
                    }
                    else{
                        emailTemplateName = 'Scooter School Fail Email';
                    }
                    
                } 
                else if(result.trim() == 'Need Improvement'){
                     if(recordType=='J1'){
                        emailTemplateName = 'J1 - Scooter School Practice';
                    }
                    else{
                        emailTemplateName = 'Need Improvement Email';
                    }
                     
                    
                }
                
                
                if(String.isNotBlank(emailTemplateName)){
                   
                    List<EmailTemplate> emailTemplateList = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name =: emailTemplateName];
                    
                    if(emailTemplateList.size()>0){
                        Messaging.SingleEmailMessage message = new   Messaging.SingleEmailMessage();
                        message.setTargetObjectId(contactId); 
                        message.setSenderDisplayName(emailTemplateList[0].Subject); 
                        //message.setReplyTo('no-reply@company.com');
                        message.setUseSignature(false); 
                        message.setBccSender(false); 
                        message.setSaveAsActivity(false); 
                        message.setTemplateID(emailTemplateList[0].Id); 
                        //message.setWhatId(account.Id); //This is important for the merge fields in template to work
                        message.toAddresses = new String[] {email.trim()};
                            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{message};
                                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                        
                        if (results[0].success) 
                        {
                            System.debug('The email was sent successfully.');
                        } else {
                            System.debug('The email failed to send:'+  results[0].errors[0].message);
                        }
                        
                    }
                    
                }
                
                
                
            }
        }Catch(Exception e){
            System.debug('Error---'+e.getMessage() + '==' + e.getLineNumber());
        }
    }
    
    public PageReference back(){
        return new PageReference('/'+conId);
    }
    
}