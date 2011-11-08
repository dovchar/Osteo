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
    date_options['value'] = time.strftime('%d/%m/%Y')
    date_options['size'] = 8
    date_options['index'] = 'date'
    date_field = @template.text_field(@object_name, method, date_options)

    time_options['value'] = time.round(10.minutes).strftime('%R')
    time_options['size'] = 3
    time_options['index'] = 'time'
    time_field = @template.text_field(@object_name, method, time_options)

    javascript = javascript_tag "
      $(document).ready(function() {

        $('##{tag_id_with_index(method, date_options['index'])}').datepicker({
          dayNamesMin: ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
          dateFormat: 'dd/mm/yy'
        });

        $('##{tag_id_with_index(method, time_options['index'])}').timepicker({
          stepMinute: 10,
          showButtonPanel: false,
        });
      });"

    return date_field + time_field + javascript
  end

  private

  # Copy-pasted from ActionView::Helpers::InstanceTag
  def tag_id(method)
    "#{sanitized_object_name}_#{sanitized_method_name(method)}"
  end

  # Copy-pasted from ActionView::Helpers::InstanceTag
  def tag_id_with_index(method, index)
    "#{sanitized_object_name}_#{index}_#{sanitized_method_name(method)}"
  end

  # Copy-pasted from ActionView::Helpers::InstanceTag
  def sanitized_object_name
    @object_name.gsub(/\]\[|[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")
  end

  # Copy-pasted from ActionView::Helpers::InstanceTag
  def sanitized_method_name(method)
    method.to_s.sub(/\?$/,"")
  end
end
