public class GeozonePresenceUploadController {
    public Blob csvInputFile{get;set;}
    public boolean readSuccess {get;set;}
    String exitdatetime;
    String workgeozone;
    String contact;
    String contactname;
    String GeozoneDataKey;
    String prevDevicedesc;
    public String Message{set;get;} 
    Integer lastRow;
     String dataFolder = System.Label.GeoZone_Data;
    String dcName = 'WorkGeoZoneData_';
    Set <String> recordIndex = new Set<String>(); 
    Map < String, Integer > fieldNumberMap = new Map < String, Integer > ();
    Map < String,Rider_Work_Geozone__c > workGeozoneMap = new MAp < String,Rider_Work_Geozone__c >();
   
   public GeozonePresenceUploadController() {
        readSuccess = TRUE;
     
    }
    public void processCSV(){
        try{
            if( csvInputFile!= null){
                readSuccess = TRUE;
                String outfile = readWriteCSVFile();
                outputData(outfile);
            }else{
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No file has been selected');
              ApexPages.addMessage(errorMsg);
            }
            
            
        }
        catch(exception e){
            System.debug('--------'+e) ; 
            readSuccess = FALSE;
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error reading CSV file');
            ApexPages.addMessage(errorMsg);
        }
    }
  //process CSV File
    public String readWriteCSVFile() {  
     String outputDataLines = '' ;
     String geozoneid = ''  ;
     String devicedesc = '';
     String enterdatetime = '';
     String entertime = '';
     String outputFieldNames = 'Geozonedata_Key__c,Rider_Contact__c,Rider_Contact_Name__c,Geozone_Id__c,Date_of_Presence__c,Time_of_Presence__c';
   
    
        try{
           List<String> inputDataLines = (csvInputFile.toString()).split('\n');
           string[] csvFieldNames = inputDataLines[0].split(',');
      
            //map column label to field api name
            for (Integer i = 0; i < csvFieldNames.size(); i++) {
                  String fieldName = csvFieldNames[i];
                    fieldNumberMap.put(fieldName.remove('"'), i);
            }
          
          //get all contacts records for the input records
           
               setContactList(inputDataLines);
               
             //set output file column headings
            outputDataLines = outputFieldNames+'\r\n';
            //read required fields
          lastRow = 0;
           for (Integer i = 1; i < inputDataLines.size(); i++) {
                lastRow = i;
                String[] csvRecordData = inputDataLines[i].split(',');
           
                exitdatetime = csvRecordData[fieldNumberMap.get('exitdatetime')];
                devicedesc = csvRecordData[fieldNumberMap.get('devicedesc')];
                geozoneid = csvRecordData[fieldNumberMap.get('geozoneid')]; 
                geozoneid = geozoneid.remove('"').trim();
                enterdatetime = csvRecordData[fieldNumberMap.get('enterdatetime')];
                enterdatetime = enterdatetime.remove('"');
                String[] enterdatetimeArry = enterdatetime.split(' ');
                
                
                String unformattedenterdate = enterdatetimeArry[0];
                entertime = enterdatetimeArry[1];
                Date edt = Date.parse(unformattedenterdate);
                Integer mon = edt.month();
        Integer day = edt.day();
        Integer yr = edt.year();
        DateTime dt = DateTime.newInstance(yr, mon, day);
        String enterdate = dt.format('MM/dd/YYYY');
     
                        
                if (!recordIndex.contains(devicedesc+enterdate)){
                        String[] contactWorkzone = getContact(devicedesc,geozoneid);
                        contact = contactWorkzone[0];
                        contactname = contactWorkzone[1];
                        workgeozone = contactWorkzone[2];
                    
                    if (workgeozone.trim()==geozoneid){
                        //add unique key
                        GeozoneDataKey = contact.trim()+enterdate;
                        //create output record
                      
                        outputDataLines = outputDataLines+''+GeozoneDataKey+','+contact+','+contactname+','+workgeozone+','+enterdate+','+entertime+'\r\n';
               
                        //add recordIndex
                        recordIndex.add(devicedesc+enterdate);
                    }
                    
                }
            }
         
        }catch(Exception e){
            readSuccess = FALSE;
            System.debug('--------'+e) ;
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Error processing CSV file (row:'+lastRow+')');
          ApexPages.addMessage(errorMsg);
            
        }
      return  outputDataLines;
     }
    
