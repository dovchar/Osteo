module EventsHelper
end

class ActionView::Helpers::FormBuilder
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::JavaScriptHelper

  def my_datetime_select(method, options = {})
    options['value'] = Time.now
    options['size'] = 18

    puts method
    puts @object_name
    puts tag_id(method)

    datetime_field = @template.text_field(@object_name, method, options)

    datetime_picker = javascript_tag "
      $(document).ready(function() {
        $('##{tag_id(method)}').datetimepicker({
          stepMinute: 10,
          showButtonPanel: false,
          dayNamesMin: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
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
