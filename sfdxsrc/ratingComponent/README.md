# Custom Rating Component Lightning Web Component

There are many use cases when we need to develop the rating component to display the rating for example survey result, interview feedback.

## Usage

Where ever you wanted to use rating component. Add the code like below
```
<div >
    <lightning-tile label="Salesforce" href="JavaScript:void(0);" type="media">
        <c-five-star-rating value="5" onratingchange={handleRatingChanged} ></c-five-star-rating>
    </lightning-tile>    
</div>

```

## Code Explanation

- value - In the code, you can see that I have passed one variable value which indicates what value you wanted to pass and the valid values are 1-5
- onratingchange - this is the event raised by the rating component which in return sends the rating value from 1-5
- readOnly - If you wanted your rating to be read-only then pass any value to this property like read-only="yes"
- handleRatingChanged(event){ let rating=event.detail.rating; }

## Get the Selected Rating
To get the selected rating, the number which has been selected by the user the handle `ratingchange` and use below code to get the details
```
handleRatingChanged(event){ 
    let rating=event.detail.rating; 
}
```
![Rating Component](https://github.com/amitastreait/Salesforce-Short-Hands/blob/master/images/rating.png)

## Contribute to the Utilities
If you wanted to contribute to the utilities then please follow the steps from below link
- [Contribute to the Utilities](https://github.com/amitastreait/Salesforce-Short-Hands)

## Share feedback
Please do share the feedback
