@IsTest
public class SystemEventHandlerUnitTest {

    @IsTest
    public static void logSystemEventTest(){
        Test.startTest();
        SystemEventHandler.logSystemEvent('Test Message', 'Test Message','Error','Test Class','Apex');
        Test.stopTest();
    }
}