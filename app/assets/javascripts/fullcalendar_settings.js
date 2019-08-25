//to show current time in calendar
var TimeNow  = moment().format("HH") + ":00:00";

function eventCalendar() {
  return $('#event_calendar').fullCalendar({ 
    schedulerLicenseKey: 'GPL-My-Project-Is-Open-Source',
    // 100% height
    height: "auto",
    // render data
    events: app.vars.events,
    // events: '/events.json',
    resources: app.vars.resources,
    locale: app.vars.locale,

    selectable: true,
      selectHelper: true,
      editable: true,
      eventLimit: true,

      select: function(start, end) {
        $.getScript('/events/new', function() {
          $('#event_date_range').val(moment(start).format("MM/DD/YYYY HH:mm") + ' - ' + moment(end).format("MM/DD/YYYY HH:mm"))
          date_range_picker();
          $('.start_hidden').val(moment(start).format('YYYY-MM-DD HH:mm'));
          $('.end_hidden').val(moment(end).format('YYYY-MM-DD HH:mm'));
        });

        $('#event_calendar').fullCalendar('unselect');
      },


    viewRender: function(view, element){
        var currentdate = view.intervalStart;
        $('#datepicker').datepicker({
          todayHighlight: true,
          language: app.vars.locale
        }).datepicker('setDate', new Date(currentdate));
    },

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
