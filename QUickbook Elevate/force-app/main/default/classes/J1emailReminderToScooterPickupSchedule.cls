public class J1emailReminderToScooterPickupSchedule implements schedulable {
    
    public void execute(System.SchedulableContext sc){
        J1emailReminderToScooterPickupBatch objBatch= new J1emailReminderToScooterPickupBatch();
        Database.executeBatch(objBatch);
        
    }
    
}