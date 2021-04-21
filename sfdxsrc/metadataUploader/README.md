# Custom Metadata Uploader

This subrepo helps you to import the custom metadata using 
- Lightning Web Component
- VisualForce page
- Lightning Flow.

## Prepare .csv file

To prepare the .csv file you need to keep the below things in your mind.

- First Coulmn will always represent the Label for the Custom Metadata
- All the Headers for the `.csv` file will be the Exact API name of the Fields that are associated with the Custom Metadata
- All Date Fields will be having the format `yyyy-mm-dd`
- All DateTime Fields will be having the format `yyyy-mm-dd hh:mm:ss`
- All Checkbox Fields will be having the value either `TRUE` or `FALSE`. No 0 or 1

Below is the example screenshot for the .csv file

![Metadata Uploader CSV File](https://github.com/amitastreait/Salesforce-Short-Hands/blob/master/images/csv.PNG)

### Import using Lightning Web Component
To use the Lightning Web Component you can drag & drop `Custom Metata Uploader` component to the home page and then you can select your metadata, browse the `.csv` and then click on upload button.

Here is the sample screenshot

![Metadata Uploader LWC File](https://github.com/amitastreait/Salesforce-Short-Hands/blob/master/images/lwcfile.PNG)

### Import using VisualForce Page
To use the Visualforce Page, you can use `metadataUploader` VF Page page and then you can select your metadata, browse the `.csv` and then click on upload button.

Here is the sample screenshot

![Metadata Uploader VF File](https://github.com/amitastreait/Salesforce-Short-Hands/blob/master/images/vffile.PNG)

### Import using Lighting Flow

To use the Lightning Flow you need to use `Custom Metata Uploader` component inside your Lightning Flow builder and the rest process is same as above 2 approaches.


## OutPut

![Metadata Uploader](https://github.com/amitastreait/Salesforce-Short-Hands/blob/master/images/result.PNG)

## Contribute to the Utilities
If you wanted to contribute to the utilities then please follow the steps from below link
- [Contribute to the Utilities](https://github.com/amitastreait/Salesforce-Short-Hands)

## Share feedback
Please do share the feedback