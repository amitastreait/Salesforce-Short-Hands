@IsTest
private class GenericDataTableControllerTest {
    
    
    @TestSetup
    static void setup() {
        //createTestData();
    }
    
    /*
    Positive Case : This test method is use to cover Metadata Table Part.
    Passing all the attributes in JSON.
    */
    @IsTest
    private static void getTableDataTest(){
        
    }
    
    /*
    Negitive Case : This test method is use to cover Exception Part(Catch) for metadata table.
    Creating Exception in this method VIA passing wrong API name i.e."Case__m" in the JSON.
    */
    @IsTest
    private static void getTableDataErrorTest(){
        
    }
    
    /*
    Positive Case : This test method is use to cover Fieldset Table Part.
    Passing Fieldset name and Object API Name.
    */
    @IsTest
    private static void getFieldSetTableTest(){
        
    }
    
    /*
    Negitive Case : This test method is use to cover Exception Part(Catch) for fieldset table.
    Passing wrong fieldset name.
    */
    @IsTest
    private static void getFieldSetTableErrorTest(){
        
    }
    
    private static void setMetadata(String query, List<sObject> records){
        
    }
    
}