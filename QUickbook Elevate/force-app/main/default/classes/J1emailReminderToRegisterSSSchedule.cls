public class J1emailReminderToRegisterSSSchedule implements schedulable {
    
    public void execute(System.SchedulableContext sc){
        J1emailReminderToRegisterSSBatch objBatch= new J1emailReminderToRegisterSSBatch();
        Database.executeBatch(objBatch);
        
    }
}