/**
 * @description       : This component is used to display the selected record in the selected record section.
 * @author            : Amit Singh
 * @group             :
 * @last modified on  : 12-21-2021
 * @last modified by  : Amit Singh
**/
import { LightningElement, api } from 'lwc';

export default class SelectedRecord extends LightningElement {

    @api iconUrl;
    @api objectLabel;
    @api record;
    @api index;
    @api showLabel = false;
    handleRemove = (event) => {
        event.preventDefault();
        const closeEvent = new CustomEvent('close', {
            bubbles    : true,
            composed   : true,
            cancelable : true,
            detail: {
                data : {
                    record     : undefined,
                    recordId   : undefined
                }
            }
        });
        this.dispatchEvent(closeEvent);
    }
}
