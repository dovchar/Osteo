class Time

  # Rounds the time.
  #
  # ==== Examples
  #   Time.new(2011, 11, 13, 03, 51, 00).round(10.minutes) # => 2011-11-13 03:50:00
  #   Time.new(2011, 11, 13, 13, 42, 24).round()           # => 2011-11-13 13:42:00
  #   Time.new(2011, 11, 13, 13, 42, 24).round(1.hour)     # => 2011-11-13 14:00:00
  #
  def round_time(seconds = 60)
    Time.zone.at((self.to_f / seconds).round * seconds)
  end

  # Formats a calendar event (date pair) in a human friendly way.
  #
  # Follows the same rules as in Google Calendar.
  #
  # ==== Example
  #   Time.format_datepair(
  #     Time.new(2012, 01, 31, 14, 30),
  #     Time.new(2012, 01, 31, 15, 00)
  #   ) # => Tue, January 31, 2:30pm - 3pm
  #
  # See unit tests for more examples.
  #
  # +all_day+:: can be a boolean or the symbol :all_day
  def self.format_datepair(starts_at, ends_at, all_day = false)
    # See strftime reference and sandbox http://strfti.me/
    # %a, %B %d, %Y           => Tue, January 31, 2012
    # %a, %B %d               => Tue, January 31
    # %a, %B %d, %-l:%M%P     => Tue, January 31, 11:59am
    # %a, %B %d, %-l%P        => Tue, January 31, 1pm
    # %a, %B %d, %Y, %-l:%M%P => Tue, January 31, 2012, 11:59am
    # %-l%P                   => 1pm

    # Converts to local time
    starts_at = starts_at.in_time_zone(Event::TIME_ZONE) unless starts_at.nil?
    ends_at = ends_at.in_time_zone(Event::TIME_ZONE) unless ends_at.nil?
    str = ''

    # "The en dash is commonly used to indicate a closed range of values
    # [...] such as those between dates, times, or numbers"
    # See http://en.wikipedia.org/wiki/Dash#En_dash
    range_separator = ' &ndash; '

    this_year = Time.now.year

    ends_at = starts_at if ends_at.nil?

    if starts_at.year == this_year && ends_at.year == this_year
      # Don't print the year

      if starts_at.month == ends_at.month && starts_at.day == ends_at.day
        # Same day

        if all_day || all_day == :all_day
          # All day long, don't print the time
          # Tue, January 31
          str = starts_at.strftime('%a, %B %d')
        else
          # Print the time
          # Tue, January 31, 11:59am
          # Tue, January 31, 1pm

          if starts_at.min == 0
            # Tue, January 31, 1pm
            str = starts_at.strftime('%a, %B %d, %-l%P')
          else
            # Tue, January 31, 11:59am
            str = starts_at.strftime('%a, %B %d, %-l:%M%P')
          end
          str += range_separator
          if ends_at.min == 0
            str += ends_at.strftime('%-l%P')
          else
            str += ends_at.strftime('%-l:%M%P')
          end
        end

      else
        # Different days, print ends_at part

        if all_day || all_day == :all_day
          # All day long, don't print the time
          # Tue, January 31
          str = starts_at.strftime('%a, %B %d')
          str += range_separator
          str += ends_at.strftime('%a, %B %d')
        else
          # Print the time
          if starts_at.min == 0
            # Tue, January 31, 1pm
            str = starts_at.strftime('%a, %B %d, %-l%P')
          else
            # Tue, January 31, 11:59am
            str = starts_at.strftime('%a, %B %d, %-l:%M%P')
          end
          str += range_separator
          if ends_at.min == 0
            str += ends_at.strftime('%a, %B %d, %-l%P')
          else
            str += ends_at.strftime('%a, %B %d, %-l:%M%P')
          end
        end

      end
    else
      # Print the year

      if starts_at.month == ends_at.month && starts_at.day == ends_at.day
        # Same day

        if all_day || all_day == :all_day
          # All day long, don't print the time
          # Tue, January 31, 2012
          str = starts_at.strftime('%a, %B %d, %Y')
        else
          # Print the time
          if starts_at.min == 0
            # Tue, January 31, 2012, 1pm
            str = starts_at.strftime('%a, %B %d, %Y, %-l%P')
          else
            # Tue, January 31, 2012, 11:59am
            str = starts_at.strftime('%a, %B %d, %Y, %-l:%M%P')
          end
          str += range_separator
          if ends_at.min == 0
            str += ends_at.strftime('%-l%P')
          else
            str += ends_at.strftime('%-l:%M%P')
          end
        end

      else
        # Different days

        if all_day || all_day == :all_day
          # All day long, don't print the time
          # Tue, January 31, 2012
          str = starts_at.strftime('%a, %B %d, %Y')
          str += range_separator
          if starts_at.year == ends_at.year
            str += ends_at.strftime('%a, %B %d')
          else
            str += ends_at.strftime('%a, %B %d, %Y')
          end
        else
          # Print the time
          if starts_at.min == 0
            # Tue, January 31, 2012, 1pm
            str = starts_at.strftime('%a, %B %d, %Y, %-l%P')
          else
            # Tue, January 31, 2012, 11:59am
            str = starts_at.strftime('%a, %B %d, %Y, %-l:%M%P')
          end
          str += range_separator
          if ends_at.min == 0
            if starts_at.year == ends_at.year
              str += ends_at.strftime('%a, %B %d, %-l%P')
            else
              str += ends_at.strftime('%a, %B %d, %Y, %-l%P')
            end
          else
            if starts_at.year == ends_at.year
              str += ends_at.strftime('%a, %B %d, %-l:%M%P')
            else
              str += ends_at.strftime('%a, %B %d, %Y, %-l:%M%P')
            end
          end
        end

      end
    end

    return str
  end

end
