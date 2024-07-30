trigger TransactionTrigger on mPOS__Transaction__c (after insert, after update) {
	if(TransactionTriggerHandler.isFirstTime && trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
        TransactionTriggerHandler.isFirstTime = false;
        Set<Id> transIds = new Set<Id>();
        for(mPOS__Transaction__c trans : trigger.new){
            if(System.IsBatch() == false && System.isFuture() == false){ 
                transIds.add(trans.Id);
            }
        }
        if (!transIds.isEmpty()) {
            TransactionTriggerHandler.syncTransactions(transIds);
        }
    }
}