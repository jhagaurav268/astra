public class scooterAssignmentTriggerHandler {
    
    public static void beforeInsert(list<Scooter_Assignment__c>newList){
        
        set<string>scooterIds = new set<string>();
        map<string,list<Scooter_Assignment__c>> mapScooterWithOpenAssgnmnts = new map<string,list<Scooter_Assignment__c>>();
        map<string,Scooter_Assignment__c> mapScooterWithRecentEndedAssgnmnt = new map<string,Scooter_Assignment__c>();
        
        try{
            for(Scooter_Assignment__c objAssgnmnt:newList){
                scooterIds.add(objAssgnmnt.Scooter__c);
            }
            
            if(scooterIds.size()>0){
                for(Scooter_Assignment__c objAssgnmnt: [select id,Scooter__c, Start_Date__c,End_Date__c from Scooter_Assignment__c where Scooter__c in:scooterIds order by End_Date__c desc  NULLS First])
                {
                    if(objAssgnmnt.End_Date__c==null){
                        if(!mapScooterWithOpenAssgnmnts.containsKey(objAssgnmnt.Scooter__c)){
                            mapScooterWithOpenAssgnmnts.put(objAssgnmnt.Scooter__c,new List<Scooter_Assignment__c>{objAssgnmnt});
                        }
                        else{
                            list<Scooter_Assignment__c>exist = mapScooterWithOpenAssgnmnts.get(objAssgnmnt.Scooter__c);
                            exist.add(objAssgnmnt);
                            mapScooterWithOpenAssgnmnts.put(objAssgnmnt.Scooter__c,exist);
                        }
                    }
                    else{
                        if(!mapScooterWithRecentEndedAssgnmnt.containsKey(objAssgnmnt.Scooter__c)){
                            mapScooterWithRecentEndedAssgnmnt.put(objAssgnmnt.Scooter__c,objAssgnmnt);
                        }
                    }
                    
                }
                
                for(Scooter_Assignment__c objNewAssgnmnt:newList){
                    if(mapScooterWithOpenAssgnmnts.containsKey(objNewAssgnmnt.Scooter__c)){
                        objNewAssgnmnt.addError('There is an open scooter assignment for this Scooter');
                    }
                    else if(mapScooterWithRecentEndedAssgnmnt.containsKey(objNewAssgnmnt.Scooter__c)){
                        if(objNewAssgnmnt.Start_Date__c!=null && objNewAssgnmnt.Start_Date__c<= mapScooterWithRecentEndedAssgnmnt.get(objNewAssgnmnt.Scooter__c).End_Date__c){
                            objNewAssgnmnt.addError('Start Date is overlapping with End date of existing assignments');
                        }
                    }
                    
                }
                
            }
            
        }
        catch(Exception ex){}
        
        
        
    }
    
    public static void beforeUpdate(list<Scooter_Assignment__c>newList,map<id,Scooter_Assignment__c> newMap, map<id,Scooter_Assignment__c> oldMap){
        
        set<string>scooterIds = new set<string>();
        set<string>assignmntIds = new set<string>();
        map<string,list<Scooter_Assignment__c>> mapScooterWithAllEndedAssgnmnts = new map<string,list<Scooter_Assignment__c>>();
        map<string,list<Scooter_Assignment__c>> mapScooterWithOpenAssgnmnts = new map<string,list<Scooter_Assignment__c>>();
        map<string,Scooter_Assignment__c> mapScooterWithRecentEndedAssgnmnt = new map<string,Scooter_Assignment__c>();
        
        try{
            for(Scooter_Assignment__c objAssgnmnt:newList){
                scooterIds.add(objAssgnmnt.Scooter__c);
                assignmntIds.add(objAssgnmnt.Id);
            }
            
            if(scooterIds.size()>0){
                for(Scooter_Assignment__c objAssgnmnt: [select id,Scooter__c,Start_Date__c,End_Date__c from Scooter_Assignment__c where Scooter__c in:scooterIds order by End_Date__c desc  ])
                {
                    
                    
                    if(objAssgnmnt.End_Date__c==null){
                        if(!mapScooterWithOpenAssgnmnts.containsKey(objAssgnmnt.Scooter__c)){
                            mapScooterWithOpenAssgnmnts.put(objAssgnmnt.Scooter__c,new List<Scooter_Assignment__c>{objAssgnmnt});
                        }
                        else{
                            list<Scooter_Assignment__c>exist = mapScooterWithOpenAssgnmnts.get(objAssgnmnt.Scooter__c);
                            exist.add(objAssgnmnt);
                            mapScooterWithOpenAssgnmnts.put(objAssgnmnt.Scooter__c,exist);
                        }
                    }
                    else{
                        if(!mapScooterWithRecentEndedAssgnmnt.containsKey(objAssgnmnt.Scooter__c)){
                            mapScooterWithRecentEndedAssgnmnt.put(objAssgnmnt.Scooter__c,objAssgnmnt);
                        }
                        if(!mapScooterWithAllEndedAssgnmnts.containsKey(objAssgnmnt.Scooter__c)){
                            mapScooterWithAllEndedAssgnmnts.put(objAssgnmnt.Scooter__c,new List<Scooter_Assignment__c>{objAssgnmnt});
                        }
                        else{
                            list<Scooter_Assignment__c>exist = mapScooterWithAllEndedAssgnmnts.get(objAssgnmnt.Scooter__c);
                            exist.add(objAssgnmnt);
                            mapScooterWithAllEndedAssgnmnts.put(objAssgnmnt.Scooter__c,exist);
                        }
                    }
                    
                }
                
                system.debug(mapScooterWithOpenAssgnmnts);
                boolean isError=false;
                for(Scooter_Assignment__c objNewAssgnmnt:newList){
                    
                    if(mapScooterWithOpenAssgnmnts.containsKey(objNewAssgnmnt.Scooter__c) &&  mapScooterWithOpenAssgnmnts.get(objNewAssgnmnt.Scooter__c).size()>1){
                        objNewAssgnmnt.addError('There is an open scooter assignment for this Scooter');
                        isError=true;
                        system.debug('aaa');
                    }
                    else if(mapScooterWithOpenAssgnmnts.containsKey(objNewAssgnmnt.Scooter__c) &&  mapScooterWithOpenAssgnmnts.get(objNewAssgnmnt.Scooter__c).size()==1){
                        system.debug('open size==1');
                        if(objNewAssgnmnt.End_Date__c!=null && mapScooterWithOpenAssgnmnts.get(objNewAssgnmnt.Scooter__c)[0].End_Date__c==null &&
                           !newMap.containsKey(mapScooterWithOpenAssgnmnts.get(objNewAssgnmnt.Scooter__c)[0].Id)  && objNewAssgnmnt.End_Date__c >= mapScooterWithOpenAssgnmnts.get(objNewAssgnmnt.Scooter__c)[0].Start_Date__c)
                        {
                            objNewAssgnmnt.addError('End Date is overlapping with Start date of existing assignments');
                            isError=true;
                            system.debug('bb');
                        }
                        else if(objNewAssgnmnt.End_Date__c==null && mapScooterWithOpenAssgnmnts.get(objNewAssgnmnt.Scooter__c)[0].Id!= objNewAssgnmnt.Id)
                        {
                            objNewAssgnmnt.addError('There cannot be more than 2 Assignments with End Date as Null');
                            isError=true;
                            system.debug('cc');
                        }
                    } 
                    
                    if(!isError && mapScooterWithAllEndedAssgnmnts.containsKey(objNewAssgnmnt.Scooter__c)){
                        for(Scooter_Assignment__c objExist:mapScooterWithAllEndedAssgnmnts.get(objNewAssgnmnt.Scooter__c)){
                            
                            if(objExist.Id!= objNewAssgnmnt.Id){
                                system.debug(objExist);
                                 
                                if(objNewAssgnmnt.Start_Date__c!=null && objNewAssgnmnt.Start_Date__c>= objExist.Start_Date__c && objNewAssgnmnt.Start_Date__c<= objExist.End_Date__c){
                                    objNewAssgnmnt.addError('Start Date is overlapping with End date of existing assignments');
                                    system.debug('111');
                                }
                                else if(objNewAssgnmnt.End_Date__c!=null && objNewAssgnmnt.End_Date__c<= objExist.End_Date__c && objNewAssgnmnt.End_Date__c>= objExist.Start_Date__c){
                                    objNewAssgnmnt.addError('End Date is overlapping with Start date of existing assignments');
                                    system.debug('22');
                                }
                                else if(objNewAssgnmnt.End_Date__c!=null && objNewAssgnmnt.Start_Date__c<= objExist.Start_Date__c && objNewAssgnmnt.End_Date__c>= objExist.End_Date__c){
                                    objNewAssgnmnt.addError('End Date is overlapping with Start date of existing assignments');
                                    system.debug('333');
                                }
                                else if(objNewAssgnmnt.End_Date__c!=null && objNewAssgnmnt.Start_Date__c<= objExist.Start_Date__c && objNewAssgnmnt.End_Date__c>= objExist.Start_Date__c){
                                    objNewAssgnmnt.addError('End Date is overlapping with Start date of existing assignments');
                                    system.debug('444');
                                }
                                else if(objNewAssgnmnt.End_Date__c==null && objNewAssgnmnt.Start_Date__c <= objExist.End_Date__c){
                                    objNewAssgnmnt.addError('Start Date is overlapping with End date of existing assignments');
                                    system.debug('555');
                                }
                                else if(objNewAssgnmnt.End_Date__c!=null && objExist.End_Date__c==null && objNewAssgnmnt.End_Date__c >= objExist.Start_Date__c){
                                    objNewAssgnmnt.addError('End Date is overlapping with Start date of existing assignments');
                                    system.debug('666');
                                }
                            }
                            
                        }
                    }
                    /*else if(mapScooterWithRecentEndedAssgnmnt.containsKey(objNewAssgnmnt.Scooter__c)){
                        if(objNewAssgnmnt.Start_Date__c!=null && objNewAssgnmnt.Start_Date__c< mapScooterWithRecentEndedAssgnmnt.get(objNewAssgnmnt.Scooter__c).End_Date__c){
                            objNewAssgnmnt.addError('Start Date is overlapping with End date of existing assignments');
                        }
                    }*/
                    
                }
                
            }
            
            
        }
        catch(Exception ex){}

    }
    
    @future(callout=true) 
    public static void syncScooterAssignment(Set<Id> assignmentId) {
        QBSync_Controller controller = new QBSync_Controller();
        controller.synchronizeAssignment(assignmentId);
    }
}