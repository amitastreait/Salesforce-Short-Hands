/**
 * @description       : Lightning Data Table
 * @author            : Amit Singh
 * @group             : Lightning Web Component
 * @last modified on  : 04-05-2021
 * @last modified by  : Amit Singh
 * Modifications Log
 * Ver   Date         Author       Modification
 * 1.0   12-19-2020   Amit Singh   Initial Version
**/
import LightningDatatable from 'lightning/datatable';
/*
    import all supporting components
*/
import FileUploadTemplate  from        './fileUpload.html';
import lookupTemplate      from        './lwclookup.html';
import picklistTemplate    from        './picklist.html';
import imageTemplate       from        './image.html';

export default class LwcDatatable extends LightningDatatable {
    static customTypes = {
        fileUpload: {
            template: FileUploadTemplate,
            typeAttributes: ['acceptedFormats','doUpload']
        },
        lookup : {
            template: lookupTemplate,
            typeAttributes: ['object', 'icon', 'label', 'placeholder', 'fields', 'displayFields', 'valueId', 'valueName','currentRecordId'],
        },
        picklist : {
            template: picklistTemplate,
            typeAttributes: ['label','placeholder', 'options','parentrecord','showEdit','class'],
        },
        image : {
            template: imageTemplate,
            typeAttributes: ['alttxt','width','height'],
        }
    };
}