    // create CSV document and save
    public void outputData(String outputDataLines) {
      try {
            SObject[] records = [SELECT Id, RootContentFolderId FROM ContentWorkspace WHERE Name = :dataFolder LIMIT 1];
            if (records.size()>0 ){
                 if (readSuccess){
                    String docName = dcName + Datetime.now().format('MM')+'-'+Datetime.now().day()+'-' + Datetime.now().year();
                    ContentVersion cv = new ContentVersion();
                    cv.VersionData = Blob.valueOf(outputDataLines);
                    cv.Title = docName;
                    cv.PathOnClient = docName+'.csv';
                    insert cv;
                    cv = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
                    ContentWorkspace ws= (ContentWorkspace)records[0];
                    ContentDocumentLink cdl = new ContentDocumentLink();
                    cdl.ContentDocumentId = cv.ContentDocumentId;
                    cdl.ShareType = 'I';
                    cdl.Visibility = 'AllUsers';
                    cdl.LinkedEntityId = ws.Id;
                    insert cdl;
                
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.severity.INFO, 'Work Geozone upload file created successfully');
                   ApexPages.addMessage(errorMsg);
                }else{
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'No file has been created due to errors '+message);
              ApexPages.addMessage(errorMsg);
                }
            
            }else{
              
                readSuccess = FALSE;
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Folder: '+dataFolder+' is not available or User does not have author rights to the folder' );
                ApexPages.addMessage(errorMsg);
            }

      
      }catch (Exception e) {
          System.debug('-----'+e) ;
          ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Error creating upload CSV file');
          ApexPages.addMessage(errorMsg);
          
      }
    }
    
    // read all the contacts work geozones from contact
   public void setContactList(String[] inputDataLines){
      message  = '' ;
        try{
            List<String> devicedescArray = new List<String> {};
            for (Integer i = 1; i < inputDataLines.size(); i++) {
                String[] csvRecordData = inputDataLines[i].split(',');
                String devicedesc = csvRecordData[0];
                devicedesc = devicedesc.remove('"');
                if(devicedesc != '' && devicedesc != null){
                    devicedescArray.add(devicedesc); 
                   }
            }
            
            
             
         if(devicedescArray.size() > 0){
            
             System.debug('--------'+devicedescArray) ;           
             for( Rider_Work_Geozone__c wg : [SELECT Rider_Contact__r.Id, Rider_Contact__r.Name, Rider_Geozone_ID__c, 
                                              Rider_Contact__r.Device_Description__c FROM Rider_Work_Geozone__c 
                                              WHERE (Rider_Contact__r.Device_Description__c IN :devicedescArray )]){
             
                     try{
                              workGeozoneMap.put((wg.Rider_Contact__r.Device_Description__c.trim()+wg.Rider_Geozone_ID__c.trim()),wg);
                       
                       }catch(Exception e){
                          readSuccess = FALSE;
                            System.debug('----'+e.getMessage()) ;
                            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Error occurred at '+wg.Rider_Contact__c+' The description or geozone id is null' );
                            ApexPages.addMessage(errorMsg);
                       }
            }
          }
            
        }catch (Exception e){
            readSuccess = FALSE;
            message += e.getMessage()+' '+e.getLineNumber() ;
            System.debug('----'+e.getMessage()) ;
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Error occurred :'+message );
            ApexPages.addMessage(errorMsg);
        } 
        
    } 
    
    public String[] getContact(String devicedesc, String geozoneid){
        String[] contactInfo;
      
        try{
            devicedesc = devicedesc.remove('"');
            contactInfo = new String[]{'','',''};
                  
            Rider_Work_Geozone__c cnt =    workGeozoneMap.get(devicedesc.trim()+geozoneid.trim());
            if (cnt!=NULL){
              contactInfo = new String[]{ cnt.Rider_Contact__r.Id, (cnt.Rider_Contact__r.Name == null ? '' : cnt.Rider_Contact__r.Name), (cnt.Rider_Geozone_ID__c == null ? '' : cnt.Rider_Geozone_ID__c)};
                
            }  
        }catch (Exception e){
              System.debug('------Error Occurred----'+e) ;
        }
        
     return contactInfo;
    }  
  
}