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

  def to_html_format
    strftime('%m/%d/%Y %R')
  end
end

class ActionView::Helpers::FormBuilder
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::JavaScriptHelper

  def my_datetime_select(method, options = {})
    options['value'] = Time.now.round(10.minutes).to_html_format
    options['size'] = 18

    datetime_field = @template.text_field(@object_name, method, options)

    datetime_picker = javascript_tag "
      $(document).ready(function() {
        $('##{tag_id(method)}').datetimepicker({
          stepMinute: 10,
          showButtonPanel: false,
          dayNamesMin: ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
          dateFormat: 'dd/mm/yy'
        });
      });"

    return datetime_field + datetime_picker
  end

  private

  # Copy-pasted from ActionView::Helpers::InstanceTag
  def tag_id(method)
    "#{sanitized_object_name}_#{sanitized_method_name(method)}"
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
