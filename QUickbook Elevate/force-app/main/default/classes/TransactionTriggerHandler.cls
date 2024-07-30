public class TransactionTriggerHandler {
    public static Boolean isFirstTime = true;
    @future(callout=true)
    public static void syncTransactions(Set<Id> transIds) {
        QBSync_Controller controller = new QBSync_Controller();
        controller.synchronizeTransaction(transIds);
    }
}