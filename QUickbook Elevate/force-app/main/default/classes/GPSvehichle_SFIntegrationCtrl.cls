global class GPSvehichle_SFIntegrationCtrl{

   
     public HTTPResponse resp ;
     public static final String LONG_RUNNING_SERVICE_URL = Label.Api_URL ;
     public static List<Scooter__c> scooterList = new List<Scooter__c>() ;
     public static List<Scooter_Feed__c>  scooterFeedList = new List<Scooter_Feed__c>() ;
     static Map<String, Scooter_Feed__c> scooterFeedMap = new Map<String, Scooter_Feed__c>() ;
   // Action method
   
   
    public GPSvehichle_SFIntegrationCtrl(ApexPages.StandardController controller) {

    }

    public GPSvehichle_SFIntegrationCtrl() {

    }

    public void startRequest() {
      String requestLabel;
      String result ;
      Http httpProtocol = new Http();
     Set<String>  deviceIdSet =  new Set<String>() ;
      HttpRequest req = new HttpRequest();
      req.setMethod('GET');
      req.setEndpoint(LONG_RUNNING_SERVICE_URL);
     
       if(!Test.isRunningTest()){
            resp  = httpProtocol.send(req);
          }
       // Parse entire JSON response.
    JSONParser parser = JSON.createParser(resp.getBody());
    while (parser.nextToken() != null) {
        // Start at the array of invoices.
        if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
            while (parser.nextToken() != null) {
               
                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                
                    DeviceList evt = (DeviceList)parser.readValueAs(DeviceList.class);
                    //system.debug('Device: ' + evt.Device);
                    //system.debug(' list items: ' + evt.EventData);
                    Contact con = new Contact() ;
                    con.Contact_ExternalId__c = evt.Device ;
                    
                    // Create Scooter
                    Scooter__c st = new Scooter__c();
                    st.Name = evt.Device ;
                    st.Device_ID__c = evt.Device ;
                    st.Description__c = evt.Device_desc ;
                    st.Contact__r = con ;
                    scooterList.add(st) ;
                    
                    deviceIdSet.add(st.Device_Id__c) ;
                    
                   for(EventDataWrapper evtWrapp : evt.EventData){  
                    Scooter_Feed__c sf = new Scooter_Feed__c() ;
                    //sf.Name =  
                    sf.Timestamp_Date__c = evtWrapp.Timestamp_date ; 
                    sf.Timestamp_Time__c = evtWrapp.Timestamp_time ;
                    sf.Status_Code__c   =  evtWrapp.StatusCode ;
                    sf.StatusCode_desc__c = evtWrapp.StatusCode_desc ;
                    sf.Speed__c =  Decimal.valueOF(evtWrapp.Speed) ;
                    sf.Mileage__c = Decimal.valueOF(evtWrapp.Odometer) ;
                    sf.GPS_Point__longitude__s = Decimal.valueOF(evtWrapp.GPSPoint_lon) ;
                    sf.GPS_Point__latitude__s = Decimal.valueOF(evtWrapp.GPSPoint_lat) ;
                    //.Device_ID__c = evtWrapp.Device ;
                    //sf.Contact__r = con ;
                    sf.Altitude__c = Decimal.valueOF(evtWrapp.Altitude) ;
                    sf.Address__c = evtWrapp.Address ;
                    //scooterFeedList.add(sf) ;
                    scooterFeedMap.put(evt.Device, sf) ;
                  }  
                    // String str = JSON.serialize(evt);
                    //system.debug('Serialized invoice: ' + str);
                    // Skip the child start array and start object markers.
                    parser.skipChildren();
               }
              }
            }
        }
        
        // Insert scooter or update
          if(scooterList.size() > 0){
            // upsert scooterList Device_ID__c ;
          }
       
       
       for(Scooter__c sc : [select id , name , device_Id__c, contact__c from Scooter__c where device_Id__c IN:deviceIdSet]){
          if(scooterFeedMap.containsKey(sc.Device_ID__c)){
              Scooter_Feed__c sfeed = scooterFeedMap.get(sc.Device_ID__c) ;
              sfeed.scooter__c = sc.id ;
              sfeed.contact__c = sc.contact__c ;
              scooterFeedList.add(sfeed) ;
            }
      }     
        
      
    if(scooterFeedList.size() > 0 ){
          insert scooterFeedList ;
       }
       
     
    
       
    }
    
 
  /************************************/ 
     // Action method
    public PageReference fetchFeedForScooter() {
    
      System.debug('--------method called----') ;
      string device_id = '';
      String scooter_id = '' ; 
      scooter_id = ApexPages.currentPage().getParameters().get('id') ;
      
      List<Scooter__c> scooterList = [select id ,Device_ID__c from Scooter__c where id=:scooter_id] ;
      
      if(scooterList.size() > 0){
         device_id = scooterList[0].Device_ID__c  ;
      }
      
      String requestLabel;
      PageReference result  = new PageReference('/'+scooter_id) ;
      result.setRedirect(true) ;
      Http httpProtocol = new Http();
  
      HttpRequest req = new HttpRequest();
      req.setMethod('GET');
      req.setEndpoint(Label.API_URL_Single_Record+'&d='+device_id);
      
      HTTPResponse resp = new HttpResponse() ;
       if(!Test.isRunningTest()){
         resp = httpProtocol.send(req);
        }else{
          resp = this.resp  ;
        }
       // Parse entire JSON response.
    JSONParser parser = JSON.createParser(resp.getBody());
    while (parser.nextToken() != null) {
        // Start at the array of invoices.
        if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
            while (parser.nextToken() != null) {
               
                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                
                    DeviceList evt = (DeviceList)parser.readValueAs(DeviceList.class);
                    system.debug('Device: ' + evt.Device);
                    system.debug(' list items: ' + evt.EventData);
                    
                    // Create Scooter
                    Scooter__c st = new Scooter__c();
                    st.Name = evt.Device ;
                    st.Device_ID__c = evt.Device ;
                    st.Description__c = evt.Device_desc ;
                    scooterList.add(st) ;
                    
                   for(EventDataWrapper evtWrapp : evt.EventData){  
                    Scooter_Feed__c sf = new Scooter_Feed__c() ;
                    //sf.Name =  
                    sf.Timestamp_Date__c = evtWrapp.Timestamp_date ; 
                    sf.Timestamp_Time__c = evtWrapp.Timestamp_time ;
                    sf.Status_Code__c   =  evtWrapp.StatusCode ;
                    sf.StatusCode_desc__c = evtWrapp.StatusCode_desc ;
                    sf.Speed__c =  Decimal.valueOF(evtWrapp.Speed) ;
                    sf.Mileage__c = Decimal.valueOF(evtWrapp.Odometer) ;
                    sf.GPS_Point__longitude__s = Decimal.valueOF(evtWrapp.GPSPoint_lon) ;
                    sf.GPS_Point__latitude__s = Decimal.valueOF(evtWrapp.GPSPoint_lat) ;
                    
                    sf.Altitude__c = Decimal.valueOF(evtWrapp.Altitude) ;
                    sf.Address__c = evtWrapp.Address ;
                    //scooterFeedList.add(sf) ;
                    scooterFeedMap.put(evt.Device, sf) ;
                  }  
                    parser.skipChildren();
               }
              }
            }
        }
        
        // Insert scooter or update
          if(scooterList.size() > 0){
              // upsert scooterList Device_ID__c ;
          }
       
      for(Scooter__c sc : [select id , name , device_Id__c, contact__c from Scooter__c where device_Id__c =:device_id]){
          if(scooterFeedMap.containsKey(sc.Device_ID__c)){
              Scooter_Feed__c sfeed = scooterFeedMap.get(sc.Device_ID__c) ;
              sfeed.scooter__c = sc.id ;
              sfeed.contact__c = sc.contact__c ;
              scooterFeedList.add(sfeed) ;
            }
      }
    
    List<Scooter_Feed__c> existingScooterFeed = new List<Scooter_Feed__c>() ;
     existingScooterFeed = [select id from Scooter_Feed__c where ScooterDeviceID__c =:device_id AND createdDate =TODAY limit 1] ;
    
      
    
    if(existingScooterFeed.size() == 0 && scooterFeedList.size() > 0 ){
          insert scooterFeedList ;
       }
       
     return result ;  
       
    } 
       
 
// Inner classes used for serialization by readValuesAs(). 
public class DeviceList{
   public String Device ;
   public String Device_desc ;
   public List<EventDataWrapper> EventData ;
  
}

public class EventDataWrapper{
     public String Device ;
     public String Timestamp_date ;
     public String Timestamp_time ;
     public String StatusCode ;
     public String StatusCode_desc ;
     public String GPSPoint_lat ;
     public String GPSPoint_lon ;
     public String Speed ;
     public String Altitude ;
     public String Odometer ;
     public String Address ;
     
}  

    
   

   
}