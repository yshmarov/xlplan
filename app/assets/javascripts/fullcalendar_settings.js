/*global $*/
/*global app*/
/*global moment*/

//to show current time in calendar
var TimeNow  = moment().format("HH") + ":00:00";



function eventCalendar() {
  return $('#event_calendar').fullCalendar({ 
    events: app.vars.appointments,

    themeSystem: 'bootstrap4',
    header: {
        right: 'prev,next, today',
        left: 'title',
        center: 'agendaDay,agendaWeek,month,listWeek'
    },
    titleFormat: 'D/MMM/YY',
    eventBackgroundColor: 'purple',

    weekNumbers: true,
    defaultView: 'agendaWeek',
    nowIndicator: true,
    scrollTime: TimeNow,
    allDaySlot: false,
    slotMinutes: 30,
    // Clickable week number
    navLinks: true,
    // Does not work
    locale: 'I18n.locale',
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

  	editable: true,
  	selectable: true,
  	selectHelper: true,
  	droppable: true, // this allows things to be dropped onto the calendar !!!
    });
};

function clearCalendar() {
  $('#calendar').fullCalendar('delete'); 
  $('#calendar').html('');
};

$(document).on('turbolinks:load', eventCalendar);
$(document).on('turbolinks:before-cache', clearCalendar)

