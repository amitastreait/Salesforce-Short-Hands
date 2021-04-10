import { LightningElement } from 'lwc';

export default class Feedback extends LightningElement {

    handleRatingChanged(event){
        let rating = event.detail.rating;
    }
}