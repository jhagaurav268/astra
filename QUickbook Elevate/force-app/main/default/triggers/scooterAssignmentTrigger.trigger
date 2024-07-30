trigger scooterAssignmentTrigger on Scooter_Assignment__c (before insert,before update, after insert, after update) {
    
    if(trigger.isInsert && trigger.isbefore){
        scooterAssignmentTriggerHandler.beforeInsert(trigger.new);
    }
    else if(trigger.isUpdate && trigger.isbefore){
        scooterAssignmentTriggerHandler.beforeUpdate(trigger.new, trigger.newMap,trigger.Oldmap);
    }
    else if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
        Set<Id> assignmentIds = new Set<Id>();
        for(Scooter_Assignment__c assignment : trigger.new){
            if(System.IsBatch() == false && System.isFuture() == false){ 
                assignmentIds.add(assignment.Id);
            }
        }
        if (!assignmentIds.isEmpty()) {
            scooterAssignmentTriggerHandler.syncScooterAssignment(assignmentIds);
        }
    }
}