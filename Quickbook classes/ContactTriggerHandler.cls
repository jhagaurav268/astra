public class ContactTriggerHandler {
    public static Boolean isFirstTime = true;
    @future(callout=true)
    public static void syncContact(Set<Id> newContactsId) {
        QBSync_Controller controller = new QBSync_Controller();
        controller.synchronizeContact(newContactsId);
    }
}