module DatePairInputHelper

  # Parses the request parameters generated by simple_form DatePairInput.
  #
  # DatePairInput returns two fields #{field}_date and #{field}_time
  # instead of serializing params into a Time object directly as would do
  # the standard Rails datetime_select helper.
  #
  # ==== Example
  #   # View
  #   <%= simple_form_for(@event) do |f| %>
  #     <%= f.input :starts_at, as: :date_pair %>
  #     <%= f.input :ends_at, as: :date_pair %>
  #   <% end %>
  #
  #   # Parameters from the request
  #   "event" => {
  #     "title" => "Event title",
  #     "starts_at" => "2012-04-15",
  #     "starts_at_time" => "02:00am",
  #     "ends_at" => "2012-04-15",
  #     "ends_at_time" => "03:00am",
  #     "all_day" => "0",
  #     "location" => "Paris",
  #     "description" => "Event description"
  #   }
  #
  def parse_datepair(params, model, field)
    if params && params["#{model}"]
      date = params["#{model}"]["#{field}_date"]
      time = params["#{model}"]["#{field}_time"]

      # Constructs the string to parse and its format
      str = ''
      format = ''
      if !date.blank?
        str = date
        format = Calendar::Event::DATE_FORMAT
      end
      if !date.blank? && !time.blank?
        str = str + ' '
        format = format + ' '
      end
      if !time.blank?
        str = str + time
        format = format + Calendar::Event::TIME_FORMAT
      end
      if !time.blank?
        str = str + ' ' + Calendar::Event::TIME_ZONE
        format = format + ' %Z'
      end

      datetime = nil
      begin
        # Time.strptime('', '') returns the current date time and
        # this is not what we want
        if !str.blank? && !format.blank?
          datetime = Time.strptime(str, format)
        end
      rescue
        datetime = nil
      end

      params["#{model}"]["#{field}"] = datetime.to_s if datetime

      params["#{model}"].delete("#{field}_date")
      params["#{model}"].delete("#{field}_time")
    end
  end
end
