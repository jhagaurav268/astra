@isTest
public class TriggerHandlerTest {
    public class TestException extends Exception {}
    public static Boolean isContactInsert = false;
    public static Boolean isScooterInsert = false;
    public static Boolean isTransactionInsert = false;
    public static Boolean isAccountInsert = false;
    
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
            }else if(request.getEndpoint() == 'https://sandbox-quickbooks.api.intuit.com/v3/company/4620816365318751360/query?minorversion=65'){
                HttpResponse res = new HttpResponse();
                res.setStatusCode(200);
                if(isContactInsert == true){
                    res.setBody('{"QueryResponse":{"Customer":[{"Taxable":true,"BillAddr":{"Id":"146","Line1":"123 Main Street","City":"Mountain View","Country":"USA","CountrySubDivisionCode":"CA","PostalCode":"94042"},"Notes":"Here are other details.","Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"ClientEntityId":"0","domain":"QBO","sparse":false,"Id":"73","MetaData":{"CreateTime":"2023-08-14T02:06:10-07:00","LastUpdatedTime":"2023-08-14T02:06:10-07:00"},"Title":"Mr","GivenName":"James","MiddleName":"B","FamilyName":"King","Suffix":"Jr","FullyQualifiedName":"gaurav Jha","CompanyName":"Gaurav Jha","DisplayName":"gaurav Jha","PrintOnCheckName":"Gaurav Jha","Active":true,"V4IDPseudonym":"0020982b909e965d8648129e62d0c8ec2dba99","PrimaryPhone":{"FreeFormNumber":"(555) 555-5555"},"PrimaryEmailAddr":{"Address":"jdrew@myemail.com"}}],"startPosition":1,"maxResults":1},"time":"2023-08-14T02:07:18.437-07:00"}');
                }else if(isScooterInsert == true){
                    res.setBody('{"QueryResponse":{"Item":[{"Name":"Garden Supplies","Active":true,"FullyQualifiedName":"Garden Supplies","Taxable":false,"UnitPrice":0,"Type":"Inventory","IncomeAccountRef":{"value":"79","name":"Sales of Product Income"},"PurchaseCost":0,"ExpenseAccountRef":{"value":"80","name":"Cost of Goods Sold"},"AssetAccountRef":{"value":"81","name":"Inventory Asset"},"TrackQtyOnHand":true,"QtyOnHand":10,"InvStartDate":"2015-01-01","domain":"QBO","sparse":false,"Id":"35","SyncToken":"0","MetaData":{"CreateTime":"2023-07-25T00:08:04-07:00","LastUpdatedTime":"2023-07-25T00:08:04-07:00"}}],"startPosition":1,"maxResults":1},"time":"2023-08-14T02:36:29.819-07:00"}');
                }else if(isTransactionInsert == true){
                    res.setBody('{"QueryResponse":{"Invoice":[{"AllowIPNPayment":false,"AllowOnlinePayment":false,"AllowOnlineCreditCardPayment":false,"AllowOnlineACHPayment":false,"domain":"QBO","sparse":false,"Id":"233","SyncToken":"0","MetaData":{"CreateTime":"2023-08-14T02:49:33-07:00","LastModifiedByRef":{"value":"9130356916531226"},"LastUpdatedTime":"2023-08-14T02:49:33-07:00"},"CustomField":[{"DefinitionId":"1","Name":"CustomFIeldOne","Type":"StringType"},{"DefinitionId":"2","Name":"CustomFIeldTwo","Type":"StringType"},{"DefinitionId":"3","Name":"CustomFIeldThre","Type":"StringType"}],"DocNumber":"1074","TxnDate":"2023-08-14","CurrencyRef":{"value":"USD","name":"United States Dollar"},"LinkedTxn":[],"Line":[{"Id":"1","LineNum":1,"Amount":100,"DetailType":"SalesItemLineDetail","SalesItemLineDetail":{"ItemRef":{"value":"1","name":"Services"},"ItemAccountRef":{"value":"1","name":"Services"},"TaxCodeRef":{"value":"NON"}}},{"Amount":100,"DetailType":"SubTotalLineDetail","SubTotalLineDetail":{}}],"TxnTaxDetail":{"TotalTax":0},"CustomerRef":{"value":"1","name":"Amys Bird Sanctuary"},"BillAddr":{"Id":"2","Line1":"4581 Finch St.","City":"Bayshore","CountrySubDivisionCode":"CA","PostalCode":"94326","Lat":"INVALID","Long":"INVALID"},"ShipAddr":{"Id":"2","Line1":"4581 Finch St.","City":"Bayshore","CountrySubDivisionCode":"CA","PostalCode":"94326","Lat":"INVALID","Long":"INVALID"},"FreeFormAddress":true,"ShipFromAddr":{"Id":"147","Line1":"123 Sierra Way","Line2":"San Pablo, CA  87999"},"DueDate":"2023-09-13","TotalAmt":100,"ApplyTaxAfterDiscount":false,"PrintStatus":"NeedToPrint","EmailStatus":"NotSet","Balance":100}],"startPosition":1,"maxResults":1,"totalCount":1},"time":"2023-08-14T02:50:04.110-07:00"}');
                }else if(isAccountInsert == true){
                    res.setBody('{"QueryResponse":{"Account":[{"FullyQualifiedName":"Testing Account test","domain":"QBO","Name":"Testing Account test","Classification":"Asset","AccountSubType":"AccountsReceivable","CurrentBalanceWithSubAccounts":0,"sparse":true,"AccountType":"Accounts Receivable","CurrentBalance":0,"Active":"true","SyncToken":"0","Id":"93","SubAccount":"false","CurrencyRef":{"name":"USD","value":"United States Dollar"},"MetaData":{"CreateTime":"2023-08-14T10:30:00Z","LastUpdatedTime":"2023-08-14T15:45:00Z"}}],"startPosition":1}}');
                }else{
                    res.setBody('{"QueryResponse": "","time": "2023-08-09T06:01:56.267-07:00"}');
                }
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
    public static void syncAccountTest(){
        Test.setMock(HttpCalloutMock.class, new MyMock());
        Id accountRecordTypeId = [SELECT Name, Id, DeveloperName, SObjectType FROM RecordType WHere DeveloperName = 'Organization' AND SObjectType = 'Account'].Id;
        Account acc = new Account(Name = 'Testing Account test', Phone = '6543164836', RecordTypeId = accountRecordTypeId);
        insert acc;
        try{
            isAccountInsert = true;
            acc.Phone = '9485987048';
            update acc;
        }Catch(exception ex){
            System.debug('ex' + ex.getMessage());
        }
    }
    
    @isTest
    public static void syncContact(){
        Test.setMock(HttpCalloutMock.class, new MyMock());
        Id contactRecordTypeId = [SELECT Name, Id, DeveloperName, IsActive, SObjectType FROM RecordType WHere DeveloperName = 'Rider' AND SObjectType = 'Contact'].Id;
        Contact con = new Contact(RecordTypeId = contactRecordTypeId,FirstName = 'Testing', LastName = 'data', Email = 'testingcon@gmail.com');
        insert con;
        try{
            isContactInsert = true;
            con.Email = 'contest@gmail.com';
            update con;   
        }Catch(Exception ex){
            System.debug('Exception ' + ex.getMessage());
        }
    }
    
    @isTest
    public static void syncScooter(){
        Test.setMock(HttpCalloutMock.class, new MyMock());
        
        mPOS__Location__c location = new mPOS__Location__c();
        location.Name = 'Test';
        location.mPOS__Location_ID__c = 'ER000003';
        insert location;
        
        
        Scooter__c scoot = new Scooter__c();
        scoot.Name = 'Rachel Scooter';
        scoot.Scooter_Full_VIN__c = '86348749679';
        scoot.Scooter_Model__c = 'Fiddle IV';
        scoot.Type__c = 'Sold';
        scoot.Description__c = 'test';
        scoot.Price__c = 50;
        scoot.Location_One__c = location.Id;
        insert scoot;
        
        try{
            isScooterInsert = true;
            scoot.Description__c = 'Testing';
            update scoot;   
        }Catch(Exception ex){
            System.debug('Exception ' + ex.getMessage());
        }
        
        Scooter_Assignment__c objScAssignmnt= new Scooter_Assignment__c(
            Start_Date__c= system.Date.today().addDays(-10),
            scooter__c= scoot.Id,
            End_Date__c= system.Date.today()
        );
        insert objScAssignmnt;
        
        Scooter_Maintenance__c maintenance = new Scooter_Maintenance__c();
        maintenance.Name = 'Test Maintenance';
        maintenance.Scooter__c = scoot.Id;
        maintenance.Service_Date__c = Date.today();
        maintenance.Mileage__c = 25;
        insert maintenance;
    }
    
    @isTest
    public static void syncTransaction(){
        Test.setMock(HttpCalloutMock.class, new MyMock());
        
        Product2 prod = new Product2();
        prod.Name = 'Test product 001';
        prod.IsActive = true;
        prod.ProductCode = 'Product-001';
        prod.mPOS__Stock_Level__c = 1;
        prod.Price__c = 55;
        insert prod;
        
        mPOS__PP_Order__c eposOrders = new mPOS__PP_Order__c();
        eposOrders.mPOS__Completed__c = true;
        eposOrders.mPOS__Sales_Type__c = 'SALE';
        eposOrders.mPOS__Refund_Allowed__c = true;
        eposOrders.mPOS__First_Name__c = 'Test';
        eposOrders.mPOS__Last_Name__c = 'Contact';
        insert eposOrders;
        
        mPOS__Transaction__c trans = new mPOS__Transaction__c(Name = 'Test - 129823697239', mPOS__Email__c = 'test2@gmail.com', mPOS__Amount_Tendered__c = 300.0, mPOS__Total_Amount__c = 300.0, mPOS__Order__c = eposOrders.Id);
        insert trans;
        
        mPOS__EPOS_Item__c eposItem = new mPOS__EPOS_Item__c();
        eposItem.mPOS__Product__c = prod.Id;
        eposItem.mPOS__TaxRate__c = 10.360;
        eposItem.mPOS__Discount_Percent__c = 0.0;
        eposItem.mPOS__EPOS_Order__c = eposOrders.Id;
        insert eposItem;
        
        try{
            isTransactionInsert = true;
            trans.mPOS__Email__c = 'test@gmail.com';
            update trans;
            System.debug('trans'+trans);
        }Catch(Exception ex){
            System.debug('Exception ' + ex.getMessage());
        }
        
    }
    
    @IsTest
    public static void testErrorParse() {
        String json = '{\"Fault\":{\"Error\":[{\"Message\":\"A business validation error has occurred while processing your request\",\"Detail\":\"Business Validation Error: Were sorry, QuickBooks encountered an error while calculating tax. Try reselecting the tax rate or reentering the product/service item and saving the form again.\",\"code\":\"6000\",\"element\":\"\"}],\"type\":\"ValidationFault\"},\"time\":\"2023-08-16T21:40:41.673-08:00\"}';
        QBErrorJSON r = QBErrorJSON.parse(json);
        System.assert(r != null);
        
        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        QBErrorJSON objQBOErrorJSON = new QBErrorJSON(System.JSON.createParser(json));
        System.assert(objQBOErrorJSON != null);
        System.assert(objQBOErrorJSON.Fault == null);
        
        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        QBErrorJSON.Error objError = new QBErrorJSON.Error(System.JSON.createParser(json));
        System.assert(objError != null);
        System.assert(objError.Message == null);
        System.assert(objError.Detail == null);
        System.assert(objError.code == null);
        
        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        QBErrorJSON.Fault objFault = new QBErrorJSON.Fault(System.JSON.createParser(json));
        System.assert(objFault != null);
        System.assert(objFault.Error == null);
}
    
    @isTest
    static void testParseInvoiceJSON() {
        String json = '{"Line": [{"Amount": 100.0, "DetailType": "SalesItem", "SalesItemLineDetail": {"ItemRef": {"value": "item001", "name": "Sample Item"}, "TaxCodeRef": {"value": "tax001", "name": "Sample Tax Code"}, "Qty": 2}}], "CustomField": [], "CustomerRef": {"value": "cust001"}, "DueDate": "2023-08-31", "Balance": 200.0, "Id": "inv001", "SyncToken": "sync001", "SalesTermRef": {"value": "term001"}, "BillAddr": {"Id": "addr001", "Line1": "123 Main St", "City": "Anytown", "CountrySubDivisionCode": "CA", "PostalCode": "12345", "Country": "USA"}, "ShipAddr": {}, "BillEmail": {"Address": "invoice@email.com"}, "CustomerMemo": {"value": "Thank you for your business."}, "EmailStatus": "NotSet", "DocNumber": "INV-001", "AllowOnlineACHPayment": true, "AllowOnlineCreditCardPayment": true}';
        
        QBInvoiceJSON invoice = QBInvoiceJSON.parse(json);
        
        System.assertEquals(1, invoice.Line.size());
        System.assertEquals(100.0, invoice.Line[0].Amount);
        System.assertEquals('SalesItem', invoice.Line[0].DetailType);
        System.assertEquals('item001', invoice.Line[0].SalesItemLineDetail.ItemRef.value);
        System.assertEquals('Sample Item', invoice.Line[0].SalesItemLineDetail.ItemRef.name);
        System.assertEquals('tax001', invoice.Line[0].SalesItemLineDetail.TaxCodeRef.value);
        System.assertEquals('Sample Tax Code', invoice.Line[0].SalesItemLineDetail.TaxCodeRef.name);
        System.assertEquals(2, invoice.Line[0].SalesItemLineDetail.Qty);
        
        System.assertEquals(0, invoice.CustomField.size());
        
        System.assertEquals('cust001', invoice.CustomerRef.value);
        System.assertEquals(Date.valueOf('2023-08-31'), invoice.DueDate);
        System.assertEquals(200.0, invoice.Balance);
        System.assertEquals('inv001', invoice.Id);
        System.assertEquals('sync001', invoice.SyncToken);
        System.assertEquals('term001', invoice.SalesTermRef.value);
        System.assertEquals('addr001', invoice.BillAddr.Id);
        System.assertEquals('123 Main St', invoice.BillAddr.Line1);
        System.assertEquals('Anytown', invoice.BillAddr.City);
        System.assertEquals('CA', invoice.BillAddr.CountrySubDivisionCode);
        System.assertEquals('12345', invoice.BillAddr.PostalCode);
        System.assertEquals('USA', invoice.BillAddr.Country);
        System.assertEquals('invoice@email.com', invoice.BillEmail.Address);
        System.assertEquals('Thank you for your business.', invoice.CustomerMemo.value);
        System.assertEquals('NotSet', invoice.EmailStatus);
        System.assertEquals('INV-001', invoice.DocNumber);
        System.assertEquals(true, invoice.AllowOnlineACHPayment);
        System.assertEquals(true, invoice.AllowOnlineCreditCardPayment);
    }
    
    @isTest
    static void testPaymentParse() {
        String json = '{"TotalAmt": 100.00, "Line": [{"Amount": 50.00, "LinkedTxn": [{"TxnId": "12345", "TxnType": "Invoice"}]}], "CustomerRef": {"value": "Cust123"}, "PaymentMethodRef": {"value": "Method123"}}';
        
        QBPaymentJSON.Line line = new QBPaymentJSON.Line();
        line.Amount = 50.00;
        List<QBPaymentJSON.LinkedTxn> linkedTxns = new List<QBPaymentJSON.LinkedTxn>();
        QBPaymentJSON.LinkedTxn linkedTxn = new QBPaymentJSON.LinkedTxn();
        linkedTxn.TxnId = '12345';
        linkedTxn.TxnType = 'Invoice';
        linkedTxns.add(linkedTxn);
        line.LinkedTxn = linkedTxns;
        
        QBPaymentJSON.CustomerRef customerRef = new QBPaymentJSON.CustomerRef();
        customerRef.value = 'Cust123';
        
        QBPaymentJSON.PaymentMethodRef paymentMethodRef = new QBPaymentJSON.PaymentMethodRef();
        paymentMethodRef.value = 'Method123';
        
        QBPaymentJSON expected = new QBPaymentJSON();
        expected.TotalAmt = 100.00;
        expected.Line = new List<QBPaymentJSON.Line>{line};
            expected.CustomerRef = customerRef;
        expected.PaymentMethodRef = paymentMethodRef;
        
        QBPaymentJSON result = QBPaymentJSON.parse(json);
        
        System.assertEquals(expected.TotalAmt, result.TotalAmt);
        System.assertEquals(expected.Line.size(), result.Line.size());
        System.assertEquals(expected.Line[0].Amount, result.Line[0].Amount);
        System.assertEquals(expected.Line[0].LinkedTxn[0].TxnId, result.Line[0].LinkedTxn[0].TxnId);
        System.assertEquals(expected.Line[0].LinkedTxn[0].TxnType, result.Line[0].LinkedTxn[0].TxnType);
        System.assertEquals(expected.CustomerRef.value, result.CustomerRef.value);
        System.assertEquals(expected.PaymentMethodRef.value, result.PaymentMethodRef.value);
    }
    
    @isTest
    static void testQBProductJSON(){
        String jsonData = '{"QueryResponse":{"Item":[{"FullyQualifiedName":"SampleFullName","domain":"SampleDomain","Name":"SampleName","TrackQtyOnHand":true,"Type":"SampleType","PurchaseCost":50.0,"QtyOnHand":10,"InvStartDate":"2023-09-28","IncomeAccountRef":{"name":"IncomeName","value":"IncomeValue"},"ExpenseAccountRef":{"name":"ExpenseName","value":"ExpenseValue"},"AssetAccountRef":{"name":"AssetName","value":"AssetValue"},"Taxable":false,"sparse":true,"Active":true,"SyncToken":"SyncTokenValue","UnitPrice":100,"Id":"123","Description":"SampleDescription","Sku":"SampleSku"}]}}';

        QBProductJSON parsedData = QBProductJSON.parse(jsonData);

        System.assertEquals('SampleFullName', parsedData.QueryResponse.Item[0].FullyQualifiedName);
        System.assertEquals('SampleDomain', parsedData.QueryResponse.Item[0].domain);
        System.assertEquals('SampleName', parsedData.QueryResponse.Item[0].Name);
        System.assertEquals(true, parsedData.QueryResponse.Item[0].TrackQtyOnHand);
        System.assertEquals('SampleType', parsedData.QueryResponse.Item[0].Type);
        System.assertEquals(50.0, parsedData.QueryResponse.Item[0].PurchaseCost);
        System.assertEquals(10, parsedData.QueryResponse.Item[0].QtyOnHand);
        System.assertEquals('2023-09-28', parsedData.QueryResponse.Item[0].InvStartDate);
        System.assertEquals('IncomeName', parsedData.QueryResponse.Item[0].IncomeAccountRef.name);
        System.assertEquals('IncomeValue', parsedData.QueryResponse.Item[0].IncomeAccountRef.value);
        System.assertEquals('ExpenseName', parsedData.QueryResponse.Item[0].ExpenseAccountRef.name);
        System.assertEquals('ExpenseValue', parsedData.QueryResponse.Item[0].ExpenseAccountRef.value);
        System.assertEquals('AssetName', parsedData.QueryResponse.Item[0].AssetAccountRef.name);
        System.assertEquals('AssetValue', parsedData.QueryResponse.Item[0].AssetAccountRef.value);
        System.assertEquals(false, parsedData.QueryResponse.Item[0].Taxable);
        System.assertEquals(true, parsedData.QueryResponse.Item[0].sparse);
        System.assertEquals(true, parsedData.QueryResponse.Item[0].Active);
        System.assertEquals('SyncTokenValue', parsedData.QueryResponse.Item[0].SyncToken);
        System.assertEquals(100, parsedData.QueryResponse.Item[0].UnitPrice);
        System.assertEquals('123', parsedData.QueryResponse.Item[0].Id);
        System.assertEquals('SampleDescription', parsedData.QueryResponse.Item[0].Description);
        
    }
    
    @isTest
    static void testQBCustomerJSON(){
        String jsonData = '{"QueryResponse":{"Customer":[{"Taxable":true,"BillAddr":{"Id":"1","Line1":"Sample Line1","City":"Sample City","CountrySubDivisionCode":"Sample Code","PostalCode":"12345","Lat":"123.456","Long_x":"-789.123","Country":"Sample Country"},"ShipAddr":{"Id":"2","Line1":"Sample Ship Line1","City":"Sample Ship City","CountrySubDivisionCode":"Sample Ship Code","PostalCode":"54321","Lat":"654.321","Long_x":"-987.654","Country":"Sample Ship Country"},"Job":false,"BillWithParent":true,"ParentRef":{"value":"ParentValue"},"Level":2,"Balance":1000.0,"BalanceWithJobs":2000.0,"CurrencyRef":{"value":"USD","name":"US Dollar"},"PreferredDeliveryMethod":"Email","IsProject":false,"domain":"SampleDomain","sparse":false,"Id":"123","SyncToken":"SyncTokenValue","MetaData":{"CreateTime":"2023-09-28","LastUpdatedTime":"2023-09-28"},"FullyQualifiedName":"SampleFullName","CompanyName":"SampleCompany","GivenName":"SampleGivenName","FamilyName":"SampleFamilyName","DisplayName":"SampleDisplayName","PrintOnCheckName":"SamplePrintName","Active":true,"PrimaryPhone":{"FreeFormNumber":"123-456-7890"},"PrimaryEmailAddr":{"Address":"sample@email.com"},"DefaultTaxCodeRef":{"value":"TaxCodeValue"},"TaxExemptionReasonId":"ExemptionReasonValue","ResaleNum":"ResaleNumberValue"}],"startPosition":1,"maxResults":1},"timeString":"2023-09-28","FullyQualifiedName":"SampleFullName"}';
        
        QBCustomerJSON parsedData = QBCustomerJSON.parse(jsonData);
        
        System.assertEquals(true, parsedData.QueryResponse.Customer[0].Taxable);
        System.assertEquals('1', parsedData.QueryResponse.Customer[0].BillAddr.Id);
        System.assertEquals('Sample Line1', parsedData.QueryResponse.Customer[0].BillAddr.Line1);
        System.assertEquals('Sample City', parsedData.QueryResponse.Customer[0].BillAddr.City);
        System.assertEquals('Sample Code', parsedData.QueryResponse.Customer[0].BillAddr.CountrySubDivisionCode);
        System.assertEquals('12345', parsedData.QueryResponse.Customer[0].BillAddr.PostalCode);
        System.assertEquals('123.456', parsedData.QueryResponse.Customer[0].BillAddr.Lat);
        System.assertEquals('-789.123', parsedData.QueryResponse.Customer[0].BillAddr.Long_x);
        System.assertEquals('Sample Country', parsedData.QueryResponse.Customer[0].BillAddr.Country);
        System.assertEquals('2', parsedData.QueryResponse.Customer[0].ShipAddr.Id);
        System.assertEquals('Sample Ship Line1', parsedData.QueryResponse.Customer[0].ShipAddr.Line1);
        System.assertEquals('Sample Ship City', parsedData.QueryResponse.Customer[0].ShipAddr.City);
        System.assertEquals('Sample Ship Code', parsedData.QueryResponse.Customer[0].ShipAddr.CountrySubDivisionCode);
        System.assertEquals('54321', parsedData.QueryResponse.Customer[0].ShipAddr.PostalCode);
        System.assertEquals('654.321', parsedData.QueryResponse.Customer[0].ShipAddr.Lat);
        System.assertEquals('-987.654', parsedData.QueryResponse.Customer[0].ShipAddr.Long_x);
        System.assertEquals('Sample Ship Country', parsedData.QueryResponse.Customer[0].ShipAddr.Country);
        System.assertEquals(false, parsedData.QueryResponse.Customer[0].Job);
        System.assertEquals(true, parsedData.QueryResponse.Customer[0].BillWithParent);
        System.assertEquals('ParentValue', parsedData.QueryResponse.Customer[0].ParentRef.value);
        System.assertEquals(2, parsedData.QueryResponse.Customer[0].Level);
        System.assertEquals(1000.0, parsedData.QueryResponse.Customer[0].Balance);
        System.assertEquals(2000.0, parsedData.QueryResponse.Customer[0].BalanceWithJobs);
        System.assertEquals('USD', parsedData.QueryResponse.Customer[0].CurrencyRef.value);
        System.assertEquals('Email', parsedData.QueryResponse.Customer[0].PreferredDeliveryMethod);
        System.assertEquals(false, parsedData.QueryResponse.Customer[0].IsProject);
        System.assertEquals('SampleDomain', parsedData.QueryResponse.Customer[0].domain);
        System.assertEquals(false, parsedData.QueryResponse.Customer[0].sparse);
        System.assertEquals('123', parsedData.QueryResponse.Customer[0].Id);
        System.assertEquals('SyncTokenValue', parsedData.QueryResponse.Customer[0].SyncToken);
        System.assertEquals('2023-09-28', parsedData.QueryResponse.Customer[0].MetaData.CreateTime);
        System.assertEquals('2023-09-28', parsedData.QueryResponse.Customer[0].MetaData.LastUpdatedTime);
        System.assertEquals('SampleFullName', parsedData.QueryResponse.Customer[0].FullyQualifiedName);
        System.assertEquals('SampleCompany', parsedData.QueryResponse.Customer[0].CompanyName);
        System.assertEquals('SampleGivenName', parsedData.QueryResponse.Customer[0].GivenName);
        System.assertEquals('SampleFamilyName', parsedData.QueryResponse.Customer[0].FamilyName);
        System.assertEquals('SampleDisplayName', parsedData.QueryResponse.Customer[0].DisplayName);
        System.assertEquals('SamplePrintName', parsedData.QueryResponse.Customer[0].PrintOnCheckName);
        System.assertEquals(true, parsedData.QueryResponse.Customer[0].Active);
        System.assertEquals('123-456-7890', parsedData.QueryResponse.Customer[0].PrimaryPhone.FreeFormNumber);
        System.assertEquals('sample@email.com', parsedData.QueryResponse.Customer[0].PrimaryEmailAddr.Address);
        System.assertEquals('TaxCodeValue', parsedData.QueryResponse.Customer[0].DefaultTaxCodeRef.value);
        System.assertEquals('ExemptionReasonValue', parsedData.QueryResponse.Customer[0].TaxExemptionReasonId);
        System.assertEquals('ResaleNumberValue', parsedData.QueryResponse.Customer[0].ResaleNum);
        System.assertEquals('2023-09-28', parsedData.timeString);
        System.assertEquals('SampleFullName', parsedData.FullyQualifiedName);
    }
    
    @isTest
    static void testQBAccountJSON(){
        String jsonData = '{"QueryResponse":{"Account":[{"FullyQualifiedName":"SampleFullName","domain":"SampleDomain","Name":"SampleName","Classification":"SampleClassification","AccountSubType":"SampleSubType","CurrentBalanceWithSubAccounts":1000.0,"sparse":false,"AccountType":"SampleAccountType","CurrentBalance":500.0,"Active":"true","SyncToken":"SyncTokenValue","Id":"123","SubAccount":"SampleSubAccount","CurrencyRef":{"name":"SampleCurrencyName","value":"SampleCurrencyValue"},"MetaData":{"CreateTime":"2023-09-28","LastUpdatedTime":"2023-09-28"}}],"startPosition":1}}';

        QBAccountJSON parsedData = QBAccountJSON.parse(jsonData);

        System.assertEquals('SampleFullName', parsedData.QueryResponse.Account[0].FullyQualifiedName);
        System.assertEquals('SampleDomain', parsedData.QueryResponse.Account[0].domain);
        System.assertEquals('SampleName', parsedData.QueryResponse.Account[0].Name);
        System.assertEquals('SampleClassification', parsedData.QueryResponse.Account[0].Classification);
        System.assertEquals('SampleSubType', parsedData.QueryResponse.Account[0].AccountSubType);
        System.assertEquals(1000.0, parsedData.QueryResponse.Account[0].CurrentBalanceWithSubAccounts);
        System.assertEquals(false, parsedData.QueryResponse.Account[0].sparse);
        System.assertEquals('SampleAccountType', parsedData.QueryResponse.Account[0].AccountType);
        System.assertEquals(500.0, parsedData.QueryResponse.Account[0].CurrentBalance);
        System.assertEquals('true', parsedData.QueryResponse.Account[0].Active);
        System.assertEquals('SyncTokenValue', parsedData.QueryResponse.Account[0].SyncToken);
        System.assertEquals('123', parsedData.QueryResponse.Account[0].Id);
        System.assertEquals('SampleSubAccount', parsedData.QueryResponse.Account[0].SubAccount);
        System.assertEquals('SampleCurrencyName', parsedData.QueryResponse.Account[0].CurrencyRef.name);
        System.assertEquals('SampleCurrencyValue', parsedData.QueryResponse.Account[0].CurrencyRef.value);
        System.assertEquals('2023-09-28', parsedData.QueryResponse.Account[0].MetaData.CreateTime);
        System.assertEquals('2023-09-28', parsedData.QueryResponse.Account[0].MetaData.LastUpdatedTime);
    }
    
    @isTest
    static void testLogExceptionWithoutRelatedToId() {
        TestException testException = new TestException('Test Exception Message');
        
        HandleCustomException.LogException(testException);
        
        ErrorLog__c[] errorLogs = [SELECT Id FROM ErrorLog__c];
        
        System.assertEquals(1, errorLogs.size());
    }
}