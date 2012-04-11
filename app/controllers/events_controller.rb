class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  def index
    @events = Event.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html { render layout: false } # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new(params[:event])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new_tooltip
  def new_tooltip
    @event = Event.new(params[:event])

    respond_to do |format|
      format.html { render layout: false } # new_tooltip.html.erb
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create
    Time.parse_jquery_datetime_select(params, :event, :starts_at)
    Time.parse_jquery_datetime_select(params, :event, :ends_at)

    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        if params[:edit_event]
          # Edit button was clicked
          #format.js { render action: 'edit' }
          format.js { redirect_to edit_event_path }
        else
          # Regular create action
          format.html { redirect_to calendar_url, notice: 'Event was successfully created.' }
          format.json { render json: @event, status: :created, location: @event }
          format.js # create.js.erb
        end
      else
        format.html { render action: 'new' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    Time.parse_jquery_datetime_select(params, :event, :starts_at)
    Time.parse_jquery_datetime_select(params, :event, :ends_at)

    @event = Event.find(params[:id])

    # FullCalendar does not give us ends_at if the event is a all day event
    # thus it is better to manually reset ends_at
    @event.ends_at = nil

    respond_to do |format|
      if @event.update_attributes(params[:event])
        flash.notice = 'Event was successfully updated.'
        format.html { redirect_to calendar_url }
        format.json { head :ok }
        format.js # update.js.erb
      else
        flash.alert = @event.errors.full_messages
        format.html { render action: 'edit' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
        format.js # update.js.erb
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to calendar_url }
      format.json { head :ok }
      format.js # destroy.js.erb
    end
  end
end
