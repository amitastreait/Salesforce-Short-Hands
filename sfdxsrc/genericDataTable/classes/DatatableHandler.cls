public with sharing class DatatableHandler {

    public DatatableHandler (String objApiName, String fieldSetName){
        this.objApiName = objApiName;
        this.fieldSetName = fieldSetName;
        this.openLinkInNewPage = true;
        this.showDateAsNumeric = false;
        this.firstLevelSObject = '';
    }

    private String objApiName;
    private String fieldSetName;
    public String firstLevelSObject;
    public Boolean openLinkInNewPage	{ get; set; }
    public Boolean showDateAsNumeric	{ get; set; }
    public Set<String> linkNamesSet	    { get; set; }
    public Map<String, String> overrideLinksMap{ get; set; }
    public Map<String, String> labelToActionMap{ get; set; }


    public DatatableHelper.DataTableColumnsInfoWrapper getColumnsInfo() {
        
        DatatableHelper.DataTableColumnsInfoWrapper columnsWrapper = new DatatableHelper.DataTableColumnsInfoWrapper();
        List<Schema.FieldSetMember> fieldSetMembersList = DatatableHelper.getFieldSetMembers(objApiName, fieldSetName);
        
        DatatableHelper.DataTableFieldsWrapper newFieldsWrapper;
        
        for (Schema.FieldSetMember field : fieldSetMembersList) {
            if(field.getSObjectField().getDescribe().isAccessible()){
                newFieldsWrapper = getFieldWrapper(field);
                columnsWrapper.fieldsWrappersList.add(newFieldsWrapper);
                columnsWrapper.fieldNamesSet.add(newFieldsWrapper.fieldName);
                if (DatatableHelper.URL_TYPE_NAME == newFieldsWrapper.type) {
                    columnsWrapper.fieldNamesSet.add(newFieldsWrapper.typeAttributes.label.get('fieldName'));
                }
            }
        }
        
        if (columnsWrapper.fieldsWrappersList.isEmpty()) {
            throw new AuraHandledException('You do not have access to fields from "' + fieldSetName + '"');
        }
        if (null != labelToActionMap) {
            columnsWrapper.fieldsWrappersList.add(DatatableHelper.getActionsWrapper(labelToActionMap));
        }
        return columnsWrapper;
    }

    private DatatableHelper.DataTableFieldsWrapper getFieldWrapper(Schema.FieldSetMember field) {
        DatatableHelper.DataTableFieldsWrapper newWrapper = new DatatableHelper.DataTableFieldsWrapper();
        newWrapper.label = field.getLabel();
        newWrapper.fieldName = firstLevelSObject + field.getFieldPath();
        newWrapper.type = field.getType().name().toLowerCase();
        newWrapper.sortable = true;
        if ('double' == newWrapper.type) {
            newWrapper.type = 'number';
        }
        if ('datetime' == newWrapper.type) {
            newWrapper.type = 'date';
            newWrapper = DatatableHelper.setDateAttributes(newWrapper, showDateAsNumeric);
        }
        Boolean isReference = 'reference' == newWrapper.type;
        if (null != linkNamesSet && linkNamesSet.contains(newWrapper.fieldName)) {
            newWrapper = DatatableHelper.setupLink(newWrapper, isReference, overrideLinksMap, openLinkInNewPage);
        }
        else if (isReference) {
            newWrapper.fieldName = DatatableHelper.getFieldName(newWrapper.fieldName, overrideLinksMap);
        }
        return newWrapper;
    }

    public static List<Map<String, Object>> getFieldValues(List<SObject> resultList, List<DatatableHelper.DataTableFieldsWrapper> fieldsWrappersList) {
        List<Map<String, Object>> fieldValuesMapList = new List<Map<String, Object>>();
        Map<String, Object> fieldValuesMap;
        String name, newName;
        Object value;
        Boolean isUrl;
        for (SObject record : resultList) {
            fieldValuesMap = new Map<String, Object>();
            for (DatatableHelper.DataTableFieldsWrapper fieldWrapper : fieldsWrappersList) {
                if ('action' != fieldWrapper.type) {
                    name = fieldWrapper.fieldName;
                    isUrl = false;
                    if (null != fieldWrapper.type && fieldWrapper.type.equals(DatatableHelper.URL_TYPE_NAME)) {
                        isUrl = true;
                    }
                    value = DatatableHelper.findFieldValue(name, record, isUrl);
                    fieldValuesMap.put(name, value);
                    if (isUrl) {
                        newName = fieldWrapper.typeAttributes.label.get('fieldName');
                        value = DatatableHelper.findFieldValue(newName, record, false);
                        fieldValuesMap.put(newName, value);
                    }
                }
            }
            if (!fieldValuesMap.containsKey('Id')) {
                fieldValuesMap.put('Id', record.get('Id'));
            }
            fieldValuesMapList.add(fieldValuesMap);
        }
        return fieldValuesMapList;
    }

}