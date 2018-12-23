/*global $*/
/*global app*/
/*global moment*/

//to show current time in calendar
var TimeNow  = moment().format("HH") + ":00:00";

function eventCalendar() {
  return $('#event_calendar').fullCalendar({ 
    themeSystem: 'bootstrap4',
    header: {
        left: 'prev,next today',
        center: 'title',
        right: 'agendaDay,agendaWeek,month,listWeek'
    },
    navLinks: true,
    lang: 'en',
    weekNumbers: true,
    defaultView: 'agendaWeek',
    firstDay: 1,
    nowIndicator: true,
    timeFormat: 'H(:mm)',
    scrollTime: TimeNow,
    allDaySlot: false,
    slotMinutes: 30,
    events: app.vars.jobs,
  	editable: true,
  	selectable: true,
  	axisFormat: 'h:mm',
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

