class CalendarController < ApplicationController

  # Shows the calendar using current date or the provided date if any.
  # If a date is specified, it will move the calendar.
  #
  # GET /calendar
  # GET /calendar?date="2011-10-22T03:20:00Z" => ISO 8601 format, Time.now.utc.iso8601
  # GET /calendar?date="2011-10-22 01:20:00 UTC" => Time.now.utc
  # GET /calendar?date="2011-10-22 03:20:00 +0200" => Time.now
  # GET /calendar?date="2011-10-22 UTC"
  # GET /calendar?date="2011-10-22 +0200"
  # GET /calendar?date="2011-10-22"
  def index
    # ISO 8601 format is not yet fully supported by JavaScript Date object
    # so a string cannot be passed directly to FullCalendar.
    # Let's use a temporary Ruby Time object.
    # See https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Date/parse

    # Time.to_i returns the number of seconds since the Unix epoch.
    # Date JavaScript object constructor takes the number of milliseconds since the Unix epoch.

    @date = Time.parse(params[:date]).to_i * 1000 if params[:date]
  end

end
