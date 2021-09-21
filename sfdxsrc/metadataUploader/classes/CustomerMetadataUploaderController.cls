/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 09-21-2021
 * @last modified by  : Amit Singh
**/
public with sharing class CustomerMetadataUploaderController {

    public Blob csvFileBody             { get; set; }
    public string csvAsString           { get; set; }
    public string metadataName          { get; set; }
    public List<String> csvFileLines    { get; set; }

    public CustomerMetadataUploaderController() {
        csvFileLines = new List<String>();
        metadataName = '';
    }

    public List<SelectOption> getItems(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption( '--Select One--' , '--Select One--' ) );
        for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values()){
            Schema.DescribeSObjectResult objectDef = objTyp.getDescribe();
            String name = objectDef.getName();
            System.debug(' name '+ name );
            if( name.toLowerCase().contains('__mdt') ){
                options.add(new SelectOption( name , name ) );
            }
        }
        return options;
    }

    public void importCSVFile(){

        if( metadataName.equals('--Select One--')){
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'Please Select the Custom Metadata Type to Import!');
            ApexPages.addMessage(errorMessage);
            return;
        }
        if( null == csvFileBody ){
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'Please Select the CSV file to import');
            ApexPages.addMessage(errorMessage);
            return;
        }
        try{

            Map<String, String> fieldTypeMap = CustomMetadataUploader.fieldsMap(metadataName);

            csvAsString = csvFileBody.toString();
            csvFileLines = csvAsString.split('\n');

            List<String> csvRows = csvFileLines;
            List<String> fieldsList = csvRows[0].split(',');
            csvRows.remove(0); //Remove the header row containing field names
            CustomMetadataUploader.objectApiName = metadataName;
            CustomMetadataUploader.createCustomMetadataCSVRecords( csvRows, fieldsList, fieldTypeMap );

        }catch (Exception e){
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured while importin data Please make sure input csv file is correct');
            ApexPages.addMessage(errorMessage);
        }  
    }

    // public static void createCustomMetadataRecords(String metadataAPIName, List<String> csvRows, List<String> fieldsList, Map<String, String> fieldTypeMap) {

    //     Metadata.DeployContainer deploymentContainer = new Metadata.DeployContainer();

    //     for(String row : csvRows) {
    //         Map<String, Object> fieldToValueMap = new Map<String, Object>();
    //         List<String> fieldInputValues = row.split(',');
    //         for (Integer i = 1; i < fieldsList.size(); i++) {
    //             String value = fieldInputValues.get(i).trim();
    //             Object finalValue = value ;
    //             if(value == 'TRUE'){
    //                 finalValue = true;
    //             }else if(value == 'FALSE'){
    //                 finalValue = false;
    //             }

    //             String fieldApiName = fieldsList[i].trim();
    //             if( fieldTypeMap.containsKey( fieldApiName.toLowerCase() ) ){
    //                 finalValue = popupateValues( fieldTypeMap.get( fieldApiName.toLowerCase() ), value );
    //             }
    //             fieldToValueMap.put( fieldApiName ,  finalValue );

    //         }
    //         String fullName = metadataAPIName+'.'+fieldInputValues.get(0).replace(' ', '_');
    //         String label = fieldInputValues.get(0).replace('_', ' ');

    //         Metadata.CustomMetadata customMetadata = prepareCustomMetadataRecord(fullName, label, fieldToValueMap );
    //         deploymentContainer.addMetadata(customMetadata);
    //     }
    //     deployCustomMetadataRecord(deploymentContainer);
    // }

    // public static void deployCustomMetadataRecord(Metadata.DeployContainer mdContainer){
    //     CustomerMetadataUploaderController callback = new CustomerMetadataUploaderController();
    //     Id jobId;
    //     if(!Test.isRunningTest()){
    //         jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
    //     }else{
    //         jobId  = 'a0I0o00001MbaBJ'; 
    //     }
    // }

    // public static Metadata.CustomMetadata prepareCustomMetadataRecord(String fullName, String label, Map<String, Object> fieldWithValuesMap){
        
    //     Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
    //     customMetadata.fullName = fullName;
    //     customMetadata.label = label;
        
    //     for(String key : fieldWithValuesMap.keySet()){
    //         Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
    //         customField.field = key;
    //         customField.value = fieldWithValuesMap.get(key); 
    //         customMetadata.values.add(customField);
    //     }
    //     return customMetadata;
    // }

    // private static Object popupateValues(String typex, String fieldvalue ){
    //     Object value;
    //     switch on typex {
    //         when 'DATE' {
    //             value = Date.valueOf( fieldvalue );
    //         }
    //         when 'DATETIME' {
    //             value = Datetime.valueOf( fieldvalue );
    //         }
    //     }
    //     return value;
    // }

    // private static Map<String, String> fieldsMap(String objectApiName){

    //     Map <String,Schema.SObjectType> globalDescribe      = Schema.getGlobalDescribe();
    //     Schema.SObjectType sobjType                         = globalDescribe.get(objectApiName);
    //     Schema.DescribeSObjectResult describeSobjectResult  = sobjType.getDescribe();
    //     Map<String, Schema.SObjectField> fieldsMap          = describeSobjectResult.fields.getMap();

    //     Map<String, String> fieldTypeMap = new Map<String, String>();

    //     for(String fieldName : fieldsMap.keySet()) {
    //         Schema.SObjectField field = fieldsMap.get(fieldName);
    //         Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
    //         if( fieldDescribe.getType() == Schema.DisplayType.DATE ){
    //             fieldTypeMap.put( fieldDescribe.getName().toLowerCase() , 'DATE' );
    //         }else if( fieldDescribe.getType() == Schema.DisplayType.DATETIME ){ 
    //             fieldTypeMap.put( fieldDescribe.getName().toLowerCase() , 'DATETIME');
    //         }
    //     }
    //     return fieldTypeMap;
    // }

    // @TestVisible
    // private static MetadataDeploymentResult__e[] eventsToPublish = new MetadataDeploymentResult__e[]{};

    // public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
    //     this.publishDeployResult(result);
    // }
    
    // public void publishDeployResult(Metadata.DeployResult result) {
        
    //     MetadataDeploymentResult__e deployResultEvent = new MetadataDeploymentResult__e(
    //         JobId__c        = result.id,
    //         Status__c       = String.valueOf(result.status).toLowerCase(),
    //         Payload__c      = JSON.serialize(result.details),
    //         ErrorMessage__c = result.errorMessage
    //     );
    //     eventsToPublish.add(deployResultEvent);

    //     List<Database.SaveResult> results = EventBus.publish(eventsToPublish);

    //     Database.SaveResult sr = results[0];
    //     if(!sr.isSuccess()) {
    //         String error = 'Error firing MetadataDeploymentResult__e event.\n' + JSON.serialize(sr.getErrors());
    //         System.debug(error);
    //         throw createCustomException(error);
    //     }

    // }

    // private static CustomException createCustomException(String error) {
    //     CustomException ex = new CustomException(error);
    //     ex.setMessage(error);
    //     return ex;
    // }

    // public class CustomException extends Exception {}
}