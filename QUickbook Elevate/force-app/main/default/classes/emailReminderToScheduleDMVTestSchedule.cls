public class emailReminderToScheduleDMVTestSchedule implements schedulable {
    
    public void execute(System.SchedulableContext sc){
        emailReminderToScheduleDMVTestBatch objBatch= new emailReminderToScheduleDMVTestBatch();
        Database.executeBatch(objBatch);
        
    }
    
}