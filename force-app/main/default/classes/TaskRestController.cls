@RestResource(urlMapping='/tasks')
global class TaskRestController {
    @HttpGet
    global static List<TaskDTO> getTasks() {
        // Querying Task__c records
        List<Task__c> tasks = [
            SELECT Name, Due_Date__c, Completed__c
            FROM Task__c
        ];

        // Mapping tasks to DTO objects for clean JSON serialization
        List<TaskDTO> taskDTOs = new List<TaskDTO>();
        for (Task__c task : tasks) {
            taskDTOs.add(new TaskDTO(task.Name, task.Due_Date__c, task.Completed__c));
        }

        return taskDTOs;
    }

    // DTO Class for structured JSON response
    global class TaskDTO {
        public String name;
        public Date dueDate;
        public Boolean completed;

        public TaskDTO(String name, Date dueDate, Boolean completed) {
            this.name = name;
            this.dueDate = dueDate;
            this.completed = completed;
        }
    }
}
