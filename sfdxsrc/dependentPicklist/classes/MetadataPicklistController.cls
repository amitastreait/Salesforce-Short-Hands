
public class MetadataPicklistController {

    public Blob csvFileBody             { get; set; }
    public String csvFileName           { get; set; }
    
    public static String objectName     { get; set; }
    public static String dependentPicklistFieldName;
    public static String parentPicklistFieldName;    
    
    /* 
        Prepare the Org to call the Metadata API on the current user permissions 
    */
    public static MetadataService.MetadataPort createService(){
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;
    }
    
    public PageReference updatePicklistField() {       
        MetadataService.MetadataPort service = createService();
        
        Map<String, List<String>> mapDepValContVal = new Map<String, List<String>>();  
        
        if( String.isBlank(objectName) ){
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'Please provide the Object API Name.');
            ApexPages.addMessage(errorMessage);
            return null;
        }

        if( csvFileBody == null ){
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'Please select a file to upload');
            ApexPages.addMessage(errorMessage);
            return null;
        }

        mapDepValContVal = parseCSVFile();
        
        MetadataService.CustomField customField = new MetadataService.CustomField(); 
        customField.fullName = objectName + '.' + dependentPicklistFieldName;        
        customField.label = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(dependentPicklistFieldName).getDescribe().getLabel();
        customField.type_x = 'Picklist';
        
        List<MetadataService.CustomValue> newValues = new List<MetadataService.CustomValue>();
        
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName);
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(dependentPicklistFieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues(); 
        for(Schema.PicklistEntry pickListVal : ple) {
            MetadataService.CustomValue customValue = new MetadataService.CustomValue();
            customValue.fullName = String.valueOf(pickListVal.getValue()); //API name of picklist value
            customValue.label = String.valueOf(pickListVal.getLabel());
            customValue.default_x = false;
            customValue.isActive = true;
            newValues.add( customValue );
        }
        customField.valueSet = new MetadataService.ValueSet();
        MetadataService.ValueSetValuesDefinition vd = new MetadataService.ValueSetValuesDefinition();
        vd.sorted = true;
        vd.value = newValues;
        customField.valueSet.valueSetDefinition = vd;
        
        customField.valueSet.controllingField = parentPicklistFieldName;
        
        list<metadataservice.ValueSettings> valueSettings = new list<metadataservice.ValueSettings>();     
        
        for(String strDepVal : mapDepValContVal.keySet()){
            MetadataService.ValueSettings plValue = new MetadataService.ValueSettings();
            plValue.valueName = strDepVal; // Dependent picklist value
            plValue.controllingFieldValue = mapDepValContVal.get(strDepVal);
            valueSettings.add(plValue);
        }   
        
        customField.valueSet.valueSettings = valueSettings;
        // Update the custom field
        List<MetadataService.SaveResult> lstResults = service.updateMetadata( new MetadataService.Metadata[] { customField });
        
        for(MetadataService.SaveResult result : lstResults) {
            if(result.errors != null) {
                for(MetadataService.Error error : result.errors) {
                    System.debug(error.message);
                    System.debug(error.statusCode);
                }
            }
        }   
        return null;
    }
    
    public Map<String, List<String>> parseCSVFile(){
        
        Map<String, List<String>> depValToContValue = new Map<String, List<String>>();
        try{
            String csvAsString = csvFileBody.toString();
            String[] csvFileLines = csvAsString.split('\n');
            csvFileLines[0].split(',')[0].trim();
            
            String[] csvHeader = csvFileLines[1].split(',');
            parentPicklistFieldName = csvHeader[0].trim();           
            dependentPicklistFieldName = csvHeader[1].trim();
            
            for(Integer i = 2; i < csvFileLines.size(); i++){
                String[] csvRecordData = csvFileLines[i].split(',');
                String dependentValue = csvRecordData[1].trim();
                String controllingValue = csvRecordData[0].trim();
                if(!depValToContValue.containsKey(dependentValue)){
                    depValToContValue.put(dependentValue, new List<String> {controllingValue});
                }else{
                    depValToContValue.get(dependentValue).add(controllingValue);
                }
            }
        }catch (Exception e){
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured while importing data, please make sure input csv file is correct.');
            ApexPages.addMessage(errorMessage);
        }
        return depValToContValue;  
    }
    
}
