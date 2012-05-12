# Returns a set of tags to select a calendar event (date pair).
#
# Similar to a datetime_select but uses jquery-timepicker datepair.js.
#
# See https://github.com/jonthornton/jquery-timepicker
# See DateHelper#datetime_select
#
# Creates two fields:
# - date text input field ("2011-11-28") using a datepicker
# - time text input field ("22:00") using a timepicker
#
# ==== Example
#   <%= simple_form_for(@event) do |f| %>
#     <div class="datepair">
#       <%= f.input :starts_at, as: :date_pair, :input_html => { class: "start" } %>
#       <%= f.input :ends_at, as: :date_pair, :input_html => { class: "end" } %>
#       <%= f.input :all_day, as: :date_pair_all_day %>
#     </div>
#   <% end %>
#
# Unobtrusive JavaScript: if disabled, the two text fields will still work.
#
class DatePairInput < SimpleForm::Inputs::Base
  def input
    out = ''

    attr = object.send("#{attribute_name}")
    # Event attributes starts_at and ends_at can be nil if the user did not enter any value
    # In this case let's set starts_at and ends_at to empty strings
    datetime = ''
    # The user wants starts_at and ends_at to be in local time instead of UTC
    datetime = attr.round_time(Calendar::Event::STEP_MINUTE.minutes).in_time_zone(Calendar::Event::TIME_ZONE) if attr

    value = datetime.strftime(Calendar::Event::DATE_FORMAT) # Always set a value otherwise text_field will fail
    klass = [ input_html_options[:class], 'date' ]
    out << @builder.text_field("#{attribute_name}_date", { value: value, class: klass})

    out << "\n"

    time_html_options = {}
    value = datetime.strftime(Calendar::Event::TIME_FORMAT) # Always set a value otherwise text_field will fail
    klass = [ input_html_options[:class], 'time' ]
    out << @builder.text_field("#{attribute_name}_time", { value: value, class: klass})
  end
end
