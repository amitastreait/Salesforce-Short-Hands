/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 03-23-2021
 * @last modified by  : Amit Singh
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   03-23-2021   Amit Singh   Initial Version
**/
global without sharing class Logger {

    private String message;
    private String componentName;
    private String eventLevel;
    private String typex;
    
    public  System_Event__c logRecord { get; set; }
    
    @InvocableMethod(label='Log System Event')
    global static List<ErrorLog> convertLeads(List<ErrorLog> requests) {
        ErrorLog request = requests.get(0);
        Logger logObject = new Logger(request.message, request.componentName, request.eventLevel, request.typex);
        logObject.log(UserInfo.getUserId(), request.richTextMessage, request.richTextMessage1, request.richTextMessage2);
        return requests;
    }
    
    global Logger(String message, String componentName, String eventLevel, String typex){
        this.message = message;
        this.componentName = componentName;
        this.eventLevel = eventLevel;
        this.typex = typex;
        logRecord = new System_Event__c();
    }

    global void log(String userId, String richTextMessage, String richTextMessage1, String richTextMessage2){
        prepareEvent(userId, richTextMessage, richTextMessage1, richTextMessage2);
        List<System_Event__c> newLogs = new List<System_Event__c>();
        newLogs.add(logRecord);
        SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.CREATABLE, newLogs );
        insert securityDecision.getRecords();
    }
    
    global void sendLogEmail(String userId, String emailBody, List<String> emails, String subject){
        prepareEvent(userId, emailBody, '', '');
        logRecord.Send_Email__c = true;
        logRecord.Email_Sent_DateTime__c = System.now();
        logRecord.Additional_Email__c = String.join(emails, ':');
        logRecord.Email_Subject__c	= subject;
        List<System_Event__c> newLogs = new List<System_Event__c>();
        newLogs.add(logRecord);
        SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.CREATABLE, newLogs );
        insert securityDecision.getRecords();
        
        sendEmail(emails, subject, emailBody);
    }
    
    private void sendEmail(List<String> toAddresses, String subject, String content){
        Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
        semail.setToAddresses(toAddresses);
        semail.setSubject(subject);
        semail.setHtmlBody(content);
        if( !Test.isRunningTest() ){
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { semail });
        }
        
    }
    private List<String> getPermissionSets(){
        String permSet = '| ';
        String permGroups = '| ';
        for(PermissionSetAssignment perm : [SELECT Id, PermissionSet.Name, PermissionSetGroup.DeveloperName 
                                        FROM PermissionSetAssignment 
                                        WHERE AssigneeId =: UserInfo.getUserId()
                                        WITH SECURITY_ENFORCED ]){
            permSet += perm.PermissionSet.Name+' | ';
            if( null != perm.PermissionSetGroup.DeveloperName ){
                permGroups += perm.PermissionSetGroup.DeveloperName+' | ';
            }
        }
        List<String> groups = new List<String>();
        groups.add(permSet);
        groups.add(permGroups);
        return groups;
    }
    
    private String getGroupMembership(){
        String groups = '| ';
        for(GroupMember gm : [SELECT Id, Group.DeveloperName FROM GroupMember WHERE UserOrGroupId =: UserInfo.getUserId() AND Group.Type = 'Regular' WITH SECURITY_ENFORCED ]){
            if( null != gm.Group.DeveloperName ){
                groups += gm.Group.DeveloperName+' | ';
            }
        }
        return groups;
    }
    private String getQueueMembership(){
        String queues = '| ';
        for(GroupMember gm : [SELECT Id, Group.DeveloperName FROM GroupMember WHERE UserOrGroupId =: UserInfo.getUserId() AND Group.Type = 'Queue' WITH SECURITY_ENFORCED ]){
            if( null != gm.Group.DeveloperName ){
                queues += gm.Group.DeveloperName+' | ';
            }
        }
        return queues;
    }
    
    private System_Event__c prepareLogger(){
        logRecord.Message__c = message;
        logRecord.Component_Name__c = componentName;
        logRecord.Type__c = typex;
        logRecord.Event_Level__c = eventLevel;
        return logRecord;
    }
    
    private System_Event__c prepareEvent(String userId, String richTextMessage, String richTextMessage1, String richTextMessage2){
        prepareLogger();
        logRecord.User__c = userId;
        logRecord.Message_Rich_Text__c = richTextMessage;
        logRecord.Message_Rich_Text_02__c = richTextMessage1;
        logRecord.Message_Rich_Text_03__c = richTextMessage2;
        logRecord.Queue_Membership__c = getQueueMembership();
        logRecord.Public_Group_Membership__c = getGroupMembership();
        
        List<String> permissionSets = getPermissionSets();
        
        logRecord.Permission_Set_Group__c = permissionSets.get(1);
        logRecord.Permission_Set__c		= permissionSets.get(0);
        return logRecord;
    }
    
    global class ErrorLog {
        @InvocableVariable(required=true)
        global String message;
        @InvocableVariable(required=true)
        global String componentName;
        @InvocableVariable(required=true)
        global String eventLevel;
        @InvocableVariable(required=true)
        global String typex;
        
        @InvocableVariable
        global String richTextMessage;
        @InvocableVariable
        global String richTextMessage1;
        @InvocableVariable
        global String richTextMessage2;
    }
}