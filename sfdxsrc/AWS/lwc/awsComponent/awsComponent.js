
import { LightningElement, track } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import AWS_SDK from '@salesforce/resourceUrl/AWS_SDK';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AwsComponent extends LightningElement {

    albumBucketName = '-sdk';
    accessKeyId = '';
    secretAccessKey = '';
    region = 'us-east-2';

    /* Amazon Product instances */
    s3;
    ses;
    ec2;
    dynamodb;
    connect;

    /* variable to store the File Upload components */
    selectedFilesToUpload;
    showSpinner = false; 
    fileName;

    /* Varibale to use inside the renderedCallback method */
    awsSdkInitialized = false;

    renderedCallback(){

        if (this.awsSdkInitialized) {
            return;
        }
        this.awsSdkInitialized = true;
        Promise.all([
            loadScript(this, AWS_SDK),
        ])
        .then(() => {
            this.awsSdkInitialize();
        })
        .catch(error => {
            console.log(error);
        });

    }

    awsSdkInitialize(){

        const AWS = window.AWS;
        AWS.config.update({
            accessKeyId : this.accessKeyId,
            secretAccessKey : this.secretAccessKey
        });
        AWS.config.region = this.region;
        this.s3 = new AWS.S3({
            apiVersion: '2006-03-01'
        });
        this.ses = new AWS.SES();
        this.ec2 = new AWS.EC2({
            apiVersion: '2016-11-15'
        });
        this.dynamodb = new AWS.DynamoDB({ 
            apiVersion: '2012-08-10' 
        });
        this.connect  = new AWS.Connect({ 
            apiVersion: '2017-08-08' 
        });

    }

    handleSelectedFiles(event){

        if (event.target.files.length > 0) {
            this.selectedFilesToUpload = event.target.files[0];
            this.fileName = event.target.files[0].name; 
        }

    }

    uploadToAWS = () => {

        if (this.selectedFilesToUpload) {

            this.showSpinner = true;

            let objKey = this.selectedFilesToUpload.name
                .replace(/\s+/g, "_") 
                .toLowerCase();
            
            var params = {
                Body: this.selectedFilesToUpload,
                Bucket: this.albumBucketName, 
                Key: objKey, 
                ContentType: this.selectedFilesToUpload.type,
            };

            this.s3.putObject( params, this.handleAmazonResponse.bind(this) );
        }

    }

    listS3Objects = () => {

        this.showSpinner = true;
        var params = {
            Bucket: this.albumBucketName,
            MaxKeys: 2
        };
        this.s3.listObjects(params, this.handleAmazonResponse.bind(this) );

    }

    createS3Bucket = () => {

        this.showSpinner = true;
        var params = {
            Bucket: "examplebuc8798934ket",
            CreateBucketConfiguration: {
                LocationConstraint: this.region
            }
        };
        this.s3.createBucket( params, this.handleAmazonResponse.bind(this) );

    }

    sendSESEmail(){

        this.showSpinner = true;
        var params = {
            Destination: {
                ToAddresses: [
                    "amitasinghsfdc@gmail.com"
                ]
            },
            Message: {
                Body: {
                    Html: {
                        Charset: "UTF-8",
                        Data: "This message body contains HTML formatting. It can, for example, contain links like this one: <a class=\"ulink\" href=\"http://docs.aws.amazon.com/ses/latest/DeveloperGuide\" target=\"_blank\">Amazon SES Developer Guide</a>."
                    },
                    Text: {
                        Charset: "UTF-8",
                        Data: "This is the message body in text format."
                    }
                },
                Subject: {
                    Charset: "UTF-8",
                    Data: "Test email"
                }
            },
            Source: "amitasinghsfdc@gmail.com"
        };
        this.ses.sendEmail( params, this.handleAmazonResponse.bind(this) );

    }

    listSESEmails() {

        this.showSpinner = true;
        var params = {
            IdentityType: "EmailAddress", 
            MaxItems: 123
        };
        this.ses.listIdentities(params, this.handleAmazonResponse.bind(this));

    }

    handleAmazonResponse = (err, data) => {
        
        if (err) {
            this.showSpinner = false;
            console.log(err, err.stack);
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error!',
                message: JSON.stringify( err ),
                variant: 'error'
            }));
        } else {
            console.log('Response From Amazon ', data);
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success',
                message: 'Operation was successful',
                variant: 'success'
            }));
            this.showSpinner = false;
        }

    }

    getIdentityVerificationAttributes = () =>{

        var params = {
            Identities: [
                "amitasinghsfdc@gmail.com"
            ]
        };
        this.ses.getIdentityVerificationAttributes(params, this.handleAmazonResponse.bind(this) );

    }

    createTable = () => {

        this.showSpinner = true;
        var params = {
            AttributeDefinitions: [{
                    AttributeName: "Artist",
                    AttributeType: "S"
                },
                {
                    AttributeName: "SongTitle",
                    AttributeType: "S"
                },
                {
                    AttributeName: "ReleaseDate",
                    AttributeType: "S"
                },
                {
                    AttributeName: "MovieName",
                    AttributeType: "S"
                }
            ],
            KeySchema: [
                {
                    AttributeName: "Artist",
                    KeyType: "HASH"
                },
                {
                    AttributeName: "SongTitle",
                    KeyType: "RANGE"
                },
                {
                    AttributeName: "ReleaseDate",
                    AttributeType: "RANGE"
                },
                {
                    AttributeName: "MovieName",
                    AttributeType: "HASH"
                }
            ],
            ProvisionedThroughput: {
                ReadCapacityUnits: 5,
                WriteCapacityUnits: 5
            },
            TableName: "ALBUM"
        };
        this.dynamodb.createTable(params, this.handleAmazonResponse.bind(this) );

    }

    putTableItem = () => {

        this.showSpinner = true;
        /* This example adds a new item to the Music table. */
        var params = {
            Item: {
                "AlbumTitle": {
                    S: "Somewhat Famous"
                },
                "Artist": {
                    S: "No One You Know"
                },
                "SongTitle": {
                    S: "Call Me Today"
                },
                "MovieTitle": {
                    S: "Call Me Today"
                }
            },
            ReturnConsumedCapacity: "TOTAL",
            TableName: "Music"
        };
        this.dynamodb.putItem(params, this.handleAmazonResponse.bind(this) );

    }

    queryTable = () => {

        this.showSpinner = true;
        var params = {
            ExpressionAttributeValues: {
                ":v1": {
                    S: "No One You Know"
                }
            },
            KeyConditionExpression: "Artist = :v1",
            TableName: "Music",
            Select: 'ALL_ATTRIBUTES'
        };
        this.dynamodb.query( params, this.handleAmazonResponse.bind(this) );

    }

    getSerialConsoleAccessStatus = ()=>{

        this.showSpinner = true;
        var params = {
            DryRun: false
        };
        this.ec2.getSerialConsoleAccessStatus(params, this.handleAmazonResponse.bind(this));

    }
}