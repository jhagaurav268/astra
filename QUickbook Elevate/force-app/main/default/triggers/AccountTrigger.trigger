trigger AccountTrigger on Account (after insert, after update) {
    if(AccountTriggerHandler.isFirstTime && trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
        AccountTriggerHandler.isFirstTime = false;
        Set<Id> accountIds = new Set<Id>();
        for(Account acc : trigger.new){
            if(System.IsBatch() == false && System.isFuture() == false){
                accountIds.add(acc.Id);
            }
        }
        if (!accountIds.isEmpty()) {
            AccountTriggerHandler.syncAccount(accountIds);
        }
    }
}