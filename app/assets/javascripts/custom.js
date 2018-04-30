/* global  $ */
/* global  $e */

$(document).ready(function() {
  console.log($('#calendar'));
  $('#calendar').fullCalendar({
    events:window.event_datas,

    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,agendaDay'
    },

    // ボタン文字列
    buttonText: {
        prev:     '<', // <
        next:     '>', // >
        prevYear: '<<',  // <<
        nextYear: '>>',  // >>
        today:    '今日',
        month:    '月',
        week:     '週',
        day:      '日'
    },

    // 月名称
    monthNames: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
    // 月略称
    monthNamesShort: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
    // 曜日名称
    dayNames: ['日曜日', '月曜日', '火曜日', '水曜日', '木曜日', '金曜日', '土曜日'],
    // 曜日略称
    dayNamesShort: ['日', '月', '火', '水', '木', '金', '土'],

    navLinks: true,
    selectable: true,
    selectHelper: true,
    events:window.event_datas,

    select: function(start, end) {

      var select_date = new Date(start);
      var select_date = select_date.getFullYear() + '年' + (select_date.getMonth()+1) + '月' + select_date.getDate() + '日'

      $("#date_arg").html(select_date);
      $("#holiday_start_datetime").val(select_date);
      $('.modal').modal();

    },

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
