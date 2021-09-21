/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 09-21-2021
 * @last modified by  : Amit Singh
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   12-20-2020   Amit Singh   Initial Version
**/
public with sharing class CustomMetadataUploader implements Metadata.DeployCallback {

    public static String mockedString;
    public static String objectApiName;
    private static final String DUMMY_ID = Test.getStandardPricebookId();

    @TestVisible
    private static MetadataDeploymentResult__e[] eventsToPublish = new MetadataDeploymentResult__e[]{};

    @AuraEnabled(cacheable=true)
    public static List<String> getItems(){

        List<String> options = new List<String>();

        for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values()){
            Schema.DescribeSObjectResult objectDef = objTyp.getDescribe();
            String name = objectDef.getName();
            if( ( objectDef.isCreateable() || objectDef.isUpdateable()  ) && objectDef.isAccessible() ){
                prepareOptions(options, name, objectDef);
            }
        }
        return options;
    }

    private static void prepareOptions(List<String> options, String name, Schema.DescribeSObjectResult objectDef){
        if(!name.containsignorecase('history') && !name.containsignorecase('tag') &&
            !name.containsignorecase('share') && !name.containsignorecase('feed') && !name.containsignorecase('attachment') &&
            !name.containsignorecase('changeevent') && !name.containsignorecase('apex') ) {
            if( name.toLowerCase().endsWith('__mdt') || name.toLowerCase().endsWith('__c') ){
                options.add( name );
            }else if( objectDef.getRecordTypeInfos().size() > 0 ){
                options.add( name );
            }
        }
    }
    
    @AuraEnabled
    public static Metadata.DeployContainer uploadFile(String base64Data, String metadataName){

        Map<String, String> fieldTypeMap = fieldsMap(metadataName);

        List<String> csvFileLines = new List<String>();
        String csvAsString = mockedString;
        if(!Test.isRunningTest()){
            csvAsString = System.JSON.deserializeUntyped(base64Data).toString();
        }
        csvFileLines = csvAsString.split('\n');

        List<String> csvRows = csvFileLines;
        List<String> fieldsList = csvRows[0].split(',');
        csvRows.remove(0); 
        objectApiName = metadataName;
        
        if(metadataName.endsWith('__mdt')){
            createCustomMetadataCSVRecords(csvRows, fieldsList, fieldTypeMap );
        }else {
            createUpdateObjectRecords(csvRows, fieldsList, fieldTypeMap);
        }
        return null;
    }

    public static void createCustomMetadataCSVRecords(List<String> csvRows, List<String> fieldsList, Map<String, String> fieldTypeMap) {

        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();

        for(String row : csvRows) {
            Map<String, Object> fieldToValueMap = new Map<String, Object>();
            List<String> fieldInputValues = row.split(',');
            for (Integer i = 1; i < fieldsList.size(); i++) {
                String value = fieldInputValues.get(i).trim();
                Object finalValue = value ;
                if(value == 'TRUE'){
                    finalValue = true;
                }else if(value == 'FALSE'){
                    finalValue = false;
                }

                String fieldApiName = fieldsList[i].trim();
                if( fieldTypeMap.containsKey( fieldApiName.toLowerCase() ) ){
                    finalValue = popupateValues( fieldTypeMap.get( fieldApiName.toLowerCase() ), value );
                }
                fieldToValueMap.put( fieldApiName ,  finalValue );

            }
            
            String fullName = objectApiName+'.'+fieldInputValues.get(0).replace(' ', '_');
            String label = fieldInputValues.get(0).replace('_', ' ');

            Metadata.CustomMetadata customMetadata = prepareCustomMetadataRecord(fullName, label, fieldToValueMap );
            mdContainer.addMetadata(customMetadata);
        }
        deployCustomMetadataRecord( mdContainer );
    }

    public static void createUpdateObjectRecords(List<String> csvRows, List<String> fieldsList, Map<String, String> fieldTypeMap){
        List<sObject> sObjects = new List<sObject>();
        for(String row : csvRows) {
            Map<String, Object> fieldToValueMap = new Map<String, Object>();
            List<String> fieldInputValues = row.split(',');
            sObject sObjectRecord = Schema.getGlobalDescribe().get(objectApiName).newSObject();
            for (Integer i = 1; i < fieldsList.size(); i++) {
                String value = fieldInputValues.get(i).trim();
                Object finalValue = value ;
                if(value == 'TRUE'){
                    finalValue = true;
                }else if(value == 'FALSE'){
                    finalValue = false;
                }
                String fieldApiName = fieldsList[i].trim();
                if( fieldTypeMap.containsKey( fieldApiName.toLowerCase() ) ){
                    finalValue = popupateValues( fieldTypeMap.get( fieldApiName.toLowerCase() ), value );
                }
                fieldToValueMap.put( fieldApiName ,  finalValue );
                sObjectRecord.put(fieldApiName, finalValue);
            }
            sObjects.add(sObjectRecord);
        }
        upsertRecords(sObjects);
    }

    private static void upsertRecords(List<SObject> sObjects){
        SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.CREATABLE, sObjects);

        if(securityDecision.getRemovedFields().size() > 0){
            throw new FieldAccessException('You do not have access to below fields \n '+securityDecision.getRemovedFields());
        }
        List<Database.UpsertResult> upsertResults = Database.upsert(securityDecision.getRecords(), false);
        Boolean success = true;
        String errorMessage = 'Success';
        String errorCode = '200';
        for(Database.UpsertResult upsertResult : upsertResults){
            if(!upsertResult.isSuccess()){
                success = false;
                errorMessage += '\n '+upsertResult.getErrors().get(0).getMessage();
                errorCode = '500';
            }
        }
        String response = success ? '{ "componentSuccess" : "'+errorMessage +'" }' : '{ "componentFailures" : "'+errorMessage +'" }';
        MetadataDeploymentResult__e deployResultEvent = new MetadataDeploymentResult__e(
            JobId__c        = DUMMY_ID,
            Status__c       = errorCode,
            Payload__c      = response,
            ErrorMessage__c = errorMessage
        );
        eventsToPublish.add(deployResultEvent);
        publishEvents(eventsToPublish); 
    }

    public static void deployCustomMetadataRecord(Metadata.DeployContainer mdContainer){
        CustomMetadataUploader callback = new CustomMetadataUploader();
        Id jobId;
        if(!Test.isRunningTest()){
            jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
        }else{
            jobId  = DUMMY_ID;
        }
    }

    public static Metadata.CustomMetadata prepareCustomMetadataRecord(String fullName, String label, Map<String, Object> fieldWithValuesMap){
        
        Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
        customMetadata.fullName = fullName;
        customMetadata.label = label;
        
        for(String key : fieldWithValuesMap.keySet()){
            Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
            customField.field = key;
            customField.value = fieldWithValuesMap.get(key); 
            customMetadata.values.add(customField);
        }
        return customMetadata;
    }

    private static Object popupateValues(String typex, String fieldvalue ){
        Object value;
        switch on typex {
            when 'DATE' {
                value = Date.valueOf( fieldvalue );
            }
            when 'DATETIME' {
                value = Datetime.valueOf( fieldvalue );
            }
        }
        return value;
    }

    public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
        if (result.status == Metadata.DeployStatus.Succeeded) {
            System.debug(' success : '+ result);
        } else {
            System.debug(' fail : '+ result);
        }
        this.publishDeployResult(result);
    }
    
    public void publishDeployResult(Metadata.DeployResult result) {
        
        MetadataDeploymentResult__e deployResultEvent = new MetadataDeploymentResult__e(
            JobId__c        = result.id,
            Status__c       = String.valueOf(result.status).toLowerCase(),
            Payload__c      = JSON.serialize(result.details),
            ErrorMessage__c = result.errorMessage
        );
        eventsToPublish.add(deployResultEvent);
        publishEvents(eventsToPublish);
    }

    private static void publishEvents(List<MetadataDeploymentResult__e> eventsToPublish) {
        List<Database.SaveResult> results = EventBus.publish(eventsToPublish);
        Database.SaveResult sr = results[0];
        if(!sr.isSuccess()) {
            String error = 'Error firing MetadataDeploymentResult__e event.\n' + JSON.serialize(sr.getErrors());
            System.debug(error);
            throw createCustomException(error);
        }
    }

    public static Map<String, String> fieldsMap(String objectApiName){

        Map <String,Schema.SObjectType> globalDescribe      = Schema.getGlobalDescribe();
        Schema.SObjectType sobjType                         = globalDescribe.get(objectApiName);
        Schema.DescribeSObjectResult describeSobjectResult  = sobjType.getDescribe();
        Map<String, Schema.SObjectField> fieldsMap          = describeSobjectResult.fields.getMap();

        Map<String, String> fieldTypeMap = new Map<String, String>();

        for(String fieldName : fieldsMap.keySet()) {
            Schema.SObjectField field = fieldsMap.get(fieldName);
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            if( fieldDescribe.getType() == Schema.DisplayType.DATE ){
                fieldTypeMap.put( fieldDescribe.getName().toLowerCase() , 'DATE' );
            }else if( fieldDescribe.getType() == Schema.DisplayType.DATETIME ){ 
                fieldTypeMap.put( fieldDescribe.getName().toLowerCase() , 'DATETIME');
            }
        }
        return fieldTypeMap;
    }

    private static CustomException createCustomException(String error) {
        CustomException ex = new CustomException(error);
        ex.setMessage(error);
        return ex;
    }

    private static void createAuraHandledException(String errorMessage){
        throw new AuraHandledException(errorMessage);
    }

    public class CustomException extends Exception {}

    public class FieldAccessException extends Exception {}

}