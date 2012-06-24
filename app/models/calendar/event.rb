module Calendar
  class Event < ActiveRecord::Base

    # Allow mass-assignment
    attr_accessible :title, :starts_at, :ends_at, :all_day, :description, :location, :created_at, :updated_at, :color

    validates :starts_at, presence: true
    validates :ends_at, presence: true
    validates :all_day, :inclusion => { :in => [true, false] } # See http://stackoverflow.com/questions/3608076/rails-how-do-i-validate-that-something-is-a-boolean
    validate :validate_ends_at_after_starts_at

    after_initialize :default_values

    # Gets all events ending after a given date
    scope :ending_after, lambda { |date| where("ends_at > ?", date) }

    # Gets all events starting before a given date
    scope :starting_before, lambda { |date| where("starts_at < ?", date) }

    # Frequency for displaying time slots, in minutes.
    # Used by FullCalendar and jQuery timepicker.
    STEP_MINUTE = 30

    # Event length in minutes.
    EVENT_LENGTH = 60

    # Time zone to use inside the views
    TIME_ZONE = 'Paris'

    # Date format to use inside the views.
    DATE_FORMAT = '%Y-%m-%d'
    DATE_FORMAT_PICKER = 'yy-mm-dd' # See http://jqueryui.com/demos/datepicker/

    # Time format to use inside the views.
    TIME_FORMAT = '%I:%M%P'
    TIME_FORMAT_PICKER = 'h:ia' # See https://github.com/jonthornton/jquery-timepicker

    # First day of the week for FullCalendar.
    # 0 means sunday
    # 1 means monday
    FIRST_DAY_OF_WEEK = 0

    # Available colors for an event.
    # Taken from Google Calendar.
    COLORS = {
      green:       '#7bd148',
      bold_blue:   '#5484ed',
      blue:        '#a4bdfc',
      turquoise:   '#46d6db',
      light_green: '#7ae7bf',
      bold_green:  '#51b749',
      yellow:      '#fbd75b',
      orange:      '#ffb878',
      red:         '#ff887c',
      bold_red:    '#dc2127',
      purple:      '#dbadff',
      gray:        '#e1e1e1'
    }

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
        color: color
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
    # See http://stackoverflow.com/questions/1550688/how-do-i-create-a-default-value-for-attributes-in-rails-activerecords-model
    # See http://stackoverflow.com/questions/1186400/correct-way-to-set-default-values-in-rails
    def default_values
      now = Time.now.round_time(STEP_MINUTE.minutes)
      self.starts_at ||= now
      self.ends_at ||= now + EVENT_LENGTH.minutes
      self.all_day ||= false
      self.color ||= COLORS[:green]
    end

    def validate_ends_at_after_starts_at
      if starts_at && ends_at
        errors.add(:ends_at, "can't be before the starting date") if ends_at < starts_at
      end
    end
  end
end
