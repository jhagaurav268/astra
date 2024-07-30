@isTest
public class GeozonePresenceUploadControllerTest {
    public static testmethod void testAll(){
        try{
            
            
            GeozonePresenceUploadController objCon= new GeozonePresenceUploadController();
            objCon.processCSV();
            string recordString =  '"devicedesc","geozoneid","enterdatetime","exitdatetime"';
            recordString =recordString+'\n'+'"India Bruce"'+','+'"india_bruce_home"'+','+'6/11/19 17:14'+','+'6/11/19 21:01'+'\n';
            blob csvFile= blob.valueOf(recordString);
            objCon.csvInputFile=csvFile;
            objCon.readSuccess=TRUE;
            objCon.processCSV();
            
            Contact objContact= new Contact( LastName='con', Geozone_ID__c='india_bruce_home', Device_Description__c='India Bruce');
            insert objContact;
            ID cntid = objContact.Id;
            Rider_Work_Geozone__c objGezone= new Rider_Work_Geozone__c(Rider_Contact__c= cntid, Name='india_bruce_home', Rider_Geozone_Id__c='india_bruce_home');
            insert objGezone;
            //ContentWorkspace objcWS= new ContentWorkspace(name='GeoZone Data');
            //insert objcWS;
            objCon.processCSV();
            
            
            
        }
        catch(Exception ex){}
    }
    
    public static testmethod void testOther(){
        try{
            GeozonePresenceUploadController objCon= new GeozonePresenceUploadController();
            ContentVersion cv= new ContentVersion (title='test',PathOnClient = 'Test.jpg', VersionData = blob.valueof('Test Content Data'));
            insert cv;
            ContentWorkspace objSpace= new ContentWorkspace(name='GeoZone Data');
            insert objSpace;
            objCon.readSuccess =true;
            objCon.outputData('test');   
        }
        catch(Exception ex){}
    }
}