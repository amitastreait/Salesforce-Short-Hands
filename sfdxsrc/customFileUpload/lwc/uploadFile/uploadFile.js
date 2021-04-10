import { LightningElement, api } from 'lwc';
import saveTheChunkFile from '@salesforce/apex/FileUploadService.saveTheChunkFile';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
const MAX_FILE_SIZE = 4500000;
const CHUNK_SIZE = 750000;
export default class UploadFile extends LightningElement {
    
    @api recordId;

    fileName = '';
    filesUploaded = [];
    isLoading = false;
    fileSize;

    handleFilesChange(event) {
        if(event.target.files.length > 0) {
            this.filesUploaded = event.target.files;
            this.fileName = event.target.files[0].name;
            var fileCon = this.filesUploaded[0];
            this.fileSize = this.formatBytes(fileCon.size, 2);
        }
    }

    saveFile(){
        var fileCon = this.filesUploaded[0];
        if (fileCon.size > MAX_FILE_SIZE) {
            let message = 'File size cannot exceed ' + MAX_FILE_SIZE + ' bytes.\n' + 'Selected file size: ' + fileCon.size;
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: message,
                variant: 'error'
            }));
            return;
        }
        var reader = new FileReader();
        var self = this;
        reader.onload = function() {
            var fileContents = reader.result;
            var base64Mark = 'base64,';
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
            fileContents = fileContents.substring(dataStart);
            self.upload(fileCon, fileContents);
        };
        reader.readAsDataURL(fileCon);
    }

    upload(file, fileContents){
        var fromPos = 0;
        var toPos = Math.min(fileContents.length, fromPos + CHUNK_SIZE);
        
        this.uploadChunk(file, fileContents, fromPos, toPos, ''); 
    }

    uploadChunk(file, fileContents, fromPos, toPos, attachId){
        this.isLoading = true;
        var chunk = fileContents.substring(fromPos, toPos);
        
        saveTheChunkFile({ 
            parentId: this.recordId,
            fileName: file.name,
            base64Data: encodeURIComponent(chunk), 
            contentType: file.type,
            fileId: attachId
        })
        .then(result => {
            
            attachId = result;
            fromPos = toPos;
            toPos = Math.min(fileContents.length, fromPos + CHUNK_SIZE);    
            if (fromPos < toPos) {
                this.uploadChunk(file, fileContents, fromPos, toPos, attachId);  
            }else{
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success!',
                    message: 'File Upload Success',
                    variant: 'success'
                }));
                this.isLoading = false;
            }
        })
        .catch(error => {
            console.error('Error: ', error);
        })
        .finally(()=>{
            
        })
    }

    formatBytes(bytes,decimals) {
        if(bytes == 0) return '0 Bytes';
        var k = 1024,
            dm = decimals || 2,
            sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
            i = Math.floor(Math.log(bytes) / Math.log(k));
        return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
    }


}