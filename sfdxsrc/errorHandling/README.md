# Custom Logger Framework : Salesforce

Error handling framework will be used to handle the Logs for any custom apex class, flow, lwc or process builder.

## How to use Logger Framework?

Create the Object of Logger Object Like Below and pass all the required parameter to the constructor
`Logger log = new Logger(message, componentName, eventLevel, typex);`

If you wanted to add some additional values to the Logger Object. Like Below
`log.logRecord.ExternalSystem__c = 'Stripe'; `
`log.logRecord.ExternalReferenceCode__c = String.valueOf(statusCode);`
`log.logRecord.ExternalSystemResult__c  = detailedError; `
`log.logRecord.ExternalSystemErrorCodes__c = 'https://stripe.com/docs/error-codes';`
`log.logRecord.ExternalSystemDocument__c = 'https://stripe.com/docs/api';`


## Save the Log into the System
Call the Log method to save the log into the system with the required parameter
`log.log( UserInfo.getUserId(), detailedError, detailedError, '');`
Code Explanation
- UserInfo.getUserId() : The Id of the user who is creating the Log
- detailedError - The Error Message
- detailedError - The detailed error message

## Save the Log into the System & Send Email to the Users
If you wanted to Save the log and the log is important to send via email then Call the sendLogEmail method to save the log into the system with the required parameter
`sendLogEmail(String userId, String emailBody, List<String> emails, String subject);`
Code Explanation
- userId : The Id of the user who is creating the Log
- emailBody - The email body which needs to be sent via email. Note:- this can contain html body as well
- emails - List of All the Emails whom to send the log
- subject - The Subject for the Email

## Add the Component into the Recod Details Page

- Open Any System Event record details Page
- Edit the Record Details Page
- Drag & Drop customLogger component into the Detail Page

This new LWC Component will help the developer to change the resolution status of the System Event Record

## Record Page

![Rating Component](https://github.com/amitastreait/Salesforce-Short-Hands/blob/master/images/error.PNG)

## Contribute to the Utilities
If you wanted to contribute to the utilities then please follow the steps from below link
- [Contribute to the Utilities](https://github.com/amitastreait/Salesforce-Short-Hands)

## Share feedback
Please do share the feedback