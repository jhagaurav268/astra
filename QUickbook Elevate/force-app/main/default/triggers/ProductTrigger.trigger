trigger ProductTrigger on Product2 (after insert, after update) {
	if(ProductTriggerHandler.isFirstTime && trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
        ProductTriggerHandler.isFirstTime = false;
        Set<Id> productIds = new Set<Id>();
        for(Product2 prod : trigger.new){
            System.debug(prod.Id);
            if(System.IsBatch() == false && System.isFuture() == false){ 
                productIds.add(prod.Id);
            }
        }
        if (!productIds.isEmpty()) {
            ProductTriggerHandler.syncProduct(productIds);
        }
    }
}