public class CompleteOverdueTasksScheduler implements Schedulable {
    public void execute(SchedulableContext context) {
        System.enqueueJob(new CompleteOverdueTasks());
    }
}
