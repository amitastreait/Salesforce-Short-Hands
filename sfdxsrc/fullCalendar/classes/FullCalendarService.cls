/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 07-11-2020
 * @last modified by  : Amit Singh
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   07-11-2020   Amit Singh   Initial Version
**/
/*
event e = new event();
e.WhatId='0014x0000061xduAAA';
e.Subject ='Test Event';
e.description = 'test Descritpion';
e.StartDateTime=datetime.now().addDays(-2);
e.EndDateTime=datetime.now().addDays(-1);
insert e;
*/
public with sharing class FullCalendarService {

    @AuraEnabled
    public static List<Event> fetchAllEvents(){
        List<Event> eventList = new List<Event>();
        eventList = [Select Id, Subject, WhatId, WhoId, 
                    Description, EndDate, EndDateTime, OwnerId,
                    ActivityDate, ActivityDateTime From Event LIMIT 100];
        return eventList;
    }
}
