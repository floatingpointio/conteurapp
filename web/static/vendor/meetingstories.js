console.log('MeetingStories');

$('.calendar').fullCalendar({
  eventSources: [{
    url: '/api/calendars/events',
    data: function() {
      var calendarId = $('.calendar').data('calendar-id');

      return {
        calendar_id: calendarId
      };
    }
  }],
  eventClick: function( calEvent, jsEvent, view ) {
    var li = '<li data-event-id="' + calEvent.id + '">' + calEvent.title + '</li>';
    $('#selected-events').append(li);
  }
});

$('#selected-events-save-btn').on('click', function( ev ) {
  ev.preventDefault();

  var body = {
    calendarId: $('#selected-events').data('calendar-id'),
    description: '...'

    // fix
    //event_ids: $('#selected-events li').map(function() { return $(this).data('event-id'); })
  };

  $.post('/api/stories', body, function() {
    console.log( arguments );
  });
});
