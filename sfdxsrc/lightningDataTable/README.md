# Extend Lightning DataTable in Lightning Web Component

As we know that there is limitation of standard data table and we can not have custom lookup into datatable so this repo I have implemented custom lookup, picklist inside standard Lightning Data Table.

This folder contains all the required component to use Custom Lookup, PickList or any other custom component inside Standard DataTable
`extendedDataTable` component contains the demo which contains the picklist and Custom Lookup along with the Custom File Upload inside 
standard DataTable

## Usage

To use this component inside your component use below code and replace the variable with the appropriate variables.

```
<p class="slds-p-horizontal_small">
    <c-lwc-data-table key-field="id"
            data={accounts}
            columns={columns}
            default-sort-direction={defaultSortDirection}
            sorted-direction={sortDirection}
            sorted-by={sortedBy}
            onsort={onHandleSort}
            onsave={handleSave}
            draft-values={draftValues} 
            onfileuploaded={handleUploadFinished} 
            onpicklistchanged={handlePickListChanged}
            onvalueselect={handleSelection}
            onlookup={handleLookup}
            hide-checkbox-column>
    </c-lwc-data-table>
</p>

```

The above component contains lookup, picklist, file upload and an image component inside the datatable.

In order to use this component inside your org you will be needing custom lookup component which you can get from below link

- [Custom Lookup](https://github.com/amitastreait/Salesforce-Short-Hands/tree/master/sfdxsrc/customLookup)

## Prepare Column for Lookup Component

```
{
    label: 'Parent', fieldName: 'ParentId', type: 'lookup', typeAttributes: {
        object: "Account", // Parent Object Name
        icon: "standard:account", // the icon to display
        label: "Account", // Label to Display
        placeholder: 'Select Parent Account',
        fields: ["Name", "Rating", "AccountNumber"], // Fields to Query
        displayFields : 'Name, Rating, AccountNumber', // Fields to Display on the dropdown
        valueId: { fieldName: 'ParentId' }, // send the field API name which contains the value of Parent Id if value is not null
        valueName : { fieldName: 'PARENT_NAME' }, // send the field API name which contains the value of Parent record name if value is not null
        currentRecordId : { fieldName: 'Id' }, // Send the field API name which contains the record Id for current row
    }
}
```

## Prepare PickList Column

```
{
    label: 'Rating', type: 'picklist', fieldName: 'Rating', sortable: true, typeAttributes: {
        label : 'Choose Rating',
        placeholder: 'Choose rating', 
        options: [
            { label: 'Hot', value: 'Hot' },
            { label: 'Warm', value: 'Warm' },
            { label: 'Cold', value: 'Cold' },
        ],
        parentrecord: { fieldName: 'Id' } // Send the field API name which contains the record Id for current row
    }
}
```

## Prepare Column for File Upload

```
{ 
    label: 'Upload Document', type: 'fileUpload', fieldName: 'Id', 
    typeAttributes : {
        acceptedFormats : '.jpg,.jpeg,.pdf,.png',
        doUpload : {
            fieldName   : 'UPLOAD_FILE'
        }
    } 
}
```

## Prepare Column for Image

```
{ 
    label: 'ICON', type: 'image', fieldName: 'IMAGE_URL', 
    typeAttributes : {
        alttxt : 'Account Image',
        width  : 50,
        height : 50
    } 
}
```

## Complete Demo

To see the complete demo install the code into your salesforce ORG and then drag & drop Extended DataTable component into home page

output
![DataTable](https://github.com/amitastreait/Salesforce-Short-Hands/blob/master/images/datatable.PNG)

## Contribute to the Utilities
If you wanted to contribute to the utilities then please follow the steps from below link
- [Contribute to the Utilities](https://github.com/amitastreait/Salesforce-Short-Hands)

## Share feedback
Please do share the feedback