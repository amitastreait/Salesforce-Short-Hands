/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 12-21-2020
 * @last modified by  : Amit Singh
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   12-20-2020   Amit Singh   Initial Version
**/
import { LightningElement, track, wire, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadScript } from 'lightning/platformResourceLoader';
import PARSER from '@salesforce/resourceUrl/PapaParse';

import uploadFile from '@salesforce/apex/CustomMetadataUploader.uploadFile';
import getItems from '@salesforce/apex/CustomMetadataUploader.getItems';

import { FlowAttributeChangeEvent, FlowNavigationNextEvent, FlowNavigationFinishEvent, FlowNavigationBackEvent, FlowNavigationPauseEvent } from 'lightning/flowSupport';

const MAX_FILE_SIZE = 1500000;

const columns = [
    { label: 'Success', fieldName: 'success' },
    { label: 'File Name', fieldName: 'fileName', wrapText:true },
    { label: 'Full Name', fieldName: 'fullName', wrapText:true },
    { label: 'Problem', fieldName: 'problem', wrapText:true }
];

import { subscribe, unsubscribe, onError } from 'lightning/empApi';

export default class CustomMetadataUploader extends LightningElement {

    @api availableActions = [];
    @api requiredMessage = '⚠️ Value is required for this field';

    @track filesUploaded;
    fileName;
    fileSize;

    isLoading = false;
    parserInitialized = false;
    _rows;
    _results;
    _data;
    _errors;
    _metadataName = '';
    columns = columns;
    _errorData;
    _totalErrors;

    channelName = '/event/MetadataDeploymentResult__e';
    subscription = {};

    renderedCallback() {
        if(!this.parserInitialized){
            loadScript(this, PARSER)
            .then(() => { this.parserInitialized = true; })
            .catch(error => console.error('Parser Initialized Error \n ', error));
        }
        this.parserInitialized = true;
    }

    connectedCallback() {     
        this.registerErrorListener();
        this.handleSubscribe();  
    }

    disconnectedCallback(){
        unsubscribe(this.subscription, response => {
            console.log('unsubscribe() response: ', JSON.stringify(response));
        });
    }

    handleSubscribe() {
        const messageCallback = this.handleDeployResult.bind(this);
        subscribe(this.channelName, -1, messageCallback ).then(response => {
            this.subscription = response;
        });
    }

    registerErrorListener() {
        onError(error => {
            console.log('Received error from server: ', JSON.stringify(error));
        });
    }

    @wire(getItems)
    wiredData({ error, data }) {
        if (data) {
            this._data = data;
        } else if (error) {
            console.error('Error: \n ', error);
        }
    }

    get items(){
        let values;
        if(this._data){
            values = this._data.map(item => {
                return {
                    label : item,
                    value : item
                };
            });
        }
        return values;
    }

    handleDeployResult(result){
        let payload = JSON.parse(result.data.payload.Payload__c);
        this._errorData = payload['componentFailures'];
        this._totalErrors = this._errorData.length;
        this.isLoading = false;
        if(!this._totalErrors){
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success',
                message: 'Metadata Imported',
                variant: 'success'
            }));
        }else if(this._totalErrors){
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: 'Error Occured. See below table',
                variant: 'error'
            }));
        }
    }

    // handleInputChange(event){
    //     if(event.target.files.length > 0){

    //         const file = event.target.files[0];
    //         this.fileName = file.name;
    //         this.isLoading = true;

    //         Papa.parse(file, {
    //             quoteChar: '"',
    //             header: 'true',
    //             complete: (results) => {
    //                 this._rows = results.data;
    //                 this.isLoading = false;
    //             },
    //             error: (error) => {
    //                 console.error(error);
    //                 this.isLoading = false;
    //             }
    //         })
    //     }
    // }

    handleMdChange(event){
        event.preventDefault();
        this._metadataName = event.target.value;
    }

    handleFilesChange(event) {
        if(event.target.files.length > 0) {
            this.filesUploaded = event.target.files[0];
            this.fileName = event.target.files[0].name;
            this.fileSize = this.formatBytes(this.filesUploaded.size, 2);
        }
    }

    handleUpload(){

        let allValid = this.validateInput();
        if( !allValid ){
            return;
        }

        if(!this.filesUploaded){
            this._errors = 'Please Select a file.';
            return;
        }

        var fileCon = this.filesUploaded;
        if (fileCon.size > MAX_FILE_SIZE) {
            let message = 'File size cannot exceed ' + MAX_FILE_SIZE + ' bytes.\n' + 'Selected file size: ' + fileCon.size;
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: message,
                variant: 'error'
            }));
            return;
        }
        var reader = new FileReader();
        var self = this;
        reader.onload = function() {
            var fileContents = reader.result;
            self.upload(fileContents);
        };
        reader.readAsText(fileCon);
    }

    upload = (content) => {

        this.isLoading = true;        
        uploadFile({ 
            base64Data : JSON.stringify( content ),
            metadataName : this._metadataName
        })
        .then(result => {
        })
        .catch(error => {
            console.error('Error:', error);
            this._errors = JSON.stringify(error);
        })
        .finally(()=>{
            
        });

    }
    
    formatBytes = (bytes) =>{
        var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
        if (bytes == 0) return 'n/a';
        var i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)));
        if (i == 0) return bytes + ' ' + sizes[i];
        return (bytes / Math.pow(1024, i)).toFixed(1) + ' ' + sizes[i];
    }

    validateInput = ()=>{
        const allValid = [...this.template.querySelectorAll('lightning-combobox')]
            .reduce((validSoFar, inputCmp) => {
                        inputCmp.reportValidity();
                        return validSoFar && inputCmp.checkValidity();
            }, true);
        return allValid;
    }

    // Flow Navigations
    @api
    handleGoNext() {
        if (this.availableActions.find(action => action === 'NEXT')) {
            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);
        }
    }

    @api 
    handleGoFinish() {
        const navigateNextEvent = new FlowNavigationFinishEvent();
        this.dispatchEvent(navigateNextEvent);
    }

    @api 
    handleGoBack() {
        const navigateNextEvent = new FlowNavigationBackEvent();
        this.dispatchEvent(navigateNextEvent);
    }
    @api 
    handleGoPause() {
        const navigateNextEvent = new FlowNavigationPauseEvent();
        this.dispatchEvent(navigateNextEvent);
    }

    // Flow Validation
    @api
    validate() {
        if( this.validateInput() ) { 
            return { 
                isValid: true 
            }; 
        } else { 
            return { 
                isValid: false, 
                errorMessage: this.requiredMessage 
            }; 
        } 
    }
}