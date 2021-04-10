global with sharing class SystemEventHandler {

    global static void logSystemEvent(String message1, String message2, String eventLevel, String componentName, String componentType){
        System_Event__c systemEvent = new System_Event__c(
        	Component_Type__c 		= componentType,
            Component_Name__c 		= componentName,
            Event_Level__c  		= eventLevel,
            Message_Rich_Text__c    = message1,
            Message_Rich_Text_02__c = message2,
            Event_DateTime__c		= System.now()
        );
        insert systemEvent;
    }
}