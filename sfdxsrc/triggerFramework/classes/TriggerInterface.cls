/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 12-06-2020
 * @last modified by  : Amit Singh
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   12-06-2020   Amit Singh   Initial Version
**/
public Interface TriggerInterface {
    List<sObject> filterRecords(TriggerContext tc);
    void execute(List<sObject> records, TriggerContext tc);
}