/*
* This is the helper class for GenericDataTableController contains the variables and wrapper.
*/

public with sharing class GenericDataTableControllerHelper {
    @TestVisible static private Map<String,List<sObject>> customMetadataRecordsMap = new Map<String,List<sObject>>();    
    public static final String DATA_TABLE_QUERY_FIELDS = 'Object_API_Name__c, Show_Pagination__c, Default_Fields__c, Default_Page_Size__c, Sort_By__c, Sort_Direction__c, Show_Search__c, Show_Paging_Picklist__c, Paging_Picklist_Values__c, Table_Key_Field_API_Name__c';
    public static final String CHILD_QUERY_FIELDS = 'MasterLabel, DataType__c, Field_API_Name__c, Sequence__c,URL_Label_Field_API_Name__c, URL_Target_Field_API_Name__c';
    public static final String PARENT_METADATA_API_NAME = 'Data_Table__mdt';
    public static final String CHILD_RELATIONSHIP_NAME = 'Data_Table_Contents__r';
    
    /*
    * This Helper method is use to get all Parent & Child metadata using the given metadata name.
    */
    public InitializeWrapper initialize(String metaQuery, String metaName){        
        InitializeWrapper initValue = new InitializeWrapper();
        string query = metaQuery+' WHERE DeveloperName =: metaName LIMIT 1';
        initValue.metadataRecords.addAll((List<Data_Table__mdt>)getCustomMetadataRecords(query,metaName));
        if(!initValue.metadataRecords.isEmpty()){
            if(String.isNotEmpty(initValue.metadataRecords[0].Default_Fields__c)){
                initValue.dataParse.fieldToQuery.addAll(initValue.metadataRecords[0].Default_Fields__c.split(','));
            }
            if(!initValue.metadataRecords[0].Data_Table_Contents__r.isEmpty()){
                initValue.cols.addAll(initValue.metadataRecords[0].Data_Table_Contents__r);
            }
        }
        return initValue;
    }
    
    /*
    * This method is use for populate the check variables.
    */
    public DataParserWrapper dataParser(List<Data_Table_Content__mdt>cols){
        DataParserWrapper parsedData = new DataParserWrapper();
        if(!cols.isEmpty()){
            for(Data_Table_Content__mdt col : cols){
                if(col.DataType__c == 'date-local'){
                    parsedData.dateIdentifier.add(col.Field_API_Name__c);
                    parsedData.fieldToQuery.add(col.Field_API_Name__c);
                    parsedData.sortMapInner.put(col.Field_API_Name__c, col.Field_API_Name__c);                    
                }else if(col.DataType__c == 'url'){
                    String dummyValue = arrangeDummies(col.URL_Target_Field_API_Name__c, false);
                    String dummyLabel = arrangeDummies(col.URL_Label_Field_API_Name__c, true);
                    parsedData.fieldToQuery.add(col.URL_Target_Field_API_Name__c);
                    parsedData.fieldToQuery.add(col.URL_Label_Field_API_Name__c);
                    parsedData.actualToDummyHyperLink.put(col.URL_Target_Field_API_Name__c, dummyValue);
                    parsedData.actualToDummyHyperLink.put(col.URL_Label_Field_API_Name__c, dummyLabel);
                    parsedData.urlIdentifier.add(dummyValue);
                    parsedData.sortMapInner.put(dummyValue, dummyLabel);
                }else{
                    parsedData.fieldToQuery.add(col.Field_API_Name__c);
                    parsedData.sortMapInner.put(col.Field_API_Name__c, col.Field_API_Name__c);
                }
            }
        }
        return parsedData;
    }
    
    /*
    This method is use to handle hyperlink for table.
    */
    public static String arrangeDummies(String valueToChange, Boolean isLabel){
        String changedVal;
        if(valueToChange.contains('.')){
            changedVal = valueToChange.substringBefore('.');
        }else{
            changedVal = valueToChange.contains('__c') ? valueToChange.substringBefore('__c') : valueToChange;
        }
        return changedVal +'_'+ (isLabel ? 'LABEL' : 'VALUE');
    }
    
    /*
    * This method is use to fetch metadata records.
    */
    private List<sObject> getCustomMetadataRecords(String query, String metaName){//NOSONAR
        if(!customMetadataRecordsMap.containsKey(query)){
            customMetadataRecordsMap.put(query,Database.query(String.escapeSingleQuotes(query)));
        }
        return customMetadataRecordsMap.get(query);
    }
    
    public class InitializeWrapper{
        public List<Data_Table__mdt> metadataRecords;
        public List<Data_Table_Content__mdt> cols;
        public DataParserWrapper dataParse;
        public InitializeWrapper(){
            this.metadataRecords = new List<Data_Table__mdt>();
            this.cols = new List<Data_Table_Content__mdt>();
            this.dataParse = new DataParserWrapper();
        }
    }
    
    public class DataParserWrapper{
        public Set<String> fieldToQuery;
        public Map<String,String> actualToDummyHyperLink;
        public Map<String,String> sortMapInner;
        public Set<String> urlIdentifier;
        public Set<String> dateIdentifier;
        
        public DataParserWrapper(){
            this.fieldToQuery = new Set<String>();
            this.actualToDummyHyperLink = new Map<String,String>();
            this.sortMapInner = new Map<String,String>();
            this.urlIdentifier = new Set<String>();
            this.dateIdentifier = new Set<String>();
        }
    }
}