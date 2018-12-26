/*global $*/
/*global app*/
/*global moment*/

//to show current time in calendar
var TimeNow  = moment().format("HH") + ":00:00";

function eventCalendar() {
  return $('#event_calendar').fullCalendar({ 
    events: app.vars.jobs,

    themeSystem: 'bootstrap4',
    header: {
        left: 'prev,next, today',
        center: 'title',
        right: 'agendaDay,agendaWeek,month,listWeek'
    },
    weekNumbers: true,
    defaultView: 'agendaWeek',
    nowIndicator: true,
    scrollTime: TimeNow,
    allDaySlot: false,
    slotMinutes: 30,
    // Clickable week number
    navLinks: true,
    // Does not work
    lang: 'en',
    // The day that each week begins
    firstDay: 1,

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

