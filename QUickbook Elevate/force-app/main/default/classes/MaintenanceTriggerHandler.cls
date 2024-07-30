public class MaintenanceTriggerHandler {
    public static Boolean isFirstTime = true;
    @future(callout=true)
    public static void syncMaintenance(Set<Id> maintenanceIds) {
        QBSync_Controller controller = new QBSync_Controller();
        controller.synchronizeMaintenance(maintenanceIds);
    }
}