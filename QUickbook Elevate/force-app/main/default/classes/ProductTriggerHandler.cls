public class ProductTriggerHandler {
    public static Boolean isFirstTime = true;
	@future(callout=true)
    public static void syncProduct(Set<Id> productId) {
        QBSync_Controller controller = new QBSync_Controller();
        controller.synchronizeProduct(productId);
    }
}