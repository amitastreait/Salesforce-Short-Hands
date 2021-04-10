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

export default class LwcFileUpload extends LightningElement {
    @api acceptedFormats;
    @api recordId;

    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;
        const eventFile = new CustomEvent('fileuploaded', {
            bubbles : true,
            composed : true,
            cancellable : true,
            detail: { 
                data : {
                    file : uploadedFiles
                }
            }
        });
        this.dispatchEvent(eventFile);
    }
    
}