import { api, LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class CustomLogger extends LightningElement {
    @api recordId;
    @api objectApiName;
    

    handleSuccess(){
        this.dispatchEvent(new ShowToastEvent({
            title: 'Success!',
            message: 'Record Updated',
            variant: 'success'
        }));
    }

    handleReset(event) {
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
    }

    handleError(event){
        this.dispatchEvent(new ShowToastEvent({
            title: 'Error',
            message: event.detail.message,
            variant: 'error'
        }));
    }
}