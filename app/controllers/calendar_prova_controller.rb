class CalendarProvaController < ApplicationController
  def calendar
    cal = Inline::Application.config.cal
    
    @event_list = cal.list_events(Rails.application.secrets.google_calendar_id)
  end

  def event
    cal = Inline::Application.config.cal
    today = Date.today

    event = Google::Apis::CalendarV3::Event.new({
      start: Google::Apis::CalendarV3::EventDateTime.new(date: today),
      end: Google::Apis::CalendarV3::EventDateTime.new(date: today + 1),
      summary: 'New event!'
    })

    cal.insert_event(Rails.application.secrets.google_calendar_id, event)

    redirect_to calendar_url
  end
end
