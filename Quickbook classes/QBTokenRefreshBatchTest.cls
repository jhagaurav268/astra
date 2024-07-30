@isTest
public class QBTokenRefreshBatchTest {
    
    @TestSetup
    static void setupTestData() {
        QB_Data__c customSetting = new QB_Data__c(
            Name = 'Test Setting',
            Refresh_Token__c = 'AB11700306931VDRxlJ7MOtzQ9UwH9cRY4vopCNnqck2G4Wb02',
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
                 res.setBody('{"x_refresh_token_expires_in": 3600,"refresh_token": "AB117003095986NqGPK6YZeI4VzVwj3sYZoKu414jE6hzP8Mge","access_token": "eyJlbmMiOiJBMTI4Q0JDLUhTMjU2IiwiYWxnIjoiZGlyIn0..pmZMcaE2P8gOwxPrj4-6Nw.g4RGg6bkV9eUW-fnN9kSCxSRGcKJjUbEz5guCLiU94yyb0Gx0IDPWjpw8Q0hoTNgKMuqAS53B4LIS1OUulSfmUnR3-xd7qLafHr2LQnataSvRa2-vT0uHIh1UkurP-bkwquiIs8q4MhHaNmW6tDUn9W6isAFqrxIUMMsL_Snl9sdh28KlVppOX7DPEqIOU0ib84VBxZJlnS-ma8qtxy9pY9kMTAM3tjtCMiu548BUS-34NlrXhhKbLW6DIQn5nA3vp0LRPz32rjFJiw621I8RXzzRwjAuLMPF-SZnuuMHePt_WgvMzg6a0xwvt9qgsVSpFnR6DyhO6S6KXC2L7TeKdwluwCIwLc0cKGOJUVOq25McuIhXVQoixdRgh53_tb89w0bw0V5GMeUW75HfUrNynONSafgX9EJtwApjUon8DoML3CFh7wc75HKyM4-gV2yUcn7jr7zfUfauYIdtGT9XAhkCRViTl0tx4uRxwfQiGyw3JZC7JovnUpnQ3KH7H_DJS_GE-NjuDYm9z423XCTlf02xznDiYuAiF86bvsynL3x3VALnNsRzQF6urA3IYtfkKJgh6E-QlSLsIdUaxvdkWP9EvflxX6TrWiCygejWbmyowPIPzhihMGD08dgH-cvnhIYn3qQq7x73NrRjebBgRv1WR_dz7aJk0SGurBbkVX5pzWZlGSYLzqExdgKRKgPI4q6xA89RSuxPZqE26xE_EHJJqiwH5uJaPaUK0DSjV9_39nST-3Au51HG-Px-KWN.bImx7dHYvtRausOW2MM-ig","expires_in": "3600","token_type": "Bearer"}');
                 return res;
             }else {
                 return null;
             }
         }
     }

    static testMethod void myTestMethod() {   
        Test.setMock(HttpCalloutMock.class, new MyMock());
         test.starttest();
         QBTokenRefreshBatch myClass = new QBTokenRefreshBatch ();   
         String chron = '0 0 23 * * ?';        
         system.schedule('Test Sched', chron, myClass);
         test.stopTest();
    }

}