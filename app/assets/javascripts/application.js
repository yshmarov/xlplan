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
//= require moment
// If you require timezone data (see moment-timezone-rails for additional file options)
//= require moment-timezone-with-data
//= require tempusdominus-bootstrap-4

//= require activestorage
//= require turbolinks
//= require popper
//= require bootstrap-sprockets

//= require fullcalendar
//= require fullcalendar/locale-all
//= require Chart.bundle
//= require chartkick

//= require fullcalendar_settings

$(document).on('turbolinks:load', function(){


  $(function () {
    $('[data-toggle="tooltip"]').tooltip()
  })

  if ($('.selectize')){
      $('.selectize').selectize({
          sortField: 'text'
      });
  }

  $('form').on('cocoon:after-insert', function(e, addedItem) {
    $(addedItem).find('.selectize').selectize({
      sortField: 'text'
    })
  });

	$('.datepicker').datepicker({
     orientation: 'auto bottom',
     format: 'yyyy-mm-dd',
	});
 	
 	$('.input-daterange').datepicker({
    orientation: 'auto bottom',
    format: 'yyyy-mm-dd',
    autoclose: true,
    todayHighlight:'TRUE',
    });

  $(".selectize-category").selectize({
    create: function(input, callback) {
      $.post('/service_categories.json', { service_category: { name: input } })
        .done(function(response){
          console.log(response)
          callback({value: response.id, text: response.name });
        })
    }
    });

    $(function () {
      $('#datetimepicker').datetimepicker({
        inline: true,
        sideBySide: true,
        stepping: 15,
        format : 'DD/MM/YYYY HH:mm'
        });
    });

});
