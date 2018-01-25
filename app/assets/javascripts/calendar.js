$(document).on('click','#calendar_names',calEvents)

selectedCalID = [];
myEvents = [];

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
      if ($('input#calendar_names:checked').length > 1 ) {
        alert("Only one calendar can be selected to create new event")
      } else if ($('input#calendar_names:checked').length < 1 ) {
        alert("Please select calendar to enter an event for")
      } else {
        var calendarId = $('input[type="checkbox"]#calendar_names:checked').data('id');
        var eventColor = $('input[type="checkbox"]#calendar_names:checked').data('color');
        var startTime = moment(start).format('L');
        var eventTitle = $('input[type="checkbox"]#calendar_names:checked').data('name');
        $('#eventModal').modal('show');
        $('input#scheduled_event_start_time').val(moment(start).format('L'));
        $('#scheduled_event_calendar_id').val(calendarId);
        $('#scheduled_event_color').val(eventColor);
        $('#calendar-event-title').text('Event for '+eventTitle);
      }
    }
  })
  
  $('.list-container').each(function() {
    var span = $(this).find('.checkmark');
    var color = $(this).find('#calendar_names').data('color');
    var checkbox = $(this).find('input');
    span.css('background-color',color);
  })
}

function checkMyEvents() {
  if (localStorage.myEvents) {
    events = localStorage.getItem('myEvents');
    events = JSON.parse(events);
    events.map((e)=> {
      $('[data-id~='+e+']').prop('checked', true);
      myEvents.push(e)
    });
    myCalendarEvents(events);
  }
}

function calEvents() {
  $(this).each(function() {
    if ($(this).is(':checked')) {
      myEvents.push($(this).data('id'))
    } else {
      removeA(myEvents, $(this).data('id'))
    }
    localStorage.setItem("myEvents",JSON.stringify(myEvents));
    var selectedEvents = JSON.parse(localStorage.getItem("myEvents"));
    myCalendarEvents(selectedEvents);
  });
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

function setCalendarCheckbox() {
  if ($('input#calendar_names')) {
    $('input#calendar_names').last().click();
  }
}

function myCalendarEvents(events) {
  // Clears events from calendar
  $('#calendar').fullCalendar('removeEvents');
  // Prevents duplicate events from being passed
  events = $.unique(events);
  events.map((e)=> {
    // Fetches data from controller
    $.ajax({
      type: "GET",
      dataType:'script',
      url: "/exchanges/scheduled_events/get_calendar_events?id="+e,
      success: function(data) {
        // Add events to calendar
        $('#calendar').fullCalendar('renderEvents', JSON.parse(data), true)
      }
    });
  });
}

// removes item from array
function removeA(arr) {
  var what, a = arguments, L = a.length, ax;
  while (L > 1 && arr.length) {
    what = a[--L];
    while ((ax= arr.indexOf(what)) !== -1) {
      arr.splice(ax, 1);
    }
  }
  return arr;
}

// Removes items from localStorage when leaving page
$( window ).unload(function() {
  resetSelectCalID()
});

