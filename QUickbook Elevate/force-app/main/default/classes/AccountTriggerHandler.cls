public class AccountTriggerHandler {
    public static Boolean isFirstTime = true;
	@future(callout=true)
    public static void syncAccount(Set<Id> newAccountsId) {
        QBSync_Controller controller = new QBSync_Controller();
        controller.synchronizeAccount(newAccountsId);
    }
}