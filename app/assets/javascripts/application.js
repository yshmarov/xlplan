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
//= require scheduler

$(document).on('turbolinks:load', function(){

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
      locale: app.vars.locale,
      inline: true,
      sideBySide: true,
      stepping: 15,
      ignoreReadonly: true,
      allowInputToggle: true,
      format : 'DD/MM/YYYY HH:mm'
      });
  });

  $("#datepicker").datepicker({
      weekStart:1,
      format: "dd.mm.yyyy",
      todayBtn: "linked",
      autoclose: true,
      todayHighlight: true,
      gotoCurrent: true,
      autoSize: true
  })
  .on('changeDate', function(ev){
      $('#event_calendar').fullCalendar('gotoDate', ev.date);
  });

});