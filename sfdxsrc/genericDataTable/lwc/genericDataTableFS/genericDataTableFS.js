/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 04-13-2021
 * @last modified by  : Amit Singh
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   04-13-2021   Amit Singh   Initial Version
**/
import { LightningElement, api } from 'lwc';
import getTableDataFS from '@salesforce/apex/GenericDataTableDemo.getTableDataFS';

export default class GenericDataTableFS extends LightningElement {

    _result;
    _dataArrive;
    _showSpinner;

    async connectedCallback(){
        var apexResult = await getTableDataFS();
        let properties = {
            "isFieldSet":true,
            "defaultSortBy":"Name",
            "defaultSortDirection": "asc",
            "isShowPagination": true,
            "keyField": "Id",
            "numberOfRecords": 8,
            "pagingPicklistValues": ["5","10", "20", "50"],
            "showPagingPicklist": true,
            "showSearch": true,
            "lstDataTableColumns": apexResult.fieldSetResult[0],
            "strDataTableData": apexResult.fieldSetResult[1]
        };
        this._result = properties;
        if(this._result){
            this._dataArrive = true;
            this._showSpinner = false;
        }
    }
}