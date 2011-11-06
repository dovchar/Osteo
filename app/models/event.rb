class Event < ActiveRecord::Base

  validates :title, :presence => true
  validates :starts_at, :presence => true
  validates :ends_at, :presence => true
  validate :validate_ends_at_after_starts_at

  DEFAULT_TITLE = "Untitled event"

  # Need to override the JSON view to return what FullCalendar is expecting.
  # See http://arshaw.com/fullcalendar/docs/event_data/Event_Object/
  def as_json(options = nil)
    {
      id: id,
      title: title,
      description: description,
      start: starts_at, # ISO 8601, ex: "2011-10-28T01:22:00Z"
      end: ends_at,
      allDay: all_day,
      url: Rails.application.routes.url_helpers.event_path(id)
    }
  end

  private

  def validate_ends_at_after_starts_at
    if starts_at && ends_at
      errors.add(:ends_at, "can't be before the starting date") if ends_at < starts_at
    end
  end
end
