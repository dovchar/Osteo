module EventsHelper

  # Add new field types to form helpers
  class ActionView::Helpers::FormBuilder
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::JavaScriptHelper

    # Same as datetime_select but uses jQuery UI.
    #
    # Creates two text fields:
    # - one for the date ("28/11/2011") that uses jQuery UI datepicker
    # - one for the time ("22:00") that uses jQuery UI timepicker add-on
    # Unobtrusive JavaScript: if disabled, the two text fields will still work.
    #
    def jquery_datetime_select(method, time = Time.now, date_options = {}, time_options = {})
      date_options[:value] = time.strftime('%Y-%m-%d')
      date_options[:size] = 10
      date_options[:maxlength] = 10
      date_field = @template.text_field(@object_name, "#{method}_date", date_options)

      time_options[:value] = time.round(10.minutes).strftime('%R')
      time_options[:size] = 5
      time_options[:maxlength] = 5
      time_field = @template.text_field(@object_name, "#{method}_time", time_options)

      jquery_ui = javascript_tag "
        $(document).ready(function() {

          $('##{field_id(method, 'date')}').datepicker({
            dayNamesMin: ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
            dateFormat: 'dd/mm/yy'
          });

          $('##{field_id(method, 'time')}').timepicker({
            stepMinute: 10,
            showButtonPanel: false,
          });
        });"

      return date_field + time_field + jquery_ui
    end

    private

    def field_id(method, label)
      return "#{@object_name}_#{method}_#{label}"
    end
  end
end

# FIXME Should be moved somewhere else
class Time

  # Parses the params generated when using jquery_datetime_select inside the view.
  #
  # Should be used inside the controller.
  # Example:
  #
  #     # View
  #     <%= form_for(@my_model) do |f| %>
  #       <%= f.jquery_datetime_select :my_field_name %>
  #     <% end %>
  #
  #     # Controller
  #     class MyController < ApplicationController
  #       def create
  #         Time.parse_jquery_datetime_select(params, :my_model, :my_field_name)
  #         @my_model = MyModel.new(params[:my_model])
  #         [...]
  #       end
  #     end
  #
  def self.parse_jquery_datetime_select(params, model, field)
    str = params["#{model}"]["#{field}_date"] + ' ' + params["#{model}"]["#{field}_time"]
    params["#{model}"]["#{field}"] = Time.parse(str)
    params["#{model}"].delete("#{field}_date")
    params["#{model}"].delete("#{field}_time")
  end

  def round(seconds = 60)
    Time.at((to_f / seconds).round * seconds)
  end

  def floor(seconds = 60)
    Time.at((to_f / seconds).floor * seconds)
  end
end
