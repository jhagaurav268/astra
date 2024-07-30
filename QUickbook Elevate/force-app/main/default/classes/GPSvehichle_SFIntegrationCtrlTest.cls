@isTest
public class GPSvehichle_SFIntegrationCtrlTest{


public testmethod static void testWebservice(){


 String jsonresp = '{ "Account": "lbt-2955", "Account_desc": "My City Rides", "TimeZone": "US/Central", "DeviceList": [ { "Device": "a1549","Device_desc": "Charles Williams",'+
'"EventData": [ {"Device": "a1549","Timestamp": 1532626410,"Timestamp_date": "2018/07/26","Timestamp_time": "12:33:30","StatusCode": 61472,'+
'"StatusCode_hex": "0xF020","StatusCode_desc": "Location","GPSPoint": "35.03954,-89.64803","GPSPoint_lat": 35.03954,"GPSPoint_lon": -89.64803,'+
' "GPSPoint_age": 10,"Speed_kph": 0.0,"Speed": 0.0,"Speed_units": "mph", "Altitude_meters": 108.9,"Altitude": 357,"Altitude_units": "feet", "Odometer_km":'+
' 4071.060, "Odometer": 2529.639,"Odometer_units": "Miles","Address": "198 Progress Rd, Collierville, TN 38017, USA","City": "Collierville","PostalCode":"38017",'+
'"Index": 0 }   ] }   ]}' ;


 Account a = new Account(name='test acc',phone='9494146144');
    insert a;
    Contact con = new Contact(accountid=a.id,lastname='test con',BirthDate=date.valueof('1988-01-01') ,  email='abc@gmail.com');
    con.recordtypeid = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Rider').getRecordTypeId() ;
    insert con;
    Scooter__c scooter = new  Scooter__c() ;
    scooter.name ='testscooter' ;
    scooter.Active__c = true;
    scooter.Contact__c = con.id ;
    scooter.Device_ID__c = 'a1549' ;
    scooter.Scooter_Full_VIN__c = 'asdf' ;
    insert scooter ;
    
ApexPages.StandardController controller = new ApexPages.StandardController(scooter) ;

GPSvehichle_SFIntegrationCtrl gps = new GPSvehichle_SFIntegrationCtrl(controller) ;
GPSvehichle_SFIntegrationCtrl gps2 = new GPSvehichle_SFIntegrationCtrl() ;
HttpResponse resp = new httpResponse() ;
resp.setBody(jsonresp) ;
gps2.resp = resp ;
gps2.fetchFeedForScooter() ;
gps2.startRequest() ;

}


}