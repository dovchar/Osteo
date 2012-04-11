module EventsHelper

  # Returns an HTML string for the given event.
  #
  # See Time#to_event_format
  # See DateHelper#time_tag
  #
  # ==== Examples
  #   event_time_tag @event.starts_at, @event.ends_at, @event.all_day
  #   # => 'Tue, January 31, 2:30pm &ndash; 3pm'
  #
  def event_time_tag(starts_at, ends_at, all_day = false)
    raw "#{Time.to_event_format(starts_at, ends_at, all_day)}"
  end
end

module ActionView
  module Helpers
    module FormHelper

      # Same as datetime_select but uses jQuery UI.
      #
      # See DateHelper#datetime_select
      #
      # Creates two text fields:
      # - one for the date ("2011-11-28") that uses jQuery UI datepicker
      # - one for the time ("22:00") that uses jQuery UI timepicker add-on
      # Unobtrusive JavaScript: if disabled, the two text fields will still work.
      #
      # TODO Move to a gem
      def event(object_name, event)
        starts_at_field = jquery_datetime_select object_name, :starts_at, :date_before_time, event.starts_at,
                                                 { title: "From date" }, { title: "From time" }

        ends_at_field = jquery_datetime_select object_name, :ends_at, :time_before_date, event.ends_at,
                                               { title: "Until date" }, { title: "Until time" }

        all_day_check_box = check_box object_name, :all_day
        all_day_label = label object_name, :all_day

        js = javascript_tag "
          $(document).ready(function() {
            all_day = $('##{field_id(object_name, :all_day)}');
            all_day.change(function() {
              starts_at_time = $('##{field_id(object_name, :starts_at, 'time')}');
              ends_at_time = $('##{field_id(object_name, :ends_at, 'time')}');
              if (all_day.prop('checked')) {
                starts_at_time.hide();
                ends_at_time.hide();
              } else {
                starts_at_time.show();
                ends_at_time.show();
              }
            });
          });"

        return starts_at_field + ends_at_field + all_day_check_box + all_day_label + js
      end

      def jquery_datetime_select(object_name, method, order = :date_before_time, time = Time.now, date_options = {}, time_options = {})
        time = time.round(Event::STEP_MINUTE.minutes)

        date_options[:value] = time.strftime('%Y-%m-%d')
        date_options[:size] = 10
        date_options[:maxlength] = 10
        date_options[:autocomplete] = :off
        date_field = text_field(object_name, "#{method}_date", date_options)

        time_options[:value] = time.strftime('%R')
        time_options[:size] = 5
        time_options[:maxlength] = 5
        time_options[:autocomplete] = :off
        time_field = text_field(object_name, "#{method}_time", time_options)

        jquery_ui = javascript_tag "
          $(document).ready(function() {

            $('##{field_id(object_name, method, 'date')}').datepicker({
              dayNamesMin: ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
              dateFormat: 'yy-mm-dd'
            });

            $('##{field_id(object_name, method, 'time')}').timepicker({
              stepMinute: #{Event::STEP_MINUTE},
              showButtonPanel: false,
            });
          });"

        if order == :date_before_time
          return date_field + time_field + jquery_ui
        else
          return time_field + date_field + jquery_ui
        end
      end

      private

      def field_id(object_name, method, label = nil)
        if label
          return "#{object_name}_#{method}_#{label}"
        else
          return "#{object_name}_#{method}"
        end
      end
    end
  end
end

class ActionView::Helpers::FormBuilder
  def event
    @template.event(@object_name, @object)
  end
end

