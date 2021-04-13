public with sharing class DatatableHelper {

    private DatatableHelper(){}

    public static final String NAME_STRING = 'Name';
    public static final String URL_TYPE_NAME = 'url';

    public static List<Schema.FieldSetMember> getFieldSetMembers(String objApiName, String fieldSetName) {
        FieldSet currentFieldSet = Schema.getGlobalDescribe().get(objApiName).getDescribe().fieldSets.getMap().get(fieldSetName);
        if (null == currentFieldSet) {
            throw new AuraHandledException(objApiName + ' Field Set "' + fieldSetName + '" is not found');
        }
        return currentFieldSet.getFields();
    }

    public static DataTableFieldsWrapper setDateAttributes(DataTableFieldsWrapper newWrapper, Boolean showDateAsNumeric){
        if (showDateAsNumeric) {
            newWrapper.typeAttributes = new TypeAttributes();
            newWrapper.typeAttributes.day = 'numeric';
            newWrapper.typeAttributes.month = 'numeric';
            newWrapper.typeAttributes.year = 'numeric';
        }
        return newWrapper;
    }

    public static DataTableFieldsWrapper setupLink(DataTableFieldsWrapper newWrapper, Boolean isReference, Map<String, String> overrideLinksMap, Boolean openLinkInNewPage){
        if (null == newWrapper.typeAttributes) {
            newWrapper.typeAttributes = new TypeAttributes();
        }
        newWrapper.typeAttributes.label = new Map<String, String>{'fieldName' => isReference ? getFieldName(newWrapper.fieldName, overrideLinksMap) : newWrapper.fieldName};
        if (openLinkInNewPage) {
            newWrapper.typeAttributes.target = '_blank';
        }
        if (!isReference) {
            newWrapper.fieldName = getFieldName(newWrapper.fieldName, overrideLinksMap);
        }
        newWrapper.type = URL_TYPE_NAME;
        return newWrapper;
    }

    public static DataTableFieldsWrapper getActionsWrapper(Map<String, String> labelToActionMap){
        DataTableFieldsWrapper actionsFieldsWrapper = new DataTableFieldsWrapper();
        actionsFieldsWrapper.type = 'action';
        actionsFieldsWrapper.typeAttributes = new TypeAttributes();
        actionsFieldsWrapper.typeAttributes.rowActions = new List<Map<String, String>>();
        for (String actionLabel : labelToActionMap.keySet()) {
            actionsFieldsWrapper.typeAttributes.rowActions.add(new Map<String, String>{
                    'label' => actionLabel,
                    'name' => labelToActionMap.get(actionLabel)
            });
        }
        return actionsFieldsWrapper;
    }

    public static String getFieldName(String fieldName, Map<String, String> overrideLinksMap) {
        String newFieldName = fieldName;
        if (fieldName.equalsIgnoreCase('Id')) {
            newFieldName = NAME_STRING;
        }
        else if (fieldName.endsWithIgnoreCase(NAME_STRING)) {
            newFieldName = fieldName.removeEndIgnoreCase(NAME_STRING) + 'Id';
        }
        else if (fieldName.endsWithIgnoreCase('id')) {
            newFieldName = fieldName.removeEndIgnoreCase('id') + '.Name';
        }
        else if (fieldName.endsWithIgnoreCase('__c')) {
            newFieldName = fieldName.removeEndIgnoreCase('c') + 'r.Name';
        }
        else if (null != overrideLinksMap && overrideLinksMap.containsKey(fieldName)) {
            newFieldName = overrideLinksMap.get(fieldName);
        }
        return newFieldName;
    }

    public static Object findFieldValue(String name, SObject record, Boolean prepareLink) {
        Object value;
        if (name.contains('.')) {
            List<String> sObjectsList = name.split('\\.');
            for (Integer i = 0; i < sObjectsList.size() - 1; i++) {
                value = null == value ? record.getSObject(sObjectsList[i]) : ((SObject)value).getSObject(sObjectsList[i]);
                if (null == value) {
                    return null;
                }
            }
            value = ((SObject)value).get(sObjectsList[sObjectsList.size() - 1]);
        } else {
            value = record.get(name);
        }
        return null == value ? null : prepareLink ? '/' + value : value;
    }

    public static List<DatatableHelper.DataTableFieldsWrapper> updateFieldLabels(List<DatatableHelper.DataTableFieldsWrapper> wrappersList, Map<String, String> fieldLabelsMap) {
        for (DatatableHelper.DataTableFieldsWrapper wrapper : wrappersList) {
            if (fieldLabelsMap.containsKey(wrapper.fieldName)) {
                wrapper.label = fieldLabelsMap.get(wrapper.fieldName);
            }
        }
        return wrappersList;
    }

    public class DataTableFieldsWrapper {
        @AuraEnabled
        public String label { get; set; }
        @AuraEnabled
        public String fieldName { get; set; }
        @AuraEnabled
        public String type { get; set; }
        @AuraEnabled
        public Boolean sortable { get; set; }
        @AuraEnabled
        public TypeAttributes typeAttributes { get; set; }
    }

    public class TypeAttributes {
        @AuraEnabled
        public String day { get; set; }
        @AuraEnabled
        public String month { get; set; }
        @AuraEnabled
        public String year { get; set; }
        @AuraEnabled
        public Map<String, String> label { get; set; }
        @AuraEnabled
        public String target { get; set; }
        @AuraEnabled
        public List<Map<String, String>> rowActions { get; set; }
    }

    public class DataTableColumnsInfoWrapper {
        @AuraEnabled
        public List<DatatableHelper.DataTableFieldsWrapper> fieldsWrappersList { get; set; }
        @AuraEnabled
        public  Set<String> fieldNamesSet { get; set; }
        public DataTableColumnsInfoWrapper(){
            fieldsWrappersList = new List<DatatableHelper.DataTableFieldsWrapper>();
            fieldNamesSet = new Set<String>();
        }
    }

}