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
import { api, LightningElement } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import leaflet from '@salesforce/resourceUrl/CustomDataTable';
export default class LwcPicklist extends LightningElement {
    @api label;
    @api placeholder;
    @api value;
    @api options = [];
    @api parentrecord;

    connectedCallback(){
        Promise.all([
            loadStyle(this, leaflet)
        ]).then(() => {
            console.log('OUTPUT : '+'Style Loaded');
        });
    }

    handleChange(event){
        const eventPick = new CustomEvent('picklistchanged', {
            bubbles : true,
            composed : true,
            cancelable : true,
            detail: {
                data : {
                    selectedValue : event.target.value,
                    relatedRecord : this.parentrecord
                }
            }
        });
        this.dispatchEvent(eventPick);
    }
}