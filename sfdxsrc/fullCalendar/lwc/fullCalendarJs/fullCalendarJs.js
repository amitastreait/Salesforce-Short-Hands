/* eslint-disable no-restricted-globals */
/* eslint-disable no-unused-vars */
/* eslint-disable no-alert */
/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 07-13-2020
 * @last modified by  : Amit Singh
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   07-10-2020   Amit Singh   Initial Version
**/
import { LightningElement, track } from 'lwc';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import FullCalendarJS from '@salesforce/resourceUrl/FullCalendarJS';
import { NavigationMixin } from 'lightning/navigation';
import fetchAllEvents from '@salesforce/apex/FullCalendarService.fetchAllEvents';
/**
 * FullCalendarJs
 * @description Full Calendar JS - Lightning Web Components
 */
export default class FullCalendarJs extends NavigationMixin(LightningElement) {

  fullCalendarJsInitialised = false;
  @track allEvents = [];
  @track selectedEvent = undefined;
  createRecord = false;

  /**
   * @description Standard lifecyle method 'renderedCallback'
   *              Ensures that the page loads and renders the 
   *              container before doing anything else
   */
  renderedCallback() {

    // Performs this operation only on first render
    if (this.fullCalendarJsInitialised) {
      return;
    }
    this.fullCalendarJsInitialised = true;

    // Executes all loadScript and loadStyle promises
    // and only resolves them once all promises are done
    Promise.all([
      loadScript(this, FullCalendarJS + '/jquery.min.js'),
      loadScript(this, FullCalendarJS + '/moment.min.js'),
      loadScript(this, FullCalendarJS + '/theme.js'),
      loadScript(this, FullCalendarJS + '/fullcalendar.min.js'),
      loadStyle(this, FullCalendarJS + '/fullcalendar.min.css'),
      // loadStyle(this, FullCalendarJS + '/fullcalendar.print.min.css')
    ])
    .then(() => {
      // Initialise the calendar configuration
      this.getAllEvents();
    })
    .catch(error => {
      // eslint-disable-next-line no-console
      console.error({
        message: 'Error occured on FullCalendarJS',
        error
      });
    })
  }

  /**
   * @description Initialise the calendar configuration
   *              This is where we configure the available options for the calendar.
   *              This is also where we load the Events data.
   */
  initialiseFullCalendarJs() {
    const ele = this.template.querySelector('div.fullcalendarjs');
    // eslint-disable-next-line no-undef
    $(ele).fullCalendar({
      header: {
          left: 'prev,next today',
          center: 'title',
          right: 'month,basicWeek,basicDay,listWeek'
      },
      themeSystem : 'standard',
      defaultDate: new Date(), 
      navLinks: true,
      editable: true,
      eventLimit: true,
      events: this.allEvents,
      dragScroll : true,
      droppable: true,
      weekNumbers : true,
      eventDrop: this.eventDropHandler.bind(this),
      eventClick: this.eventClickHandler.bind(this),
      dayClick : this.dayClickHandler.bind(this),
      eventMouseover : this.eventMouseoverHandler.bind(this)
    });
  }

  eventMouseoverHandler = (event, jsEvent, view)=>{

  }
  eventDropHandler = (event, delta, revertFunc)=>{
    alert(event.title + " was dropped on " + event.start.format());
    if (!confirm("Are you sure about this change? ")) {
      revertFunc();
    }
  }

  eventClickHandler = (event, jsEvent, view) => {
      this.selectedEvent =  event;
  }

  dayClickHandler = (date, jsEvent, view)=>{
    jsEvent.preventDefault();
    this.createRecord = true;
  }

  createCancel() {
    this.createRecord = false;
  }

  getAllEvents(){
      fetchAllEvents()
      .then(result => {
        this.allEvents = result.map(item => {
          return {
            id : item.Id,
            editable : true,
            title : item.Subject,
            start : item.ActivityDate,
            end : item.EndDateTime,
            description : item.Description,
            allDay : false,
            extendedProps : {
              whoId : item.WhoId,
              whatId : item.WhatId
            },
            //backgroundColor: "rgb(" + Math.floor(Math.random() * 256) + "," + Math.floor(Math.random() * 256) + "," + Math.floor(Math.random() * 256) + ")",
            //borderColor: "rgb(" + Math.floor(Math.random() * 256) + "," + Math.floor(Math.random() * 256) + "," + Math.floor(Math.random() * 256) + ")"
          };
        });
        // Initialise the calendar configuration
        this.initialiseFullCalendarJs();
      })
      .catch(error => {
        window.console.log(' Error Occured ', error)
      })
      .finally(()=>{
        //this.initialiseFullCalendarJs();
      })
  }

  closeModal(){
    this.selectedEvent = undefined;
  }
}