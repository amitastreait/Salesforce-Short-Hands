/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 12-14-2020
 * @last modified by  : Amit Singh
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   12-06-2020   Amit Singh   Initial Version
**/
public with sharing class TriggerDispatcher {
    
    public static void run(String objectName){
        
        // Get All the Handler Setting for that Object
        List<Trigger_Handler__mdt> triggerEnablerList = getTriggerHandler(objectName);
        
        // Iterate Over the Handler Class based on the increasing Order and Execute the Trigger Handlers
        for(Trigger_Handler__mdt triggerEnabler : triggerEnablerList){
            // Check if the Handler is Active for the Operation or not
            if( (Boolean)triggerEnabler.get('Is_'+Trigger.operationType + '__c') ){
                processRecord( triggerEnabler.HandlerClassName__c );
            }
        }
    }
    
    private static void processRecord(String HandlerClassName){
        Type handlerType = Type.forName(HandlerClassName);
        TriggerInterface handler = (TriggerInterface)handlerType.newInstance();
        TriggerContext tc 		 = prepareContext();
        filterRecords(handler, tc);
    }
    
    private static void filterRecords(TriggerInterface handler, TriggerContext tc){
        List<sObject> filteredRecords = new List<sObject>();
        filteredRecords = (List<sObject>)handler.filterRecords(tc);
        System.debug(' filteredRecords \n '+ filteredRecords);
        // Call the execute method which will call the execute method of the Actual Handler Class
        execute(filteredRecords, handler, tc);
    }
    
    private static void execute(List<sObject> filteredRecords, TriggerInterface handler, TriggerContext tc){
        
        if(!filteredRecords.isEmpty()){
            handler.execute(filteredRecords, tc);
        }
        
    }

    private static List<Trigger_Handler__mdt> getTriggerHandler(String objectName){
        
        List<Trigger_Handler__mdt> triggerEnablerList = [SELECT Id, DeveloperName, Is_After_Delete__c, Is_After_Insert__c, Is_After_Undelete__c, Is_After_Update__c, Is_Before_Delete__c, 
                                                        		Is_Before_Insert__c, Is_Before_Update__c, Label, MasterLabel, HandlerClassName__c, Execution_Order__c, isActive__c
                                                        FROM Trigger_Handler__mdt 
                                                        WHERE ObjectName__r.QualifiedApiName =: objectName
                                                        AND isActive__c = TRUE
                                                        ORDER BY Execution_Order__c ASC];
        return triggerEnablerList;
        
    }
    
    private static TriggerContext prepareContext(){
        
        TriggerContext tc = new TriggerContext(
            Trigger.new, Trigger.Old, Trigger.newMap, Trigger.oldMap, Trigger.isExecuting,
            Trigger.isBefore && Trigger.isInsert, Trigger.isBefore && Trigger.isUpdate, Trigger.isBefore && Trigger.isDelete,
            Trigger.isAfter && Trigger.isInsert, Trigger.isAfter && Trigger.isUpdate, Trigger.isAfter && Trigger.isDelete,
            Trigger.isAfter && Trigger.isUnDelete
        );
        return tc;
        
    }

}