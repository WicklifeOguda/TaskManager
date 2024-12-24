public class CompleteOverdueTasks implements Queueable {
    public void execute(QueueableContext context) {
        // Querying all overdue tasks that are not completed
        List<Task__c> overdueTasks = [
            SELECT Id, Completed__c
            FROM Task__c
            WHERE Due_Date__c < TODAY AND Completed__c = false
        ];

        // Updating the Completed__c field to true
        if (!overdueTasks.isEmpty()) {
            for (Task__c task : overdueTasks) {
                task.Completed__c = true;
            }
            update overdueTasks;
        }
    }
}
