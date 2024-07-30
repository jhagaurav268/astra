@isTest
public class scooterAssignmentTriggerHandlerTest {
    @TestSetup
    static void setupTestData() {
        QB_Data__c customSetting = new QB_Data__c(
            Name = 'Test Setting',
            Refresh_Token__c = 'AB117010772526rYP0fQxeqGp6LYBOumQHQZOhQLEZZOYrkNFH',
            Client_Id__c = 'ABI9igi2G1RJTjmOWraFrC79vcELEUgZ3OkCgsEkuG9lFm2nET',
            Client_Secret__c = 'jbtrTKkOUkdIxy7hk6vunqMvs35dsycY0luzuhfY',
            Auth_Url__c = 'https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer'
        );
        insert customSetting;
    }
    
    private class MyMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            system.debug('Endpoint ' + request.getEndpoint());
            if(request.getEndpoint() == 'https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer'){
                HttpResponse res = new HttpResponse();
                res.setStatusCode(200);
                res.setBody('{"x_refresh_token_expires_in": 3600,"refresh_token": "AB117010772526rYP0fQxeqGp6LYBOumQHQZOhQLEZZOYrkNFH","access_token": "eyJlbmMiOiJBMTI4Q0JDLUhTMjU2IiwiYWxnIjoiZGlyIn0..pmZMcaE2P8gOwxPrj4-6Nw.g4RGg6bkV9eUW-fnN9kSCxSRGcKJjUbEz5guCLiU94yyb0Gx0IDPWjpw8Q0hoTNgKMuqAS53B4LIS1OUulSfmUnR3-xd7qLafHr2LQnataSvRa2-vT0uHIh1UkurP-bkwquiIs8q4MhHaNmW6tDUn9W6isAFqrxIUMMsL_Snl9sdh28KlVppOX7DPEqIOU0ib84VBxZJlnS-ma8qtxy9pY9kMTAM3tjtCMiu548BUS-34NlrXhhKbLW6DIQn5nA3vp0LRPz32rjFJiw621I8RXzzRwjAuLMPF-SZnuuMHePt_WgvMzg6a0xwvt9qgsVSpFnR6DyhO6S6KXC2L7TeKdwluwCIwLc0cKGOJUVOq25McuIhXVQoixdRgh53_tb89w0bw0V5GMeUW75HfUrNynONSafgX9EJtwApjUon8DoML3CFh7wc75HKyM4-gV2yUcn7jr7zfUfauYIdtGT9XAhkCRViTl0tx4uRxwfQiGyw3JZC7JovnUpnQ3KH7H_DJS_GE-NjuDYm9z423XCTlf02xznDiYuAiF86bvsynL3x3VALnNsRzQF6urA3IYtfkKJgh6E-QlSLsIdUaxvdkWP9EvflxX6TrWiCygejWbmyowPIPzhihMGD08dgH-cvnhIYn3qQq7x73NrRjebBgRv1WR_dz7aJk0SGurBbkVX5pzWZlGSYLzqExdgKRKgPI4q6xA89RSuxPZqE26xE_EHJJqiwH5uJaPaUK0DSjV9_39nST-3Au51HG-Px-KWN.bImx7dHYvtRausOW2MM-ig","expires_in": "3600","token_type": "Bearer"}');
                return res;
            }else if(request.getEndpoint() == 'https://sandbox-quickbooks.api.intuit.com/v3/company/4620816365318751360/account?minorversion=65'){
                HttpResponse res = new HttpResponse();
                res.setStatusCode(200);
                res.setBody('{"Account":{"Name":"Testing Account test","SubAccount":false,"Description":"Description added during update.","FullyQualifiedName":"Testing Account test","Active":true,"Classification":"Asset","AccountType":"Accounts Receivable","AccountSubType":"AccountsReceivable","CurrentBalance":0,"CurrentBalanceWithSubAccounts":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"domain":"QBO","sparse":false,"Id":"93","SyncToken":"1","MetaData":{"CreateTime":"2023-08-14T03:26:22-07:00","LastUpdatedTime":"2023-08-14T03:29:42-07:00"}},"time":"2023-08-14T03:29:42.504-07:00"}');
                return res;
            }else if(request.getEndpoint() == 'https://sandbox-quickbooks.api.intuit.com/v3/company/4620816365318751360/customer?minorversion=65'){
                HttpResponse res = new HttpResponse();
                res.setStatusCode(200);
                res.setBody('{"Customer":{"Taxable":true,"BillAddr":{"Id":"146","Line1":"123 Main Street","City":"Mountain View","Country":"USA","CountrySubDivisionCode":"CA","PostalCode":"94042"},"Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"domain":"QBO","sparse":false,"Id":"73","SyncToken":"1","MetaData":{"CreateTime":"2023-08-14T02:06:10-07:00","LastUpdatedTime":"2023-08-14T02:13:01-07:00"},"GivenName":"James","MiddleName":"B","FamilyName":"King","FullyQualifiedName":"gaurav Jha","CompanyName":"Gaurav Jha","DisplayName":"gaurav Jha","PrintOnCheckName":"Gaurav","Active":true,"PrimaryPhone":{"FreeFormNumber":"(555) 555-5555"},"PrimaryEmailAddr":{"Address":"jdrew@myemail.com"},"DefaultTaxCodeRef":{"value":"2"}},"time":"2023-08-14T02:13:01.252-07:00"}');
                return res;
            }else if(request.getEndpoint() == 'https://sandbox-quickbooks.api.intuit.com/v3/company/4620816365318751360/item?minorversion=65'){
                HttpResponse res = new HttpResponse();
                res.setStatusCode(200);
                res.setBody('{"Item":{"FullyQualifiedName":"Garden Supplies","domain":"QBO","Id":"35","Name":"Garden Supplies","TrackQtyOnHand":true,"UnitPrice":0,"PurchaseCost":0,"QtyOnHand":10,"IncomeAccountRef":{"name":"Sales of Product Income","value":"79"},"AssetAccountRef":{"name":"Inventory Asset","value":"81"},"Taxable":false,"sparse":false,"Active":true,"SyncToken":"1","InvStartDate":"2015-01-01","Type":"Inventory","ExpenseAccountRef":{"name":"Cost of Goods Sold","value":"80"},"MetaData":{"CreateTime":"2015-12-09T11:12:39-08:00","LastUpdatedTime":"2015-12-09T11:12:41-08:00"}},"time":"2015-12-09T11:12:39.748-08:00"}');
                return res;
            }else if(request.getEndpoint() == 'https://sandbox-quickbooks.api.intuit.com/v3/company/4620816365318751360/invoice?minorversion=65'){
                HttpResponse res = new HttpResponse();
                res.setStatusCode(200);
                res.setBody('{"Invoice":{"AllowIPNPayment":false,"AllowOnlinePayment":false,"AllowOnlineCreditCardPayment":false,"AllowOnlineACHPayment":false,"domain":"QBO","sparse":false,"Id":"233","SyncToken":"1","MetaData":{"CreateTime":"2023-08-14T02:49:33-07:00","LastModifiedByRef":{"value":"9130356916531226"},"LastUpdatedTime":"2023-08-14T02:52:40-07:00"},"CustomField":[{"DefinitionId":"1","Name":"CustomFIeldOne","Type":"StringType"},{"DefinitionId":"2","Name":"CustomFIeldTwo","Type":"StringType"},{"DefinitionId":"3","Name":"CustomFIeldThre","Type":"StringType"}],"DocNumber":"1070","TxnDate":"2015-07-24","CurrencyRef":{"value":"USD","name":"United States Dollar"},"LinkedTxn":[],"Line":[{"Id":"1","LineNum":1,"Amount":150,"DetailType":"SalesItemLineDetail","SalesItemLineDetail":{"ItemRef":{"value":"1","name":"Services"},"ItemAccountRef":{"value":"1","name":"Services"},"TaxCodeRef":{"value":"NON"}}},{"Amount":150,"DetailType":"SubTotalLineDetail","SubTotalLineDetail":{}}],"TxnTaxDetail":{"TotalTax":0},"CustomerRef":{"value":"1","name":"Amys Bird Sanctuary"},"CustomerMemo":{"value":"Added customer memo."},"BillAddr":{"Id":"2","Line1":"4581 Finch St.","City":"Bayshore","CountrySubDivisionCode":"CA","PostalCode":"94326","Lat":"INVALID","Long":"INVALID"},"ShipAddr":{"Id":"2","Line1":"4581 Finch St.","City":"Bayshore","CountrySubDivisionCode":"CA","PostalCode":"94326","Lat":"INVALID","Long":"INVALID"},"FreeFormAddress":true,"ShipFromAddr":{"Id":"147","Line1":"123 Sierra Way","Line2":"San Pablo, CA  87999"},"DueDate":"2015-08-23","TotalAmt":150,"ApplyTaxAfterDiscount":false,"PrintStatus":"NeedToPrint","EmailStatus":"NotSet","Balance":150},"time":"2023-08-14T02:52:40.164-07:00"}');
                return res;
            }else if(request.getEndpoint() == 'https://sandbox-quickbooks.api.intuit.com/v3/company/4620816365318751360/payment?minorversion=65'){
                HttpResponse res = new HttpResponse();
                res.setStatusCode(200);
                res.setBody('{"Payment":{"SyncToken":"0","domain":"QBO","DepositToAccountRef":{"value":"4"},"UnappliedAmt":25,"TxnDate":"2014-12-30","TotalAmt":25,"ProcessPayment":false,"sparse":false,"Line":[],"CustomerRef":{"name":"Red Rock Diner","value":"20"},"Id":"154","MetaData":{"CreateTime":"2014-12-30T10:26:03-08:00","LastUpdatedTime":"2014-12-30T10:26:03-08:00"}},"time":"2014-12-30T10:26:03.668-08:00"}');
                return res;
            }
            else {
                return null;
            }
        }
    }
    
    @isTest
    public static void testAll(){
        Test.setMock(HttpCalloutMock.class, new MyMock());
        Id contactRecordTypeId = [SELECT Name, Id, DeveloperName, IsActive, SObjectType FROM RecordType WHere DeveloperName = 'Rider' AND SObjectType = 'Contact'].Id;
        
        mPOS__Location__c location = new mPOS__Location__c();
        location.Name = 'Test';
        location.mPOS__Location_ID__c = 'ER000003';
        insert location;
        
        contact objCon = new contact(RecordTypeId = contactRecordTypeId,FirstName = 'Testing', LastName = 'data', Email = 'testingcon@gmail.com');
        insert objCon;
        
        contact objCon2 = new contact(RecordTypeId = contactRecordTypeId,FirstName = 'Testing', LastName = 'data 2', Email = 'testingcon2@gmail.com');
        insert objCon2;
        
        scooter__c objSc= new scooter__c(name='test scooter', Device_ID__c='test dev',Scooter_Full_VIN__c='test vin', contact__C=objCon.Id, Type__c='Rent', Price__c=50, Location_One__c = location.Id);
        insert objSc;
        
        list<Scooter_Assignment__c> listScAssgnmnt = new list<Scooter_Assignment__c>();
        listScAssgnmnt.add( new Scooter_Assignment__c(Start_Date__c= system.Date.today().addDays(-30),scooter__c= objSc.Id,End_Date__c= system.Date.today().addDays(-20)));
        listScAssgnmnt.add( new Scooter_Assignment__c(Start_Date__c= system.Date.today().addDays(-19),scooter__c= objSc.Id));
        try{
            insert listScAssgnmnt;
        }
        catch(Exception ex){}
        
        Scooter_Assignment__c objScAssignmnt= new Scooter_Assignment__c(
            Start_Date__c= system.Date.today().addDays(-10),
            scooter__c= objSc.Id,
            End_Date__c= system.Date.today()
        );
        try{
            insert objScAssignmnt;
        }
        catch(Exception ex){}
        
        
        listScAssgnmnt[1]. End_Date__c= system.Date.today().addDays(-11);
        update  listScAssgnmnt[1];
        
        //Start date is overlapping with existing end date
        try{
            objScAssignmnt.Start_Date__c= system.Date.today().addDays(-12);
            insert objScAssignmnt;
        }
        catch(Exception ex){}
        
        objScAssignmnt.Start_Date__c= system.Date.today().addDays(-10);
        insert objScAssignmnt;
        objScAssignmnt.Contact__c =objCon2.Id;
        update objScAssignmnt;
        
        try{
            objScAssignmnt.End_Date__c= system.Date.today().addDays(-12);
            update objScAssignmnt;
        }
        catch(Exception ex){}
        
        try{
            objScAssignmnt.Start_Date__c= system.Date.today().addDays(-30);
            objScAssignmnt.End_Date__c= system.Date.today().addDays(-25);
            update objScAssignmnt;
        }
        catch(Exception ex){}
        
        try{
            objScAssignmnt.End_Date__c= null;
            update objScAssignmnt;
        }
        catch(Exception ex){}
        
    }
    
}