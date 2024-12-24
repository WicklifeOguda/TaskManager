@IsTest
public class CompleteOverdueTasksTest {
    @IsTest
    static void testExecute() {
        // Setup: Creating test Task__c records
        List<Task__c> tasks = new List<Task__c>{
            new Task__c(Name = 'Overdue Task 1', Due_Date__c = Date.today().addDays(-1), Completed__c = false),
            new Task__c(Name = 'Overdue Task 2', Due_Date__c = Date.today().addDays(-2), Completed__c = false),
            new Task__c(Name = 'Not Overdue Task', Due_Date__c = Date.today().addDays(1), Completed__c = false)
        };
        insert tasks;

        // Executing the Queueable class
        Test.startTest();
        System.enqueueJob(new CompleteOverdueTasks());
        Test.stopTest();

        // Verifying the results
        Task__c overdueTask1 = [SELECT Completed__c FROM Task__c WHERE Name = 'Overdue Task 1' LIMIT 1];
        Task__c overdueTask2 = [SELECT Completed__c FROM Task__c WHERE Name = 'Overdue Task 2' LIMIT 1];
        Task__c notOverdueTask = [SELECT Completed__c FROM Task__c WHERE Name = 'Not Overdue Task' LIMIT 1];

        System.assertEquals(true, overdueTask1.Completed__c, 'Overdue Task 1 should be marked as completed');
        System.assertEquals(true, overdueTask2.Completed__c, 'Overdue Task 2 should be marked as completed');
        System.assertEquals(false, notOverdueTask.Completed__c, 'Not Overdue Task should not be marked as completed');
    }
}
