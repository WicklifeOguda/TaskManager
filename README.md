# Salesforce TaskManager

This is a guide on how to setup and test the project as I have done it, assuming you are cloning from my repo. Also I am assuming you have an environment with SalesForce well setup and configured. Most of the commands here assumes you are using a unix based terminal (Linux/Mac) except those that are Salesforce-specific should be the same on any OS.

1. Clone the project: using git clone
   `git clone git@github.com:WicklifeOguda/task-manager.git`

2. Open the project in your editor and confirm that all requirements are met, install anything that are user specific which are not pushed together with the project. Your editor will give you warnings about the missing dependencies or important tools.

## 1. Deploying the Custom Object and Code

### Custom Object: Task\_\_c

The custom object Task**c with the following fields:
Name (Text) - Required
Due_Date**c (Date)
Completed\_\_c (Checkbox, default false)

To deploy the custom object and code to your Salesforce org:
Authenticate to your Salesforce org using:

`sfdx force:auth:web:login -a <YourOrgAlias or username>`

Deploy the metadata using Salesforce DX (e.g., if you're using a Scratch org):

`sfdx force:source:push`

If you're using a non-Scratch org (e.g., Sandboxes or Production), deploy with:

`sfdx force:source:deploy -p force-app/main/default`

For deploying only the specific objects
`sfdx force:source:deploy -p force-app/main/default/objects/`

## 2. Accessing and Testing the LWC

Adding the LWC to a Lightning App or Tab

To view and test the taskList Lightning Web Component (LWC):

    Create a Lightning App Page:
        1. Go to Setup in Salesforce.
        2. Search for App Builder.
        3. Select Lightning App Builder.
        4. Click New and choose App Page.
        5. Drag the taskList component onto the page and save.

    Add the LWC to a Lightning Tab:
        1. Go to Setup and search for Tabs.
        2. Under Lightning Component Tabs, click New.
        3. Choose the taskList component and give it a name (e.g., Task Management).
        4. Save and add the tab to your app.

    Testing the LWC:
        After deploying, open your Salesforce app and navigate to the app page or tab where taskList is displayed.
        You should see the list of tasks with checkboxes that can be marked as completed.

## 3. Running and Testing the Batch/Queueable Job

Manually Running the Queueable Job

From the Developer Console:
Open the Developer Console from your Salesforce org.
Go to Debug -> Open Execute Anonymous Window.
Run the following Apex code to execute the batch job:

`System.enqueueJob(new CompleteOverdueTasks());`

This will run the batch job, which will update all tasks where Due_Date**c is less than today and Completed**c is false.

Or
`System.schedule('Daily Task Completion Job', '0 0 0 * * ?', new CompleteOverdueTasksScheduler());`

Where the Cron Expression: `'0 0 0 * * ?'` schedules the job daily at midnight.

Manually Scheduling the Job:

Go to Setup -> Apex Classes.
Click Schedule Apex.
Set the job to run at a specific interval (e.g., daily) by selecting the Scheduled Jobs section.
Choose the class `CompleteOverdueTasks` and define the scheduling parameters.

## 4. Calling the Apex REST Endpoint

Accessing the Task REST Endpoint

The REST API allows you to retrieve a list of tasks. To call the endpoint:

    Using cURL:

        First, authenticate and get a Salesforce access token:

curl -X POST https://login.salesforce.com/services/oauth2/token \
 -d "grant_type=password" \
 -d "client_id=<YourConsumerKey>" \
 -d "client_secret=<YourConsumerSecret>" \
 -d "username=<YourSalesforceUsername>" \
 -d "password=<YourSalesforcePasswordAndToken>"

After receiving the access token, use it in the following cURL command to make a GET request:

    curl -X GET https://<yourInstance>.salesforce.com/services/apexrest/tasks \
         -H "Authorization: Bearer <AccessToken>"

Using Postman:

    1. Open Postman and set up a new GET request.
    2. Use the URL: `https://<yourInstance>.salesforce.com/services/apexrest/tasks`.
    3. In the Authorization tab, select Bearer Token and paste the token you    received from the OAuth authentication.
    4. Send the request, and you should receive a list of tasks in JSON format.

## Assumptions

This solution assumes you are using Salesforce DX, and that you have access to the Salesforce Developer Console and Lightning App Builder for testing.
The batch job assumes that there is a significant number of Task\_\_c records to process.
