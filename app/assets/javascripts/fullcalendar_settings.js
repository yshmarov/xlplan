/*global $*/
/*global app*/
/*global moment*/

//to show current time in calendar
var TimeNow  = moment().format("HH") + ":00:00";

function eventCalendar() {
  return $('#event_calendar').fullCalendar({ 
    schedulerLicenseKey: 'GPL-My-Project-Is-Open-Source',
    // 100% height
    height: "auto",
    // render data
    resources: app.vars.resources,

    viewRender: function(view, element){
        var currentdate = view.intervalStart;
        $('#datepicker').datepicker().datepicker('setDate', new Date(currentdate));
    },

    events: app.vars.events,
    locale: app.vars.locale,
    // design
    themeSystem: 'bootstrap4',
    header: {
        left: 'prev,next, today',
        center: 'title',
        right: 'agendaDay,agendaWeek,month'
    },
    titleFormat: 'D/MMM/YY',
    eventBackgroundColor: 'purple',
    weekNumbers: true,
    defaultView: 'agendaDay',
    nowIndicator: true,
    scrollTime: TimeNow,
    allDaySlot: false,
    slotMinutes: 30,
    // Clickable week number
    navLinks: true,
    // The day that each week begins
    firstDay: 1,

    minTime: "06:00:00",
    maxTime: "22:00:00",

    businessHours: [ // specify an array instead
      {
        dow: [ 1, 2, 3 ], // Monday, Tuesday, Wednesday
        start: '08:00', // 8am
        end: '20:00' // 6pm
      },
      {
        dow: [ 4, 5 ], // Thursday, Friday
        start: '08:00', // 10am
        end: '20:00' // 4pm
      }
    ],

    timeFormat: 'H(:mm)',
    // this one gives 24hour format
    slotLabelFormat: ['H:mm'],
  	axisFormat: 'h:mm',

    });
};

function clearCalendar() {
  $('#event_calendar').fullCalendar('delete'); 
  $('#event_calendar').html('');
};

$(document).on('turbolinks:load', eventCalendar);
$(document).on('turbolinks:before-cache', clearCalendar)

