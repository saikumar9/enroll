//$(document).on('click','.interaction-click-control-calendar',calendarInit)
$(document).on('click','#calendar_names',loadEvents)
selectedCalID = [];
calendarEvents = [];

function loadCalendar() {
  setTimeout(function() {
    calendarInit();
  },250);
}


function calendarInit() {
  $('#calendar').fullCalendar({
    header: {
      left: 'title',
      right: 'prev today next'
    },
    defaultView: 'month',
    fixedWeekCount: false,
    height: 630,
    selectable: true,
    select: function(start, end) {
      var calendarId = $('input[type="checkbox"]#calendar_names:checked').data('id');
      var startTime = moment(start).format('L');
      $('#eventModal').modal('show');
      $('input#scheduled_event_start_time').val(moment(start).format('L'));
      $('#scheduled_event_calendar_id').val(calendarId);
    }
  })
  
  $('.list-container').each(function() {
    var span = $(this).find('.checkmark');
    var color = $(this).find('#calendar_names').data('color');
    var checkbox = $(this).find('input');
    span.css('background-color',color);
  })
  
  setTimeout(function(){
    setCalendarCheckbox()
  },200);
}

function loadEvents() {
  // Sets color for calendar header
  var color = $(this).data('color');
  setCalendarHeader(color);
  // Prevents multiple selections
  $('input[type="checkbox"]#calendar_names').not(this).prop("checked", false);
  // Ensures atleast one checkbox is selected
  if (!$(this).is(':checked')) {
    $(this).prop("checked", true);
  }
  // Gets id from selected checkbox
  getSelectedCheckboxID($(this));
  // Loads events into calendar
  getCalendarEvents()
}

function setCalendarHeader(color) {
  $('.fc-widget-header').css('background', color)
}

function getSelectedCheckboxID(element) {
  resetSelectCalID();
  var calID = element.data('id');
  // Sets Calendar ID to localStorage
  localStorage.setItem("calendarId", calID);
}

function resetSelectCalID() {
  localStorage.removeItem("calendarId");
}

function resetCalendarEvents() {
  calendarEvents = []
}

function setCalendarCheckbox() {
  if (localStorage.calendarId) {
    // Sets calendar ID to be used on refreshes
    $('[data-id~='+localStorage.calendarId+']').click();
  } else {
    if ($('input#calendar_names')) {
      $($('input#calendar_names')).first().click();
    }
  }
  
  // Need to clear local storage when browser window is closed
}
function getCalendarEvents() {
  var calendarId = localStorage.getItem('calendarId');
  resetCalendarEvents();
  // Fetches data from controller
  $.ajax({
    type: "GET",
    dataType:'script',
    url: "/exchanges/scheduled_events/get_calendar_events?id="+calendarId,
    success: function(data) {
      // Clears events from calendar
      $('#calendar').fullCalendar('removeEvents')
      // Add events to calendar
      $('#calendar').fullCalendar('renderEvents', JSON.parse(data), true)
      calendarEvents.push(JSON.parse(data));
    }
  });
  
}

