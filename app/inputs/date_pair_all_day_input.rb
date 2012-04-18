# Returns a tag for all_day parameter of a calendar event (date pair).
#
# Returns some JavaScript in order to dynamically hide/show starts_at_time and ends_at_time
# when clicking on the all_day checkbox.
# See DatePairInput
#
class DatePairAllDayInput < SimpleForm::Inputs::BooleanInput
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::JavaScriptHelper

  def input
    out = ''

    out << super

    out << javascript_tag(
             "$(document).ready(function() {
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
           )
  end

  private

  def field_id(object_name, method, label = nil)
    if label
      "#{object_name}_#{method}_#{label}"
    else
      "#{object_name}_#{method}"
    end
  end
end
