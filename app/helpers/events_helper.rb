module EventsHelper
end

# FIXME Should be moved somewhere else
class Time
  def round(seconds = 60)
    Time.at((to_f / seconds).round * seconds)
  end

  def floor(seconds = 60)
    Time.at((to_f / seconds).floor * seconds)
  end
end

class ActionView::Helpers::FormBuilder
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::JavaScriptHelper

  def jquery_datetime_select(method, time, date_options = {}, time_options = {})
    date_options[:value] = time.strftime('%Y-%m-%d')
    date_options[:size] = 10
    date_options[:maxlength] = 10
    date_field = @template.text_field(@object_name, "#{method}_date", date_options)

    time_options[:value] = time.round(10.minutes).strftime('%R')
    time_options[:size] = 5
    time_options[:maxlength] = 5
    time_field = @template.text_field(@object_name, "#{method}_time", time_options)

    jquery = javascript_tag "
      $(document).ready(function() {

        $('##{tag_id(method, 'date')}').datepicker({
          dayNamesMin: ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
          dateFormat: 'dd/mm/yy'
        });

        $('##{tag_id(method, 'time')}').timepicker({
          stepMinute: 10,
          showButtonPanel: false,
        });
      });"

    return date_field + time_field + jquery
  end

  private

  def tag_id(method, label)
    return "#{@object_name}_#{method}_#{label}"
  end
end
