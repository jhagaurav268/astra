/*
Created by   : Sampath Suranji
Description  : Maintain 1:1 relationship with rider contact and rider account
Created date : 04/12/2019
*/
trigger updateRiderAccount on Contact (before update, before insert) {
    List<Contact>objContactList = new List<contact>();
    Map<Id, contact>contactsMap = new Map<id, contact>();
    Map<Id, integer>accountsWithConCountMap = new Map<id, integer>();
    List<Id>accountIds = new List<id>();
    
    try
    {
        Id contactRecTypeId= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Rider').getRecordTypeId();
        Id accountRecTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Rider').getRecordTypeId();
        for(contact c:trigger.new ){
            if(c.RecordTypeId ==contactRecTypeId ){
                
                if(c.AccountId!=null ){                    
                    if(!accountIds.contains(c.AccountId)){
                        accountIds.add(c.AccountId);
                    }
                    else{
                        c.addError('Invalid Rider Account field');
                    }
                }
                
            }
            
        }
        
        if(accountIds.size()>0){
            
            if(trigger.IsInsert || trigger.IsUpdate){
                List<Account>accList = [select (select id from contacts),Id from Account where Id IN:accountIds];
                for(Account a: accList){
                    System.debug('a.contacts '+a.contacts);
                    if(!accountsWithConCountMap.containsKey(a.Id)){
                        accountsWithConCountMap.put(a.Id, a.contacts.size());
                    }
                }
                if(trigger.IsUpdate){
                    for(Contact c: trigger.new){
                        if(accountsWithConCountMap.containsKey(c.AccountId)&&  Trigger.oldMap.get(c.Id).AccountId!=c.AccountId){
                            if(accountsWithConCountMap.get(c.AccountId)>0){
                                c.addError('Invalid Rider Account field');
                            }    
                        }
                        
                    }
                }
                else{
                    for(Contact c: trigger.new){
                        if(accountsWithConCountMap.containsKey(c.AccountId)){
                            if(accountsWithConCountMap.get(c.AccountId)>0){
                                c.addError('Invalid Rider Account field');
                            }    
                        }
                        
                    }
                }
                
            }
            
        }
        
    }
    catch(Exception ex){}
    
}