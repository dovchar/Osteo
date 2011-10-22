class CalendarController < ApplicationController

  # Shows the calendar using current date or the provided date if any
  # GET /calendar
  # GET /calendar?date="2011-10-22 03:20:00 +0200"
  # GET /calendar?date="2011-10-22 01:20:00 UTC"
  # GET /calendar?date="2011-10-22"
  def index
    @date = Time.parse(params[:date]) if params[:date]
  end

end
