/*global $*/
/*global app*/
/*global moment*/

// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require rails-ujs
//= require selectize
//= require cocoon
//= require bootstrap-datepicker
//= require activestorage
//= require turbolinks
//= require_tree .
//= require popper
//= require bootstrap-sprockets
//= require moment 
//= require fullcalendar


var TimeNow  = moment().format("HH") + ":00:00";



function clearCalendar() {
  $('#calendar').fullCalendar('delete'); 
  $('#calendar').html('');
};

$(document).on('turbolinks:load', function(){


    $('#calendar').fullCalendar({ 
        lang: 'en',
        defaultView: 'agendaWeek',
        firstDay: 1,
        nowIndicator: true,
        timeFormat: 'H(:mm)',
        scrollTime: TimeNow,
        allDaySlot: false,
        slotMinutes: 30,
        events: app.vars.jobs,
        header: {
            center: 'month,agendaWeek,agendaDay'
        }
    });
    
    $('#dailycalendar').fullCalendar({ 
        lang: 'en',
        defaultView: 'agendaDay',
        firstDay: 1,
        nowIndicator: true,
        timeFormat: 'H(:mm)',
        scrollTime: TimeNow,
        allDaySlot: false,
        slotMinutes: 30,
        events: app.vars.jobs,
    });




    $('form').on('cocoon:after-insert', function(e, addedItem) {
      $(addedItem).find('.selectize').selectize({
        sortField: 'text'
      })
    });

    $("#service_category a.add_fields").
      data("association-insertion-position", 'before').
      data("association-insertion-node", 'this');

     $('#service_category').bind('cocoon:after-insert',
         function() {
           $("#service_category_from_list").hide();
           $("#service_category a.add_fields").hide();
         });
    $('#service_category').bind("cocoon:after-remove",
         function() {
           $("#service_category_from_list").show();
           $("#service_category a.add_fields").show();
         });
     //$('body').tabs();


    $(function () {
      $('[data-toggle="tooltip"]').tooltip()
    })

  if ($('.selectize')){
      $('.selectize').selectize({
          sortField: 'text'
      });
  }


	$('.datepicker').datepicker({
     orientation: 'auto bottom',
     format: 'yyyy-mm-dd'
	});
 	$('.input-daterange').datepicker({
     orientation: 'auto bottom',
     format: 'yyyy-mm-dd'
    });

  eventCalendar();  
});
$(document).on('turbolinks:before-cache', clearCalendar);

