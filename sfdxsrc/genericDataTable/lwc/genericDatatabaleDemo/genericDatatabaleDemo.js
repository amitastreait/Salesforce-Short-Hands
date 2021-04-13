/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 03-30-2021
 * @last modified by  : Amit Singh
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   03-30-2021   Amit Singh   Initial Version
**/
import { LightningElement,api } from 'lwc';
import getTableData from '@salesforce/apex/GenericDataTableDemo.getTableData';

export default class GenericDataTable extends LightningElement {
    @api recordId;
    _result = [];
    _showSpinner = true;
    _dataArrive = false;

    async connectedCallback() {
        this._result = await getTableData({ accountId : '' });
        window.console.log( ' this._result ', this._result );
        if(this._result){
            this._dataArrive = true;
            this._showSpinner = false;
        }
    }
}