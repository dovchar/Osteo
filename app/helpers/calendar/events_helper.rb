module Calendar
  module EventsHelper

    # Returns an HTML string for the given date pair.
    #
    # See Time#format_datepair
    # See DateHelper#time_tag
    #
    # ==== Example
    #   datepair_tag @event.starts_at, @event.ends_at, @event.all_day
    #   # => 'Tue, January 31, 2:30pm &ndash; 3pm'
    #
    def datepair_tag(starts_at, ends_at, all_day)
      raw "#{Time.format_datepair(starts_at, ends_at, all_day)}"
    end
  end
end
