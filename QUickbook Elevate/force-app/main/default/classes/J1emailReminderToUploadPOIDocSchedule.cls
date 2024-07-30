public class J1emailReminderToUploadPOIDocSchedule implements schedulable {
    
    public void execute(System.SchedulableContext sc){
        J1emailReminderToUploadPOIDocBatch objBatch= new J1emailReminderToUploadPOIDocBatch();
        Database.executeBatch(objBatch);
        
    }

}