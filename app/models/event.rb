class Event < ActiveRecord::Base

  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validate :validate_ends_at_after_starts_at

  after_initialize :init

  # Need to override the JSON view to return what FullCalendar is expecting.
  # See http://arshaw.com/fullcalendar/docs/event_data/Event_Object/
  def as_json(options = nil)
    {
      id: id,
      title: title,
      description: description,
      start: starts_at, # ISO 8601, ex: "2011-10-28T01:22:00Z"
      end: ends_at,
      allDay: all_day
    }
  end

  # Returns the event title.
  # Returns '(No title)' if the title does not exist inside the database.
  # TODO Translation + move this to view?
  def title
    title = read_attribute(:title)
    title.blank? ? '(No title)' : title
  end

  private

  # Initializes the attributes with default values.
  # See http://stackoverflow.com/questions/328525/what-is-the-best-way-to-set-default-values-in-activerecord
  def init
    self.starts_at ||= Time.now
    self.ends_at ||= Time.now + 1.hour
  end

  def validate_ends_at_after_starts_at
    if starts_at && ends_at
      errors.add(:ends_at, "can't be before the starting date") if ends_at < starts_at
    end
  end
end
