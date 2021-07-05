public class TriggerContext {

    public Boolean BEFORE_INSERT  		 { get; set; }
    public Boolean BEFORE_UPDATE  		 { get; set; }
    public Boolean BEFORE_DELETE  		 { get; set; }
    public Boolean AFTER_INSERT 	 	 { get; set; }
    public Boolean AFTER_UPDATE	 		 { get; set; }
    public Boolean AFTER_DELETE 	 	 { get; set; }
    public Boolean AFTER_UNDELETE 		 { get; set; }
    public List<sObject> newList		 { get; set; }
    public List<sObject> old		 	 { get; set; }
    public Map<Id, sObject> newMap		 { get; set; }
    public Map<Id, sObject> oldMap		 { get; set; }
    public Boolean isExecuting		     { get; set; }
    
    public TriggerContext(List<sObject> newList, List<sObject> old, Map<Id, sObject> newMap, Map<Id, sObject> oldMap, Boolean isExecuting, Boolean BEFORE_INSERT,
                         Boolean BEFORE_UPDATE, Boolean BEFORE_DELETE, Boolean AFTER_INSERT, Boolean AFTER_UPDATE, Boolean AFTER_DELETE, Boolean AFTER_UNDELETE){
        this.newList 		= newList;
        this.old 			= old;
        this.newMap 		= newMap;
        this.oldMap 		= oldMap;
        this.isExecuting 	= isExecuting;
        this.BEFORE_INSERT 	= BEFORE_INSERT;
        this.BEFORE_UPDATE 	= BEFORE_UPDATE;
        this.BEFORE_DELETE  = BEFORE_DELETE;
        this.AFTER_INSERT 	= AFTER_INSERT;
        this.AFTER_UPDATE 	= AFTER_UPDATE;
        this.AFTER_DELETE 	= AFTER_DELETE;
        this.AFTER_UNDELETE = AFTER_UNDELETE;
    }
    
}