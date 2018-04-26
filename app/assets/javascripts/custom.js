/* global  $ */
/* global  $e */

$(document).ready(function() {
  console.log($('#calendar'));
  $('#calendar').fullCalendar({
    events:window.event_datas
  })
/*  
  $('#holiday_allday').change(function(select) {
    
    $("#aaaeee").html('1123');
    var selectedOption = select.;
    
    if (selectedOption == 1) {
      $("#start_date_hour_name").attr("disabled","disabled");
      $("#start_date_minutes_name").attr("disabled","disabled");
      $("#end_date_hour_name").attr("disabled","disabled");
      $("#end_date_minutes_name").attr("disabled","disabled");      
    } else {
      $("#start_date_hour_name").removeAttr("disabled");
      $("#start_date_minutes_name").removeAttr("disabled");
      $("#end_date_hour_name").removeAttr("disabled");
      $("#end_date_minutes_name").removeAttr("disabled");
    }
    
  });
*/
});

function checkAllday(select) {
  if (select == 'ON') {
    $("#start_date_hour_name").attr("disabled","disabled");
    $("#start_date_minutes_name").attr("disabled","disabled");
    $("#end_date_hour_name").attr("disabled","disabled");
    $("#end_date_minutes_name").attr("disabled","disabled");  
  } else {
    $("#start_date_hour_name").removeAttr("disabled");
    $("#start_date_minutes_name").removeAttr("disabled");
    $("#end_date_hour_name").removeAttr("disabled");
    $("#end_date_minutes_name").removeAttr("disabled");
  }
}

function deleteAlldayCheck() {
  $("#start_date_hour_name").removeAttr("disabled");
  $("#start_date_minutes_name").removeAttr("disabled");
  $("#end_date_hour_name").removeAttr("disabled");
  $("#end_date_minutes_name").removeAttr("disabled");
}


function eventCalendar() {
  $e = $('#calendar');
  if($e.get(0)){
    return $e.fullCalendar({events:window.event_datas});
  }
};

function clearCalendar() {
  $('#calendar').fullCalendar('delete'); // In case delete doesn't work.
  $('#calendar').html('');
};
$(document).on('turbolinks:load', eventCalendar);
$(document).on('turbolinks:before-cache', clearCalendar)
