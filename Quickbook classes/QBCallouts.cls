public class QBCallouts {
    
    public class QBException extends Exception {}
    private String accessToken{get;set;}
    private String refreshToken{get;set;}
    
    public QBCallouts() {
        List<String> tokens = refresh();
    }
    
    private List<String> refresh(){
        QB_Data__c QBData = [SELECT Id, Name, Refresh_Token__c, Client_Id__c, Client_Secret__c, Auth_Url__c FROM QB_Data__c];
        String url = QBData.Auth_Url__c;
        String clientId = QBData.Client_Id__c;
        String clientSecret = QBData.Client_Secret__c;
        String header = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(clientId + ':' + clientSecret));
        String refresh_token = QBData.Refresh_Token__c;
        String body = 'grant_type=refresh_token&refresh_token='+refresh_token; 
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        req.setEndpoint(url);
        req.setMethod('GET');
        req.setBody(body);
        req.setHeader('Authorization', header);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        res = http.send(req);
        QBRefreshJSON json = QBRefreshJSON.parse(res.getBody());
        if(json.access_token == null){
            CustomException__c exc = new CustomException__c();
            exc.Exception_Message__c = 'Refresh Token has Expired';
            Database.insert(exc);
        }
        List<String> tokens = new List<String>{json.access_token, json.refresh_token};
            accessToken = tokens[0];
        refreshToken = tokens[1];
        return tokens;
    }
    
    public void updateRefreshToken(){
        try{
            QB_Data__c QBData = [SELECT Id, Name, Refresh_Token__c, Last_Updated__c FROM QB_Data__c];
            QBData.Refresh_Token__c = refreshToken;
            QBData.Last_Updated__c = DateTime.now();
            update QBData;
        }Catch(Exception ex){
            HandleCustomException.LogException(ex);
        }
    }
    
    private static void handleResponseError(String body){
        QBErrorJSON error = QBErrorJSON.parse(body);
        if(error != null){
            if(error.Fault != null && error.Fault.Error != null && error.Fault.Error.size() > 0){
                QBErrorJSON.Fault fault = error.Fault;
                
                List<QBErrorJSON.Error> errors = fault.Error;
                System.debug('Errors ' + errors);
                try{
                    for (QBErrorJSON.Error errorMsg : errors) {
                        CustomException__c exc = new CustomException__c();
                        exc.Exception_Message__c = errorMsg.Message;
                        exc.StackTrace__c = errorMsg.Detail;
                        exc.Exception_Code__c = errorMsg.code;
                        System.debug('exc ' + exc);
                        Database.insert(exc);
                        System.debug('exc ' + exc.Id + ' ' + exc.Exception_Code__c);
                    }
                }Catch(Exception ex){
                    System.debug(ex.getMessage());
                }
            }
        }
    }
    
    public static String makeQuickBooksApiCall(String url, String method, String body, Map<String, String> headers) {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        req.setEndpoint(url);
        req.setMethod(method);
        if (String.isNotBlank(body)) {
            req.setBody(body);
        }
        if (headers != null) {
            for (String key : headers.keySet()) {
                req.setHeader(key, headers.get(key));
            }
        }
        res = h.send(req);
        return res.getBody();
    }
    
    public QBCustomerResponseJSON createCustomerCall(Contact con, QB_Metadata__mdt QBData) {
        String body = QBMap.mapContactData(con);
        String url = QBData.Base_Url__c + '/v3/company/' + QBData.Company_Id__c + '/customer?minorversion=' + QBData.Minor_Version__c;     
        Map<String, String> headers = new Map<String, String>{'Authorization' => 'Bearer ' + accessToken,'Accept' => 'application/json','Content-Type' => 'application/json'};
            String responseJson = makeQuickBooksApiCall(url, 'POST', body, headers);
        handleResponseError(responseJson);
        QBCustomerResponseJSON json = QBCustomerResponseJSON.parse(responseJson);
        return json;
    }
    
    /*public QBProductJSON getProduct(Product2 scooter){
if(scooter == null){
Throw new NullPointerException();
}

String query = 'Select * from Item where Name = \'' + scooter.Name + '\'';

if(scooter.QBO_Id__c != null){
query = 'Select * from Item where Id = \'' + scooter.QBO_Id__c + '\'';
}

QB_Metadata__mdt QBData = [SELECT Id, Base_Url__c, Company_Id__c, Minor_Version__c FROM QB_Metadata__mdt];
String url = QBData.Base_Url__c + '/v3/company/' + QBData.Company_Id__c + '/query?minorversion=' + QBData.Minor_Version__c;
Map<String, String> headers = new Map<String, String>{'Authorization' => 'Bearer ' + accessToken,'Accept' => 'application/json','Content-Type' => 'application/text'};
String responseJson = makeQuickBooksApiCall(url, 'POST', query, headers);
handleResponseError(responseJson);
QBProductJSON json = QBProductJSON.parse(responseJson);
return json;
}*/
    
    public QBProductResponseJSON createProductCall(Product2 scooter, QB_Metadata__mdt QBData, Decimal Quantity){
        String body = QBMap.mapProductData(scooter, Quantity);
        String url = QBData.Base_Url__c + '/v3/company/' + QBData.Company_Id__c + '/item?minorversion=' + QBData.Minor_Version__c;
        Map<String, String> headers = new Map<String, String>{'Authorization' => 'Bearer ' + accessToken,'Accept' => 'application/json','Content-Type' => 'application/json'};
            String responseJson = makeQuickBooksApiCall(url, 'POST', body, headers);
        handleResponseError(responseJson);
        QBProductResponseJSON json = QBProductResponseJSON.parse(responseJson);
        return json;
    }
    
    public QBProductResponseJSON createProductAssignmentCall(Scooter__c scooter, Scooter_Assignment__c assignment, QB_Metadata__mdt QBData){
        String body = QBMap.mapProductAssignmentData(scooter, assignment);
        String url = QBData.Base_Url__c + '/v3/company/' + QBData.Company_Id__c + '/item?minorversion=' + QBData.Minor_Version__c;
        Map<String, String> headers = new Map<String, String>{'Authorization' => 'Bearer ' + accessToken,'Accept' => 'application/json','Content-Type' => 'application/json'};
            String responseJson = makeQuickBooksApiCall(url, 'POST', body, headers);
        handleResponseError(responseJson);
        QBProductResponseJSON json = QBProductResponseJSON.parse(responseJson);
        return json;
    }
    
    /*public QBProductJSON getProduct(Scooter_Maintenance__c scooter){
if(scooter == null){
Throw new NullPointerException();
}

String query = 'Select * from Item where Name = \'' + scooter.Name + '\'';

if(scooter.QBO_Id__c != null){
query = 'Select * from Item where Id = \'' + scooter.QBO_Id__c + '\'';
}
QB_Metadata__mdt QBData = [SELECT Id, Base_Url__c, Company_Id__c, Minor_Version__c FROM QB_Metadata__mdt];
String url = QBData.Base_Url__c + '/v3/company/' + QBData.Company_Id__c + '/query?minorversion=' + QBData.Minor_Version__c;
Map<String, String> headers = new Map<String, String>{'Authorization' => 'Bearer ' + accessToken,'Accept' => 'application/json','Content-Type' => 'application/text'};
String responseJson = makeQuickBooksApiCall(url, 'POST', query, headers);
handleResponseError(responseJson);
QBProductJSON json = QBProductJSON.parse(responseJson);
return json;
}*/
    
    public QBProductResponseJSON createMaintenanceCall(Scooter__c scooter, Scooter_Maintenance__c maintenance, QB_Metadata__mdt QBData){
        String body = QBMap.mapScooterMaintenanceData(scooter, maintenance);
        String url = QBData.Base_Url__c + '/v3/company/' + QBData.Company_Id__c + '/item?minorversion=' + QBData.Minor_Version__c;
        Map<String, String> headers = new Map<String, String>{'Authorization' => 'Bearer ' + accessToken,'Accept' => 'application/json','Content-Type' => 'application/json'};
            String responseJson = makeQuickBooksApiCall(url, 'POST', body, headers);
        handleResponseError(responseJson);
        QBProductResponseJSON json = QBProductResponseJSON.parse(responseJson);
        return json;
    }
    
    public QBAccountResponseJSON createAccountCall(Account acc, QB_Metadata__mdt QBData){
        String body = QBMap.mapAccountData(acc);
        String url = QBData.Base_Url__c + '/v3/company/' + QBData.Company_Id__c + '/account?minorversion=' + QBData.Minor_Version__c;
        Map<String, String> headers = new Map<String, String>{'Authorization' => 'Bearer ' + accessToken,'Accept' => 'application/json','Content-Type' => 'application/json'};
            String responseJson = makeQuickBooksApiCall(url, 'POST', body, headers);
        handleResponseError(responseJson);
        QBAccountResponseJSON json = QBAccountResponseJSON.parse(responseJson);
        return json;
    }
    
    public QBInvoiceResponseJSON createInvoiceCall(mPOS__Transaction__c inv, List<mPOS__EPOS_Item__c> eposItemList, QB_Metadata__mdt QBData){
        String body = QBMap.mapInvoice(inv, eposItemList);
        String url = QBData.base_url__c + '/v3/company/' + QBData.Company_Id__c + '/invoice?minorversion=' + QBData.Minor_Version__c;
        Map<String, String> headers = new Map<String, String>{'Authorization' => 'Bearer ' + accessToken,'Accept' => 'application/json','Content-Type' => 'application/json'};
            String responseJson = makeQuickBooksApiCall(url, 'POST', body, headers);
        handleResponseError(responseJson);
        QBInvoiceResponseJSON json = QBInvoiceResponseJSON.parse(responseJson);
        return json;
    }
    
    public QBPaymentResponseJSON createPaymentCall(mPOS__Transaction__c trans, String qbId, QB_Metadata__mdt QBData){
        String body = QBMap.mapPayment(trans, qbID);
        String url = QBData.base_url__c + '/v3/company/' + QBData.Company_Id__c + '/payment?minorversion=' + QBData.Minor_Version__c;
        Map<String, String> headers = new Map<String, String>{'Authorization' => 'Bearer ' + accessToken,'Accept' => 'application/json','Content-Type' => 'application/json'};
            String responseJson = makeQuickBooksApiCall(url, 'POST', body, headers);
        handleResponseError(responseJson);
        QBPaymentResponseJSON json = QBPaymentResponseJSON.parse(responseJson);
        return json;
    }
    
}