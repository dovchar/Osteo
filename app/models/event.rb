class Event < ActiveRecord::Base

  # Need to override the JSON view to return what FullCalendar is expecting.
  # See http://arshaw.com/fullcalendar/docs/event_data/Event_Object/
  def as_json(options = nil)
    {
      :id => id,
      :title => title,
      :description => description,
      :start => starts_at,
      :end => ends_at,
      :allDay => all_day,
      :url => Rails.application.routes.url_helpers.event_path(id)
    }
  end
end
