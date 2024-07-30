public class emailReminderToRegisterSSSchedule implements schedulable {
    
    public void execute(System.SchedulableContext sc){
        emailReminderToRegisterSSBatch objBatch= new emailReminderToRegisterSSBatch();
        Database.executeBatch(objBatch);
        
    }

}