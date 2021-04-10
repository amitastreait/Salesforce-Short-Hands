/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 12-19-2020
 * @last modified by  : Amit Singh
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   12-19-2020   Amit Singh   Initial Version
**/
/*
{
        label: 'Parent', fieldName: 'ParentId', type: 'lookup', typeAttributes: {
            placeholder: 'Select Parent Account',
            uniqueId: { fieldName: 'Id' }, //pass Id of current record to lookup for context
            object: "Account",
            icon: "standard:account",
            label: "Account",
            displayFields: "Name, AccountNumber",
            displayFormat: "Name (AccountNumber)",
            filters: "",
            valueId: { fieldName: 'ParentId' } // binding Parent Id of current item in row to autopopulate value on load.
        }
    },
*/
import { LightningElement, track, wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountDetailsService.getAccounts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';

const columns = [
    { label: 'Name', fieldName: 'Name', sortable: true, editable: true },
    {
        label: 'Rating', type: 'picklist', fieldName: 'Rating', sortable: true, typeAttributes: {
            label : 'Choose Rating',
            placeholder: 'Choose rating', 
            options: [
                { label: 'Hot', value: 'Hot' },
                { label: 'Warm', value: 'Warm' },
                { label: 'Cold', value: 'Cold' },
            ],
            parentrecord: { fieldName: 'Id' } 
        }
    },
    { label: 'Upload Document', type: 'fileUpload', fieldName: 'Id', 
        typeAttributes : {
            acceptedFormats : '.jpg,.jpeg,.pdf,.png',
            doUpload : {
                fieldName   : 'UPLOAD_FILE'
            }
        } 
    },
    { label: 'ICON', type: 'image', fieldName: 'IMAGE_URL', 
        typeAttributes : {
            alttxt : 'Account Image',
            width  : 50,
            height : 50
        } 
    },
    {
        label: 'Parent', fieldName: 'ParentId', type: 'lookup', typeAttributes: {
            object: "Account",
            icon: "standard:account",
            label: "Account",
            placeholder: 'Select Parent Account',
            fields: ["Name", "Rating", "AccountNumber"],
            displayFields : 'Name, Rating, AccountNumber',
            valueId: { fieldName: 'ParentId' },
            valueName : "Amit Singh",
            currentRecordId : { fieldName: 'Id' },
        }
    }
];

export default class ExtendedDataTable extends LightningElement {

    defaultSortDirection = 'asc';
    sortDirection = 'asc';
    sortedBy;
    isLoading = false;

    columns = columns;
    @track accounts;
    @track error;
    @track draftValues = [];

    @wire(getAccounts)
    wiredData( { error, data } ) {
        if (data) {
            let stringifiedData = JSON.stringify(data);
            let parsedData = JSON.parse(stringifiedData);
            parsedData.forEach(account => { 
                account.IMAGE_URL = 'https://greenyards.com.my/wp-content/uploads/2016/09/cropped-Greenyards-icon-01.png';
                account.UPLOAD_FILE = true;
            });
            this.accounts = parsedData;
        } else if (error) {
            console.error('Error:', error);
            this.error = error
        }
    };

    handleUploadFinished(event) {
        event.stopPropagation();
        this.dispatchEvent(new ShowToastEvent({
            title: 'Success',
            message: 'File Uploaded',
            variant: 'success'
        }));
        let strindData =  JSON.stringify(event.detail.data);
    }
    handleLookup(event){
        event.stopPropagation();
        let strindData =  JSON.stringify(event.detail.data);
        window.console.log(' strindData Lookup ', strindData );
    }
    handlePickListChanged(event){
        event.stopPropagation();
        let strindData =  JSON.stringify(event.detail.data);
        console.log(' picklist data ', strindData );
    }

    handleSelection(event){

    }

    handleSave(event) {
        
        const recordInputs =  event.detail.draftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
            return { fields };
        });
        
        const promises = recordInputs.map(recordInput => updateRecord(recordInput));
        this.isLoading = true;
        
        Promise.all(promises).then(record => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'All Record updated',
                    variant: 'success'
                })
            );
            this.draftValues = [];
            return refreshApex(this.accounts);
        }).catch(error => {
            console.error(' Error Occured While Uploading Records ', error);
        })
        .finally( () => {
            this.isLoading = false;
        });
    }

    onHandleSort(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.accounts];

        cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
        this.accounts = cloneData;
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;
    }

    sortBy(field, reverse, primer) {
        const key = primer
        ? function(x) {
            return primer(x[field]);
        }
        : function(x) {
            return x[field];
        };

        return function(a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    }
}