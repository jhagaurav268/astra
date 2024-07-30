public class QBTokenRefreshBatch implements Schedulable {
    public void execute(SchedulableContext sc) {
        makeCallout();
    }
    
    @future(callout=true)
    public static void makeCallout(){
        QBCallouts callouts = new QBCallouts();
        callouts.updateRefreshToken();
    }
}