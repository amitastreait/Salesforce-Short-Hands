@IsTest
private class LoggerUnitTest {
    
    @TestSetup
    private static void setupData(){
        Group emeaQueue = new Group(Name='EMEA Queue', type='Queue');
        Group test = new Group();
        test.Name = 'Test Group';
        insert test;
        insert emeaQueue;
        QueuesObject emeaQueueLead = new QueueSObject(QueueID = emeaQueue.id, SobjectType = 'Lead');
        insert emeaQueueLead;
        System.runAs( new User( Id = UserInfo.getUserId() ) ) {
            List<GroupMember> groupMembers = new List<GroupMember>();
            GroupMember gm = new GroupMember(UserOrGroupId = UserInfo.getUserId(), GroupId = test.Id );
            GroupMember gm1 = new GroupMember(UserOrGroupId = UserInfo.getUserId(), GroupId = emeaQueue.Id );
            insert new List<GroupMember>{gm, gm1};
        }
    }
    
	@IsTest
    private static void logTest(){
        Logger log = new Logger('Hello Dynamic Test', 'Anynomous Code', 'Success', 'Apex');
        log.logRecord.Message_x4__c = '<b> this is test record </b>';
        log.logRecord.Message_x5__c = '<b> this is test record </b>';
        System.runAs( new User( Id = UserInfo.getUserId() ) ) {
            Test.startTest();
            log.log( UserInfo.getUserId(), '<p>Hello this is amit</p>', '<p>Hello this is amit</p>', '<p>Hello this is amit</p>' );
            Test.stopTest();
        }
        
        List<System_Event__c> logs = [SELECT Id, Name FROM System_Event__c WITH SECURITY_ENFORCED LIMIT 1];
        System.assertEquals(1, logs.size(), 'There should be atleast one Error Log Record');
    }
    
    @IsTest
    private static void sendLogEmailText(){
        Logger log = new Logger('Hello Dynamic Test', 'Anynomous Code', 'Success', 'Apex');
        log.logRecord.Message_x4__c = '<b> this is test record </b>';
        log.logRecord.Message_x5__c = '<b> this is test record </b>';
        System.runAs( new User( Id = UserInfo.getUserId() ) ) {
            Test.startTest();
            log.sendLogEmail( UserInfo.getUserId(), '<p>Hello this is amit</p>',new List<String>{'sfdcpanther@gmail.com'},'Send Email to Admin'  );
            Test.stopTest();
        }
        
        List<System_Event__c> logs = [SELECT Id, Name FROM System_Event__c WITH SECURITY_ENFORCED LIMIT 1];
        System.assertEquals(1, logs.size(), 'There should be atleast one Error Log Record');
    }
    
}