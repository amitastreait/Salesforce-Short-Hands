/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 05-12-2024
 * @last modified by  : Wasef Mohiuddin
**/
public with sharing class SearchController {
    @AuraEnabled
    public static List<sObject> search(String objectName, List<String> fields, String searchTerm){
        String searchKeyword = searchTerm + '*';
        String returningQuery = '';
        returningQuery = objectName+' ( Id, '+String.join(fields,',')+')';
        String query = 'FIND :searchKeyword IN ALL FIELDS RETURNING '+returningQuery+' LIMIT 20';
        List<List<sObject>> searchRecords = new List<List<sObject>>();
        List<SObject> sobjList = new List<SObject>();
        if(String.isBlank(searchTerm)){
            String soqlQuery = 'SELECT Id, Name, Type, LastViewedDate FROM RecentlyViewed WHERE Type =\''+objectName+'\' ORDER BY LastViewedDate DESC LIMIT 5';
            sobjList = Database.query( soqlQuery );
            searchRecords.add(sobjList);
        } 
        //Since SOSL has a minimum limit, included this for the first couple characters, as it was giving errors
        else if(searchTerm.length()<3){
            String soqlQuery = 'SELECT Id, '+String.join(fields,',')+' FROM '+objectName+' WHERE Name LIKE \'%'+searchTerm+'%\' LIMIT 5';
            sobjList = Database.query( soqlQuery );
            searchRecords.add(sobjList);
        }
        else{
            searchRecords = Search.Query(Query);
        }
        return searchRecords.get(0);
    }

    @AuraEnabled
    public static sObject getRecentlyCreatedRecord(String recordId, List<String> fields, String objectName){
        sObject createdRecord;
        try {
            String query = 'SELECT Id, '+String.join(fields,',')+' FROM '+objectName+' WHERE Id = \''+recordId+'\'';
            List<SObject> sobjList = Database.query( query );
            createdRecord = sobjList.get(0);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return createdRecord;
    }
}
