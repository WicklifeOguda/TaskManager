@IsTest
public class TaskRestControllerTest {
    @IsTest
    static void testGetTasks() {
        // Creating sample Task__c records
        List<Task__c> tasks = new List<Task__c>{
            new Task__c(Name = 'Task 1', Due_Date__c = Date.today(), Completed__c = false),
            new Task__c(Name = 'Task 2', Due_Date__c = Date.today().addDays(1), Completed__c = true)
        };
        insert tasks;

        // Simulating the REST request
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/tasks';
        req.httpMethod = 'GET';

        RestContext.request = req;
        RestContext.response = new RestResponse();

        // Calling the REST method
        Test.startTest();
        List<TaskRestController.TaskDTO> taskDTOs = TaskRestController.getTasks();
        Test.stopTest();

        // Validating the results directly from the returned DTOs
        System.assertEquals(2, taskDTOs.size(), 'Two tasks should be returned');
        System.assertEquals('Task 1', taskDTOs[0].name, 'First task name should match');
        System.assertEquals('Task 2', taskDTOs[1].name, 'Second task name should match');
    }
}
