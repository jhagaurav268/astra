public class assignScooterController {
    
    @AuraEnabled
    public static scooterWrapper checkValidation(string scooterId){
        scooterWrapper objWrapper = new scooterWrapper();
        try{
            if(!string.isEmpty(scooterId)){
                
                map<string,boolean>  mapMsg = new  map<string,boolean>();
                list<Scooter__c> listScooter = [select id, contact__c from Scooter__c where id=:scooterId];
                
                if(listScooter.size()>0){
                    
                    objWrapper.objScooter= listScooter[0];  
                    objWrapper.contactRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Rider').getRecordTypeId();
                    objWrapper.contactWalkInRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Walk-In').getRecordTypeId();
                    objWrapper.contactJ1RecTypeId= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('J1').getRecordTypeId();
                    
                    list<Scooter_Assignment__c> listAssignmnt = [select id,Start_Date__c,Contact__c,Contact__r.name from Scooter_Assignment__c
                                                                 where scooter__c= :scooterId and End_Date__c=null];
                    
                    if(listAssignmnt.size()>0 && listAssignmnt.size()!=1){
                        mapMsg.put('multipleAssignmnt',true);
                    }
                    else  if( listAssignmnt.size()==1){
                        
                        objWrapper.objAssignmnt = listAssignmnt[0];
                        if(listAssignmnt[0].start_Date__c> system.Date.today().addDays(-1)){
                            mapMsg.put('startDateOverlapping',true);
                        }
                        else{
                            mapMsg.put('alreadyAssign',true);
                        }
                    }
                }
                else{
                    mapMsg.put('invalidId',true);
                }
                
                objWrapper.mapError = mapMsg;
                
            }
        }
        catch(Exception ex){}
        return objWrapper;
    }
    
    @AuraEnabled
    public static map<string,boolean> createAssignmnt(string scooterId,string contactId, String selectedPaymentType ){
        map<string,boolean>  mapMsg = new  map<string,boolean>();
        savepoint sp;
        try{
            sp = Database.setSavepoint();
            list<Scooter_Assignment__c> listAssignmnt = [select id,Contact__c,End_Date__c from Scooter_Assignment__c where scooter__c= :scooterId and End_Date__c=null];
            if( listAssignmnt.size()==1){
                listAssignmnt[0].End_Date__c= System.date.today().addDays(-1);
                update listAssignmnt[0];
            }
            
            list<Scooter__c> listScooter = [select id, contact__c from Scooter__c where id=:scooterId];
            if(listScooter.size()>0){
                listScooter[0].Contact__c = contactId;
                update listScooter[0];
            }
            
            Scooter_Assignment__c objAssgnmnt = new Scooter_Assignment__c();
            objAssgnmnt.Contact__c =contactId;
            objAssgnmnt.Scooter__c = scooterId;
            objAssgnmnt.Start_Date__c = system.Date.today();
            objAssgnmnt.Payment_Duration__c = selectedPaymentType;
            insert objAssgnmnt;
            mapMsg.put('success',true);
        }
        catch(Exception ex){
            if(sp!=null){
                database.rollback(sp);
            }
        }
        return mapMsg;
        
    }

    
    @AuraEnabled
    public static List<String> getPaymentType(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Scooter_Assignment__c.Payment_Duration__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        return options;
    }
    
    @AuraEnabled
    public static Scooter__c getScooterById(Id scooterId) {
        return [SELECT Type__c FROM Scooter__c WHERE Id = :scooterId LIMIT 1];
    }
    
    // @AuraEnabled
    // public static void updateScooterAssignment(String scooterId, string scooterType){
    //     List<Scooter__c> listScooter = [select id, contact__c from Scooter__c where id=:scooterId];
    //     List<Scooter_Assignment__c> ass = [Select Id, Scooter__c, Assignment_Type__c  from Scooter_Assignment__c Where Scooter__c =: scooterId ORDER BY LastModifiedDate DESC LIMIT 1];
    //     for(Scooter_Assignment__c sa : ass){
    //         sa.Assignment_Type__c = scooterType;
    //     }
    //     update ass;
    // }

    public class scooterWrapper{
        
        @auraEnabled public string contactRecTypeId{get;set;}
        @auraEnabled public string contactWalkInRecTypeId{get;set;}
        @auraEnabled public string contactJ1RecTypeId{get;set;}
        @auraEnabled public Scooter__c objScooter{get;set;}
        @auraEnabled public Scooter_Assignment__c objAssignmnt{get;set;}
        @auraEnabled public map<string,boolean> mapError{get;set;}
        
    }
    
}