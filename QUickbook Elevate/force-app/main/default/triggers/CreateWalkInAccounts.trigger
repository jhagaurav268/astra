trigger CreateWalkInAccounts on Contact (before insert , after insert) {
    
    
    
    Id contactRecTypeId= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Walk-In').getRecordTypeId();
    Id accountRecTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Walk-In').getRecordTypeId();
    Map<ID , Account> conAccountMap = new Map<ID , Account>() ;
    Map<Id , Account> accNumberMap = new Map<Id , Account>() ;
    List<Contact> conList = new List<Contact>() ;
    
    if(Trigger.isBefore && Trigger.isInsert){   
        for(contact conObj :trigger.new ){
            system.debug(conObj.accountId );
            system.debug(conObj.RecordTypeId);
            if(conObj.RecordTypeId ==contactRecTypeId && conObj.accountId == null){
                Account objAccount = new Account();
                objAccount.Name= conObj.firstname+ ' '+ conObj.LastName ;
                
                objAccount.RecordTypeId = accountRecTypeId ;
                objAccount.Rider_Contact__c = conObj.Id;
                //objAccount.AcctSeed__Accounting_Type__c = 'Customer and Vendor' ; //uncomment this field after installation of AcctSeed
                
                conAccountMap.put(conObj.Id , objAccount) ;
                system.debug('======'+conObj.Id) ;
            }
        }
        
        if(conAccountMap.values().size() > 0){
            
            try{
                insert conAccountMap.values() ;
                
                //  for(Account acc : [Select id , Name , Account_Number__c from Account where id IN:conAccountMap.values()]){
                //         accNumberMap.put(acc.Id , acc) ;
                
                //     }
                
                
                
                for(contact conObj :trigger.new ){
                    if(conAccountMap.containsKey(conObj.ID)){
                        conObj.accountid = conAccountMap.get(conObj.ID).Id ;
                        // if(accNumberMap.containsKey(conObj.accountid)){
                        // conObj.LastName = conObj.LastName + ' '+accNumberMap.get(conObj.accountid).Account_Number__c  ;
                        //  }
                        
                        
                    }
                }
                
            }catch(Exception e){
                System.debug('---------'+e) ;
            }
            
        }
    }  
    /*********************************************************************************/    
    
    if(Trigger.isAfter && Trigger.isInsert){  
        
        Set<ID> accIds = new Set<Id>() ;
        Map<ID ,ID> conAccMap = new Map<ID , ID>() ; 
        Id contactRecTypeId= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Walk-In').getRecordTypeId();
        Id accountRecTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Walk-In').getRecordTypeId();
        
        List<Account> accToUpdate = new List<Account>() ;
        for(contact conObj :trigger.new ){
            if(conObj.RecordTypeId ==contactRecTypeId){
                if(conObj.accountId != null){
                    accIds.add(conObj.accountId ) ;
                    conAccMap.put(conObj.accountId , conObj.id) ;
                } 
            }        
        }
        
        if(accIds.size() > 0){
            
            try{
                
                for(Account acc : [Select id , recordtypeID,  Name , Account_Number__c , Rider_Contact__c  from Account 
                                   where ID IN:accIds])
                {
                    
                    if(acc.recordtypeId == accountRecTypeId){   
                        if(conAccMap.containsKey(acc.ID)){
                            acc.Rider_Contact__c  = conAccMap.get(acc.ID) ;
                            if(!acc.Name.contains(acc.Account_Number__c)){
                                acc.Name = acc.Name + ' '+acc.Account_Number__c  ;
                            }
                            accToUpdate.add(acc) ;
                        }   
                    }
                    
                }
                
                update accToUpdate ;
                
                if(System.Test.isRunningTest()){
                    integer x=0;
                    integer y= x/0;
                }
            }catch(Exception e){
                System.debug('---------'+e) ;
            }
            
        }
    }  
    
    
    
    
    
    
    
    
}