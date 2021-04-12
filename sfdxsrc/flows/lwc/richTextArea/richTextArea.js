import { api, LightningElement } from 'lwc';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent, FlowNavigationFinishEvent, FlowNavigationBackEvent, FlowNavigationPauseEvent } from 'lightning/flowSupport';

export default class RichTextArea extends LightningElement {

    @api placeholder;
    @api value;
    @api required = false;
    @api requiredMessage = '⚠️ Value is required for this field';
    @api label;

    @api availableActions = [];
    _validity = true;

    rendered= false;

    renderedCallback(){
        if(this.rendered){
            return;
        }
        this.rendered = true;
        if( this.required ) {
            let textArea = this.template.querySelector('lightning-input-rich-text');
            textArea.required = true;
        }
    }

    handleChange = (event)=>{
        event.preventDefault();
        this.value = event.target.value;
    }

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

    validateInput(){
        if(!this.value){
            this._validity = false;
        }
        return this._validity;
    }

}