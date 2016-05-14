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
  }]
});
