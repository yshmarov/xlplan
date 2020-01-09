//to show current time in calendar
var TimeNow  = moment().format("HH") + ":00:00";

function eventCalendar() {
  return $('#event_calendar').fullCalendar({ 
    schedulerLicenseKey: 'CC-Attribution-NonCommercial-NoDerivatives',
    // 100% height
    height: "auto",
    // render data
    events: app.vars.events,
    // events: '/events.json',
    resources: app.vars.resources,
    locale: app.vars.locale,
    longPressDelay: 300,
    selectable: true,
    selectHelper: true,
    
    resourceGroupField: 'location',
    resourceAreaWidth: '100px',
    resourceLabelText: "#",
    
    select: function(start) {
      $.getScript('/events/new', function() {
        //initialize selectize
        if ($('.selectize')){
            $('.selectize').selectize({
                sortField: 'text'
            });
        };
        
        //initialize datetimepicker
        $('#datetimepicker').datetimepicker({
          locale: app.vars.locale,
          inline: true,
          'date': moment(start).format("MM/DD/YYYY HH:mm"),
          sideBySide: true,
          stepping: 15,
          ignoreReadonly: true,
          allowInputToggle: true,
          format : 'DD/MM/YYYY HH:mm'
          });
      });

      $('#event_calendar').fullCalendar('unselect');
    },

    // sidebar small calendar to pick a date
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
        left: 'prev,today,next',
        center: 'title',
        right: 'list,timelineDay,agendaDay,agendaWeek,month'
    },
    buttonText: {
      today: '⬤',
      list:     '1≡',
      timelineDay:     '1⇉',
      agendaDay:     '1⇊',
      agendaWeek:     '7',
      month:     '30'
    },
    slotDuration: '00:30:00', 
    titleFormat: 'ddd D MMM',
    eventBackgroundColor: 'purple',
    weekNumbers: true,
    //defaultView: 'timelineDay',
    //defaultView: $(window).width() < 765 ? 'agendaWeek':'month',

    // if small window & 1 member = agendaDay
    // if small window & more members = timelineDay
    // if big window & 1 member = agendaDay
    // if big window & more members = agendaDay
    defaultView: (function () 
    { 
      if ($(window).width() <= 1080 && app.vars.memberquantity > 1) 
          { return defaultView = 'timelineDay'; } 
      else { return defaultView = 'agendaDay'; } 
    }
    )(),
    nowIndicator: true,
    scrollTime: TimeNow,
    allDaySlot: false,
    // Clickable week number
    navLinks: true,
    // The day that each week begins
    firstDay: 1,

    minTime: "07:00:00",
    maxTime: "23:00:00",

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

$(window).resize(function() {
  if(app.vars.memberquantity > 1){
    if(window.innerWidth < 1080){
      $('#event_calendar').fullCalendar('changeView', 'timelineDay');
    } else {
      $('#event_calendar').fullCalendar('changeView', 'agendaDay');
    }
  }
});
