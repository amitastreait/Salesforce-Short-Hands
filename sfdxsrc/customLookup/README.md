# Custom Lookup LWC Component
This repo contains the reusable Custom Lookup using Lightning Web Component and we will use SOSL to develop the Lightning Web Component

## Usage
Below is the code how you can use this component inside your parent component.
```
<c-search-component
                obj-name={typeAttributes.object}
                icon-name={typeAttributes.icon}
                label-name={typeAttributes.label}
                placeholder={typeAttributes.placeholder} 
                fields={typeAttributes.fields}
                display-fields={typeAttributes.displayFields}
                value-id={typeAttributes.valueId}
                value-name={typeAttributes.valueName}
                onlookup={handleLookup}
                current-record-id={typeAttributes.currentRecordId} >
</c-search-component>

```

## Code Explanation
- valueId;  - This field holds the Selected Record Id if the parent record is already there
- valueName; - This field holds the Selected Record Name if the parent record is already there 
- objName= 'Account';  - The Parent Object API Name
- iconName= 'standard:account';  - The Icon which you wanted to display
- labelName;  - The Label for the Search
- currentRecordId;  - The child record Id if applicable
- placeholder= 'Search';  - Search Place holder
- fields= ['Name'];  - The Fields that You wanted to Query
- displayFields= 'Name, Rating, AccountNumber'; - The Fields that You wanted to use in the Lookup
- onlookup - the custom event which holds the selected record, SelectedRecordId & the child recorded if applicable

## Handle Select Event
To hande and get the Information about the selected record use the below line for the onlookup method
```
handleLookup(event){
    console.log( JSON.stringify ( event.detail) )
}
```

![Lookup Component](https://github.com/amitastreait/Salesforce-Short-Hands/blob/master/images/lookup.png)

## Contribute to the Utilities
If you wanted to contribute to the utilities then please follow the steps from below link
- [Contribute to the Utilities](https://github.com/amitastreait/Salesforce-Short-Hands)

## Share feedback
Please do share the feedback