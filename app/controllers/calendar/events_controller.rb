module Calendar
  class EventsController < ApplicationController
    before_filter :parse_datepair_params

    # GET /events
    # GET /events.json
    def index
      # FullCalendar will hit the index method with query parameters
      # 'start' and 'end' in order to filter the results
      # Format is Unix timestamps (seconds since 1970)
      # Example: GET "/calendar/events?start=1338069600&end=1341698400"
      # This will generate the following query:
      # SELECT "calendar_events".* FROM "calendar_events" WHERE (starts_at > '2012-05-26 22:00:00.000000') AND (ends_at < '2012-07-07 22:00:00.000000')
      @events = Event.scoped
      @events = @events.after(Time.at(params['start'].to_i)) if (params['start'])
      @events = @events.before(Time.at(params['end'].to_i)) if (params['end'])

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
      @event = Event.new(params[:event])

      respond_to do |format|
        if @event.save
          flash.notice = %{Event "#{@event.title}" was successfully created.}
          format.html { redirect_to root_url }
          format.json { render json: @event, status: :created, location: @event }
          format.js # create.js.erb
        else
          format.html { render action: 'new' }
          format.json { render json: @event.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /events/1
    # PUT /events/1.json
    def update
      @event = Event.find(params[:id])

      respond_to do |format|
        if @event.update_attributes(params[:event])
          flash.notice = %{Event "#{@event.title}" was successfully updated.}
          format.html { redirect_to root_url }
          format.json { head :ok }
          format.js # update.js.erb
        else
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
        flash.notice = %{Event "#{@event.title}" was successfully deleted.}
        format.html { redirect_to root_url }
        format.json { head :ok }
        format.js # destroy.js.erb
      end
    end

    private

    include DatePairInputHelper

    def parse_datepair_params()
      parse_datepair(params, :event, :starts_at)
      parse_datepair(params, :event, :ends_at)
    end
  end
end
