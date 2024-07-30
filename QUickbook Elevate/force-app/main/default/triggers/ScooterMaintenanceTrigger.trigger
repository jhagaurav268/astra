trigger ScooterMaintenanceTrigger on Scooter_Maintenance__c (after insert, after update) {
    if(MaintenanceTriggerHandler.isFirstTime && trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
        MaintenanceTriggerHandler.isFirstTime = false;
        Set<Id> maintenanceIds = new Set<Id>();
        for(Scooter_Maintenance__c maintenance : trigger.new){
            if(System.IsBatch() == false && System.isFuture() == false){ 
                maintenanceIds.add(maintenance.Id);
            }
        }
        if (!maintenanceIds.isEmpty()) {
            MaintenanceTriggerHandler.syncMaintenance(maintenanceIds);
        }
    }
}