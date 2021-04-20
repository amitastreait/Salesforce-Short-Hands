import { LightningElement, api, track } from 'lwc';

export default class CarouselComponent extends LightningElement {

    @api items;
    @api options;
    @track components;
    @track showPlayIcon;
    activeComponent = 0;
    loaded = false;
    autoScroll;
    intervalVar;

    navigate(event) {
        this.activeComponent = parseInt(event.target.dataset.id);
        this.arrangeComponents();
    }

    arrangeComponents() {
        let untrackedComponents = [];
        let iterator = 0;
        this.items.forEach(item => {
            let temp = { ...item };
            temp.id = iterator;
            temp.contentId = 'content-id-' + iterator;
            temp.indicatorId = 'indicator-id-' + iterator;
            if(temp.href){
                temp.href='javascript:void(0);';
            }
            if (iterator === this.activeComponent) {
                temp.hidden = false;
                temp.tabindex = 0;
                temp.active = true;
                temp.indicatorClass = 'slds-carousel__indicator-action slds-is-active';
                temp.contentClass = 'slds-carousel__panel';
            } else {
                temp.hidden = true;
                temp.tabindex = -1;
                temp.active = false;
                temp.indicatorClass = 'slds-carousel__indicator-action';
                temp.contentClass = 'slds-carousel__panel panel-hide';
            }
            untrackedComponents.push(temp);
            iterator++;
        });
        this.components = untrackedComponents;
    }

    togglePlay(){
        if(!this.showPlayIcon){
            clearInterval(this.intervalVar);
            this.showPlayIcon = true;
        }else{
            this.checkOptions();
        }
    }

    checkOptions() {
        if (this.options) {
            if (this.options.autoScroll && this.options.autoScrollTime) {
                this.autoScroll = true;
                this.showPlayIcon = false;
                this.intervalVar = setInterval(() => {
                    if (this.activeComponent === (this.components.length - 1)) {
                        this.activeComponent = 0;
                    } else {
                        this.activeComponent++;
                    }
                    this.arrangeComponents();
                }, this.options.autoScrollTime * 1000);
            }
        }
    }

    renderedCallback() {
        if (!this.loaded) {
            this.arrangeComponents();
            this.checkOptions();
            this.loaded = true;
        }
    }
}