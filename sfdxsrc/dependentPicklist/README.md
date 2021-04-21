# Picklist-Field-Dependency

![CSV FILE](https://github.com/amitastreait/Salesforce-Short-Hands/blob/master/images/banner.png)

## Scenarios
We need to create a dependent picklist between 2 picklists into Salesforce Org, you all might be thinking that you do not need to write apex and it can be done using out of functionality but in my case, we have more than 1K values in both picklists and can be added/removed in future in the short dynamic dependent picklist. In final we have to create 4 dependent picklists on the different objects.

## Solution
On the first attempt, I thought to accomplish this manually hahaha I knew that it is a time-consuming process.  After spending hours on this and doing brainstorming I came with the below solution.

## Final Solution
We decided to write the apex code to do the same which also can be used to create dependent picklists for any object in the future.

## Prerequisite to use this solution

- Both the Dependent Picklist must be present inside Salesforce and Have all the required values added in it.

## Advantages to this Solution
- Can create the thousands of Field Dependency within minutes
- If you have Multi Level-Dependent Picklist then You can easily create the dependency using the above solution All you need to do is prepare the CSV file in the correct format.

## Steps
- Create both picklists into the Object with the actual values into them and also define the dependency between the fields(which is controlling and which one is dependent).
- Create a Custom Setting OR CustomMetdata Types to store Controlling picklist as Name and dependent values in a separate field so that it can be used in the class can be easily managed in the future.
- OR if you do not want to create then prepare the .csv file with two columns 1) Controlling Picklist Value and 2) Dependent Picklist Value.
- All we need to do is to prepare the Map with Dependent Picklist value as Key and List of Controlling field values as Value. For Example – Map<String, List<String>> {‘ACT’ => {‘Austria’, ‘Another Country’}}

## Tips to Prepare CSV file
- The first Row in the CSV file contains the Object API Name however we are not using this in Apex.
- In the Second Row, First Column will be the Parent Field API Name in My case "AccountSource" & the Second Column value will be the Field API Name of the Dependent Picklist in My Case "Active__c"

## Screenshot for the sample .csv file

![CSV FILE](https://github.com/amitastreait/Salesforce-Short-Hands/blob/master/images/picklist_csv.png)

## Screenshot for the VF Page

![CSV FILE](https://github.com/amitastreait/Salesforce-Short-Hands/blob/master/images/picklist.PNG)

## Contribute to the Utilities
If you wanted to contribute to the utilities then please follow the steps from below link
- [Contribute to the Utilities](https://github.com/amitastreait/Salesforce-Short-Hands)

## Share feedback
Please do share the feedback