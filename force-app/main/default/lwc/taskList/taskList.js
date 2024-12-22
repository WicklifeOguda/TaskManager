import { LightningElement, wire, track } from 'lwc';
import getTasks from '@salesforce/apex/TaskController.getTasks';
import markTaskCompleted from '@salesforce/apex/TaskController.markTaskCompleted';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class TaskList extends LightningElement {
    @track tasks = [];
    @track error;
    @track isLoading = false;

    columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Due Date', fieldName: 'Due_Date__c', type: 'date' },
        {
            label: 'Completed',
            fieldName: 'Completed__c',
            type: 'boolean',
            cellAttributes: { alignment: 'center' },
        },
        {
            type: 'button',
            typeAttributes: {
                label: 'Mark as Completed',
                name: 'complete',
                variant: 'brand',
                disabled: { fieldName: 'Completed__c' },
            },
        },
    ];

    @wire(getTasks)
    wiredTasks({ error, data }) {
        if (data) {
            this.tasks = data;
            this.error = undefined;
        } else if (error) {
            this.error = error.body.message;
            this.tasks = [];
        }
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;

        if (actionName === 'complete') {
            this.markTaskAsCompleted(row.Id);
        }
    }

    markTaskAsCompleted(taskId) {
        this.isLoading = true;
        markTaskCompleted({ taskId })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Task marked as completed.',
                        variant: 'success',
                    })
                );
                return refreshApex(this.tasks);
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error.body.message,
                        variant: 'error',
                    })
                );
            })
            .finally(() => {
                this.isLoading = false;
            });
    }
}
