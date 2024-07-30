@isTest
public class lookupController_CMTest {

    static testMethod void testLookupField() {
        try{
            List<string> returnFields = new List<string> {'Name'};
             Id accountEmployerTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Employer').getRecordTypeId();
            Id accountRecTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Rider').getRecordTypeId();
            
            Account objAcc1= new Account(name='fName1-lName1-04052019', recordTypeId=accountEmployerTypeId,Monthly_Payment__c=500);
            insert objAcc1;
                
            List<Account>listAcc = [SELECT Id FROM Account LIMIT 1];
            if(listAcc.size()>0){
                
                lookupController_CM.getObjectDetails('Account');
                lookupController_CM.GetRecentRecords('Account', returnFields, 5,'');
                lookupController_CM.SearchRecords('Account', returnFields, returnFields, '', 'Name', 'ASC', 5, 'CreatedDate > 2001-01-01T00:00:01Z');
                lookupController_CM.GetRecord('Account', returnFields, listAcc[0].Id);
            }
        }
        catch(Exception ex){}
        
    }
}