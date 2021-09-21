/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 09-21-2021
 * @last modified by  : Amit Singh
**/
@Istest
private with sharing class CustomMetadataUploaderTest {

    @IsTest
    private static void getItemsTest(){
        Test.startTest();
        CustomerMetadataUploaderController controller = new CustomerMetadataUploaderController();
        controller.getItems();
        CustomMetadataUploader.getItems();
        Test.stopTest();
    }

    @IsTest
    private static void testFileUpload(){
        StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = 'data_csv' LIMIT 1];
        String body = sr.Body.toString();
        Test.startTest();
        CustomMetadataUploader.mockedString = body;
        CustomMetadataUploader.uploadFile(body,'Countries__mdt');
        Test.stopTest();
    }

	@IsTest
    private static void testFileUploadForObject(){
        StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = 'account_data' LIMIT 1];
        String body = sr.Body.toString();
        Test.startTest();
        CustomMetadataUploader.mockedString = body;
        CustomMetadataUploader.uploadFile(body,'Account');
        Test.stopTest();
    }

    @IsTest
    private static void publishDeployEvent(){
        Test.startTest();
        Metadata.DeployResult result = (Metadata.DeployResult)System.JSON.deserialize(getDeployResult(), Metadata.DeployResult.class);
        CustomMetadataUploader controller =  new CustomMetadataUploader();
        controller.publishDeployResult(result);
        Test.stopTest();
    }

    @IsTest
    private static void importCSVFileTest(){
        
        Test.startTest();
        CustomerMetadataUploaderController controller = new CustomerMetadataUploaderController();
        controller.metadataName = '--Select One--';
        controller.importCSVFile();
        Test.stopTest();
        
    }

    @IsTest
    private static void importCSVFileTest1(){
        
        Test.startTest();
        CustomerMetadataUploaderController controller = new CustomerMetadataUploaderController();
        controller.csvFileBody = null;
        controller.importCSVFile();
        Test.stopTest();
        
    }

    @IsTest
    private static void importCSVFileTestMain(){

        StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = 'data_csv' LIMIT 1];
        Blob body = sr.Body;
        Test.startTest();
        CustomerMetadataUploaderController controller = new CustomerMetadataUploaderController();
        controller.csvFileBody = body;
        controller.metadataName = 'Countries__mdt';
        controller.importCSVFile();
        Test.stopTest();
        
    }

	@IsTest
    private static void importCSVFileForObject(){

        StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = 'account_data' LIMIT 1];
        Blob body = sr.Body;
        Test.startTest();
        CustomerMetadataUploaderController controller = new CustomerMetadataUploaderController();
        controller.csvFileBody = body;
        controller.metadataName = 'Account';
        controller.importCSVFile();
        Test.stopTest();
        
    }

    private static String getDeployResult(){
        return '{'+
		'  "success": true,'+
		'  "status": "Succeeded",'+
		'  "stateDetail": null,'+
		'  "startDate": "2021-04-21T10:22:32.000Z",'+
		'  "rollbackOnError": true,'+
		'  "numberComponentsTotal": 3,'+
		'  "numberComponentsDeployed": 3,'+
		'  "numberComponentErrors": 0,'+
		'  "lastModifiedDate": "2021-04-21T10:22:32.000Z",'+
		'  "ignoreWarnings": false,'+
		'  "id": "0Af4x00000HjXKoCAN",'+
		'  "errorStatusCode": null,'+
		'  "errorMessage": null,'+
		'  "done": true,'+
		'  "details": {'+
		'    "componentSuccesses": ['+
		'      {'+
		'        "success": true,'+
		'        "problemType": null,'+
		'        "problem": null,'+
		'        "lineNumber": null,'+
		'        "id": "m034x000000uVKaAAM",'+
		'        "fullName": "Countries__mdt.India",'+
		'        "fileName": "customMetadata/Countries__mdt.India.md",'+
		'        "deleted": false,'+
		'        "createdDate": "2021-04-21T10:22:32.208Z",'+
		'        "created": false,'+
		'        "componentType": "CustomMetadata",'+
		'        "columnNumber": null,'+
		'        "changed": true'+
		'      },'+
		'      {'+
		'        "success": true,'+
		'        "problemType": null,'+
		'        "problem": null,'+
		'        "lineNumber": null,'+
		'        "id": "m034x000000uVKbAAM",'+
		'        "fullName": "Countries__mdt.United_Kingdom",'+
		'        "fileName": "customMetadata/Countries__mdt.United_Kingdom.md",'+
		'        "deleted": false,'+
		'        "createdDate": "2021-04-21T10:22:32.213Z",'+
		'        "created": false,'+
		'        "componentType": "CustomMetadata",'+
		'        "columnNumber": null,'+
		'        "changed": true'+
		'      },'+
		'      {'+
		'        "success": true,'+
		'        "problemType": null,'+
		'        "problem": null,'+
		'        "lineNumber": null,'+
		'        "id": "m034x000000uVKcAAM",'+
		'        "fullName": "Countries__mdt.United_States",'+
		'        "fileName": "customMetadata/Countries__mdt.United_States.md",'+
		'        "deleted": false,'+
		'        "createdDate": "2021-04-21T10:22:32.213Z",'+
		'        "created": false,'+
		'        "componentType": "CustomMetadata",'+
		'        "columnNumber": null,'+
		'        "changed": true'+
		'      },'+
		'      {'+
		'        "success": true,'+
		'        "problemType": null,'+
		'        "problem": null,'+
		'        "lineNumber": null,'+
		'        "id": null,'+
		'        "fullName": "package.xml",'+
		'        "fileName": "package.xml",'+
		'        "deleted": false,'+
		'        "createdDate": "2021-04-21T10:22:32.219Z",'+
		'        "created": false,'+
		'        "componentType": null,'+
		'        "columnNumber": null,'+
		'        "changed": true'+
		'      }'+
		'    ],'+
		'    "componentFailures": []'+
		'  },'+
		'  "createdDate": "2021-04-21T10:22:31.000Z",'+
		'  "createdByName": "amitsingh@utils.com.dev",'+
		'  "createdBy": "0054x000000gcR7",'+
		'  "completedDate": "2021-04-21T10:22:32.000Z",'+
		'  "checkOnly": false,'+
		'  "canceledByName": null,'+
		'  "canceledBy": "000000000000000"'+
		'}';
    }
}