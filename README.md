# Salesforce Utils

[![Validate Against Production Org](https://github.com/amitastreait/Salesforce-Short-Hands/actions/workflows/salesforce-dx-master.yml/badge.svg?branch=master)](https://github.com/amitastreait/Salesforce-Short-Hands/actions/workflows/salesforce-dx-master.yml)

[![Validate Against QA](https://github.com/amitastreait/Salesforce-Short-Hands/actions/workflows/ci-push.yml/badge.svg)](https://github.com/amitastreait/Salesforce-Short-Hands/actions/workflows/ci-push.yml)

[![Enforce branch naming](https://github.com/amitastreait/Salesforce-Short-Hands/actions/workflows/branch-naming.yml/badge.svg)](https://github.com/amitastreait/Salesforce-Short-Hands/actions/workflows/branch-naming.yml)

This repo is maintained by Amit Singh aka SFDCPanther. The main purpose of this repo is to put all the reusable utility which I have developed so that all others can use them. If you wanted to contribute you can also contribute. How to contribute, check the below steps for the same.

## Features Uploaded - 11 April 2021
This repository contains the following features

- [Custom File Upload using LWC](https://github.com/amitastreait/Salesforce-Short-Hands/tree/master/sfdxsrc/customFileUpload)
- [Custom Reusable Lookup for LWC](https://github.com/amitastreait/Salesforce-Short-Hands/tree/master/sfdxsrc/customLookup)
- [Extend Lightning DataTable in Lightning Web Component](https://github.com/amitastreait/Salesforce-Short-Hands/tree/master/sfdxsrc/lightningDataTable)
- [Custom Rating Component using LWC](https://github.com/amitastreait/Salesforce-Short-Hands/tree/master/sfdxsrc/ratingComponent)
- [Rich Text Area for Flow](https://github.com/amitastreait/Salesforce-Short-Hands/tree/master/sfdxsrc/flows/lwc)
- [Carousel Component in LWC](https://github.com/amitastreait/Salesforce-Short-Hands/tree/master/sfdxsrc/flows/lwc) - Reference from https://live.playg.app/
- [Custom Metadata Uploader](https://github.com/amitastreait/Salesforce-Short-Hands/tree/master/sfdxsrc/flows/metadataUploader)

### To contribute your utility must qualify below criterias.

- Utility must be reusable
- All the Classes, Trigger must have test classes and test classes must cover atleast 85% of your code.
- Your Utility folder must contain ReadMe.md file with the steps to use the utility. ( If possible create a small video )
- You must follow the best steps to use your new branch to develop the utility.

## Clone the repo to your Local PC.

The very first step is to clone this repo into your salesforce rep. Use the below command.
`git clone https://github.com/amitastreait/Salesforce-Recepies`

## Create your own branch in local machine.

Once you have cloned the Repo into your local machine then create a new branch for your utility. The branch name should follow the naming convension like below. If you name is amit singh and utility name is lookup then branch name should be `lookup-amit-singh`. You can use below command to create your branch.
`git checkout -b lookup-amit-singh`

this will create a new branch and will switch you to your new branch.

## Create a Seprate Folder for your Utility

- Now, the next step is to create a seprate folder and the folder name will say the name of your utility. For example customLookup.
- To create the folder, go to the folder where you have cloned the project and open it. open `sfdxsrc` folder and then create a new folder and the folder name should be based on your utility.
- Your parent Folder will contain the sub folders to store the metadata. For Example, this parent folder will contain the sub folders like. objects, lwc, classes, staticresources, etc.

![Folders Path](https://github.com/amitastreait/Salesforce-Short-Hands/blob/master/images/folders.PNG)

## Modify sfdx-project.json file

Next step is to modify `sfdx-project.json` file. Open the project in your VS code and then open the file. Add a new path for your new folder. For Example the folder name is customLookup then new path should be
```
{
   "path": "sfdxsrc/customLookup",
   "default": false
}
```
![Project Path](https://github.com/amitastreait/Salesforce-Short-Hands/blob/master/images/path.PNG)

## Push the changes to your branch after utility has been developed
Once you have completed the development of your utility, push the changes to your branch. You can follow the below set of commands to push the changes.

- stage all the changes using `git add .` command. Note -- Please make sure you push necessary changes only.
- Commit all the changes to your local branch using `git commit -m "A valid message here that make sense"`
- Push the changes to your branch using `git push -u origin yourBranchName`. For Example, you branch is lookup-amit-singh then command will be `git push -u origin lookup-amit-singh`

## Create a Pull Request to merge all your changes.
Now, final step from your side is to create a Pull Request from your branch to Master Branch. 

## Final Review
- I will review the changes and if everything is ok, I will merge the branch with master branch and you will be notified via email.
- If there are any issues, I will create an issue and assign it to you.
- You can resolve that and then again commit your changes. this time you don not need to raise the pull request.