# TODO Should be moved somewhere else
class Time

  # Parses the params generated by jquery_datetime_select helper.
  #
  # jquery_datetime_select returns two fields #{my_field}_date and #{my_field}_time
  # instead of serializing params into a Time object directly as would do
  # the standard Rails datetime helper. I don't know how to make it transparent :/
  #
  # Should be used inside the controller.
  #
  # ==== Examples
  #   # View
  #   <%= form_for(@my_model) do |f| %>
  #     <%= f.jquery_datetime_select :my_field %>
  #   <% end %>
  #
  #   # Controller
  #   class MyController < ApplicationController
  #     def create
  #       Time.parse_jquery_datetime_select(params, :my_model, :my_field)
  #       @my_model = MyModel.new(params[:my_model])
  #       # [...]
  #     end
  #   end
  #
  def self.parse_jquery_datetime_select(params, model, field)
    date = params["#{model}"]["#{field}_date"]
    time = params["#{model}"]["#{field}_time"]

    begin
      str = date + ' ' + time
      params["#{model}"]["#{field}"] = Time.parse(str)
    rescue
      # Variables date and time can be nil in case JavaScript
      # is not used (for example when running the tests)

      # Variables date and time can contain unparseable text,
      # Time.parse will then fail
    end

    params["#{model}"].delete("#{field}_date")
    params["#{model}"].delete("#{field}_time")
  end

  # Rounds the time.
  #
  # ==== Examples
  #   Time.new(2011, 11, 13, 03, 51, 00).round(10.minutes) # => 2011-11-13 03:50:00
  #   Time.new(2011, 11, 13, 13, 42, 24).round()           # => 2011-11-13 13:42:00
  #   Time.new(2011, 11, 13, 13, 42, 24).round(1.hour)     # => 2011-11-13 14:00:00
  #
  def round(seconds = 60)
    Time.at((to_f / seconds).round * seconds)
  end

  # Formats a calendar event in a human friendly way.
  #
  # Follows the same rules as in Google Calendar.
  #
  # ==== Examples
  #   Time.to_event_format(
  #     Time.new(2012, 01, 31, 14, 30),
  #     Time.new(2012, 01, 31, 15, 00)
  #   ) # => Tue, January 31, 2:30pm - 3pm
  #
  # See unit tests for more examples.
  #
  # +all_day+:: can be a boolean or the symbol :all_day
  def self.to_event_format(starts_at, ends_at, all_day = false)
    # See strftime reference and sandbox http://strfti.me/
    # %a, %B %d, %Y          => Tue, January 31, 2012
    # %a, %B %d              => Tue, January 31
    # %a, %B %d, %l:%M%P     => Tue, January 31, 11:59am
    # %a, %B %d, %l%P        => Tue, January 31,  1pm
    # %a, %B %d, %Y, %l:%M%P => Tue, January 31, 2012, 11:59am
    # %l%P                   =>  1pm

    # Converts to local time
    starts_at = starts_at.localtime unless starts_at.nil?
    ends_at = ends_at.localtime unless ends_at.nil?
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
            str = starts_at.strftime('%a, %B %d, %l%P')
          else
            # Tue, January 31, 11:59am
            str = starts_at.strftime('%a, %B %d, %l:%M%P')
          end
          str += range_separator
          if ends_at.min == 0
            str += ends_at.strftime('%l%P')
          else
            str += ends_at.strftime('%l:%M%P')
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
            str = starts_at.strftime('%a, %B %d, %l%P')
          else
            # Tue, January 31, 11:59am
            str = starts_at.strftime('%a, %B %d, %l:%M%P')
          end
          str += range_separator
          if ends_at.min == 0
            str += ends_at.strftime('%a, %B %d, %l%P')
          else
            str += ends_at.strftime('%a, %B %d, %l:%M%P')
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
            str = starts_at.strftime('%a, %B %d, %Y, %l%P')
          else
            # Tue, January 31, 2012, 11:59am
            str = starts_at.strftime('%a, %B %d, %Y, %l:%M%P')
          end
          str += range_separator
          if ends_at.min == 0
            str += ends_at.strftime('%l%P')
          else
            str += ends_at.strftime('%l:%M%P')
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
            str = starts_at.strftime('%a, %B %d, %Y, %l%P')
          else
            # Tue, January 31, 2012, 11:59am
            str = starts_at.strftime('%a, %B %d, %Y, %l:%M%P')
          end
          str += range_separator
          if ends_at.min == 0
            if starts_at.year == ends_at.year
              str += ends_at.strftime('%a, %B %d, %l%P')
            else
              str += ends_at.strftime('%a, %B %d, %Y, %l%P')
            end
          else
            if starts_at.year == ends_at.year
              str += ends_at.strftime('%a, %B %d, %l:%M%P')
            else
              str += ends_at.strftime('%a, %B %d, %Y, %l:%M%P')
            end
          end
        end

      end
    end

    # strftime %l inserts a blank character, let's remove it
    # Replaces every two blanks by one
    str.gsub!('  ', ' ')

    return str
  end

end
