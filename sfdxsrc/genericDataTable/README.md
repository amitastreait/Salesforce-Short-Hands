# Generic DataTable using Custom Metadata & Field Set

This subrepo contains how to use Custom metadata or field set to generate the dynamic lightning data table

# Generate Table using Custom Metadata

### Prepare Custom Metadata Records

Before you start developing you need to prepare the record for custom metadata which you will get after installing this code base.

- Data table : This Metadata Contains the Information about the Data table, like ObjectName, Pagination, Searching, Sorting & etc. The Name of this Metadata Record will meed to be passed in the apex class to generate the table.

- Data Table Content : This Custom Metadata Contains the information about the table columns which are fields to be displayed along with the data types and URL capability.

### Prepare Apex Class

Once you are done with the Metadata Prepration then you need to create an Apex Class which will extend `GenericDataTableController` apex class.

Create a Method which will look like below

```

@AuraEnabled(Cacheable=true)
public static GenericDataTableController.DataTableResponse getTableData(String accountId){
    
    GenericDataTableDemo obj = new GenericDataTableDemo();
    obj.METADATA_NAME = 'Gold_Accounts';
    // obj.IDS_SET = new Set<String>();
    // obj.IDS_SET.add(accountId);
    // obj.WHERE_CLAUSE='AccountId IN : IDS_SET';

    return obj.getTable();
}

```

- METADATA_NAME : You need to provide name of the Custom Metadata
- IDS_SET :  is Set of String which can contains Ids, String and then you can put the filter using that field
- WHERE_CLAUSE : You can pass the condition to filter on
- getTable : The method which prepares the datatable based on the Given Metadata

## Prepare the Custom LWC component for Custom metadata Approcah

Create a Custom lightning Web Component and use below code

```
<template>
    <lightning-card  variant="Narrow"  title="Generic DataTable" icon-name="standard:account">
        <p class="slds-p-horizontal_small">
            <!--SPINNER-->
            <template if:true={_showSpinner}>
                <lightning-spinner alternative-text="Loading" size="small" variant="brand"></lightning-spinner>
            </template>
            <!--SPINNER-->
            
            <template if:true={_dataArrive}>
                <c-generic-data-table-l-w-c result={_result}></c-generic-data-table-l-w-c>
            </template>
        </p>
        
    </lightning-card>
</template>

```

And below is the code for JS file

```

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

```

# Generate Table using FieldSet

### Prepare FieldSet

Before we start development for this approach we need to create a Field Set on the Object which we wanted to generate the Tables

### Prepare Apex Class

Once you are done with the Metadata Prepration then you need to create an Apex Class which will extend `GenericDataTableController` apex class.

Create a Method which will look like below

```

@AuraEnabled(Cacheable=true)
public static GenericDataTableController.DataTableResponse getTableDataFS(){
    
    GenericDataTableDemo obj = new GenericDataTableDemo();
    obj.FIELD_SET_NAME = 'New_Account';
    obj.IS_FIELDSET = true;
    obj.OBJECT_API_NAME = 'Account';
    // obj.IDS_SET = new Set<String>();
    // obj.IDS_SET.add(accountId);
    // obj.WHERE_CLAUSE='AccountId IN : IDS_SET';

    return obj.getFieldSetTable();

```

- FIELD_SET_NAME : The Name of The Custom Fields
- IS_FIELDSET : the value will always be true
- OBJECT_API_NAME : The Name of the Object which have the field Set
- IDS_SET :  is Set of String which can contains Ids, String and then you can put the filter using that field
- WHERE_CLAUSE : You can pass the condition to filter on
- getFieldSetTable : The method which prepares the datatable based on the Given Field Set

## Prepare the Custom LWC component for Custom metadata Approcah

Create a Custom lightning Web Component and use below code

```
<template>
    <lightning-card  variant="Narrow"  title="Generic DataTable" icon-name="standard:account">
        <p class="slds-p-horizontal_small">
            <!--SPINNER-->
            <template if:true={_showSpinner}>
                <lightning-spinner alternative-text="Loading" size="small" variant="brand"></lightning-spinner>
            </template>
            <!--SPINNER-->
            
            <template if:true={_dataArrive}>
                <c-generic-data-table-l-w-c result={_result}></c-generic-data-table-l-w-c>
            </template>
        </p>
        
    </lightning-card>
</template>

```

And below is the code for JS file

```

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

```


## Contribute to the Utilities
If you wanted to contribute to the utilities then please follow the steps from below link
- [Contribute to the Utilities](https://github.com/amitastreait/Salesforce-Short-Hands)

## Share feedback
Please do share the feedback