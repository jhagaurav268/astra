@isTest
public class CreateWalkInAccountsTest {

     public static testmethod void testUpdate(){
        try
        {
            Id accounttRecTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Walk-In').getRecordTypeId();
            Id contactRecTypeId= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Walk-In').getRecordTypeId();
            
            Account objAccount1= new Account(name='fName-lName-11042019', recordTypeId=accounttRecTypeId);
            insert objAccount1;
            Account objAccount2= new Account(name='fName2-lName2-11042019', recordTypeId=accounttRecTypeId);
            insert objAccount2;
            
            Contact objContact1 = new contact(firstName='fName', lastName='lName', birthDate=System.Date.today(), AccountId=objAccount1.Id,
                                              recordTypeId = contactRecTypeId);
            insert objContact1;
            
            Contact objContact2 = new contact(firstName='fName2', lastName='lName2', birthDate=System.Date.today(), AccountId=objAccount2.Id,
                                              recordTypeId = contactRecTypeId);
            insert objContact2;
            
            Id accountOrgRecTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organization').getRecordTypeId();
            Account objAccOrg= new Account(name='Organization Account', recordTypeId=accountOrgRecTypeId);
            insert objAccOrg;
            test.startTest();
            objContact1.AccountId = objAccOrg.Id;
            update objContact1;
            
            objContact2.AccountId =objAccount2.Id;
            update objContact2;
            
            objContact2.AccountId =objAccount1.Id;
            update objContact2;
            
            
            Contact objContact3 = new contact(firstName='fName3', lastName='lName3', birthDate=System.Date.today(),
                                              recordTypeId = contactRecTypeId);
            insert objContact3;
            system.debug(objContact3.RecordTypeId);
            objContact3.AccountId=null;
            update objContact3;
            
            
            
            test.stopTest();
        }
        catch(Exception ex){}
        
    }
    
}