class EventsController < ApplicationController
#	before_filter login_required, :only => [:new, :my, :create, :edit, :update, :destroy, :approve, :decline]
  # GET /events
  # GET /events.json
  # GET /events.xml
  def index
    @events = Event.current_approved

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
      format.xml
    end
  end
  
  def my
#	@organizationsEvents= Organization.for_user(current_user).includes(:events)
	@events = Event.current_approved
	
	respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
      format.xml
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
	if !@event.can_modify?(current_user)
		raise Exceptions::AccessDeniedException
	end
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])
	@event.user = current_user

    #@event.save
    
    editEvent(@event, params)
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

	if !@event.can_modify?(current_user)
		raise Exceptions::AccessDeniedException
	end
	
    # Note: this block is designed to zero out the categories,
    # start and end times, and put the rest of the variables
    # equal to what the inputted parameters are.  If you
    # can think of a better way do implement this, please do.
    #@event.start_time = nil
    #@event.end_time = nil
    #@event.name = params[:event][:name]
    #@event.description = params[:event][:description]
	#@event.flyer = params[:event][:flyer]
    #@event.location = params[:event][:location]
    #@event.categories = params[:event][:categories]
	#@event.organization_id = params[:event][:organization_id]
	@event.update_attributes(params[:event])
	
    @event.event_start = params[:event][:event_start]
    @event.event_end = params[:event][:event_end]
	
	
	
	

    editEvent(@event, params)
	
  end

  # This event takes in an initialized event (event) and a list of parameters (params),
  # checks the invariants of the event, and then either creates it if it is
  # valid or returns an error if it is not.
  def editEvent(event, params)
    if (!params[:event][:categories].nil?)
      event.categories = params[:event][:categories].join(",")
    end
    
    if (!params[:event][:start_time].nil? and !params['start_time_date'].nil?)
      event.start_time = event.merge_times(params['start_time_date'], params[:event][:start_time])
      event.add_event_start_time
    end

    if (!params[:event][:end_time].nil? and !params['end_time_date'].nil?)
      event.end_time = event.merge_times(params['end_time_date'], params[:event][:end_time])
      event.add_event_end_time
    end

    event.check_invariants

    respond_to do |format|
      if event.errors.empty? and event.save 
		flash[:notice] = "Successfully created event #{event.name}."
        format.html { redirect_to :action => 'my' }
        format.json { render json: event, status: :created, location: event }
      else
        format.html { render action: "new" }
        format.json { render json: event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
	
	if !@event.can_modify?(current_user)
		raise Exceptions::AccessDeniedException
	end
    name = @event.name
	@event.destroy

	flash[:notice] = "Successfully deleted event #{name}."
	
    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :ok }
    end
  end

  def approve
    @event = Event.find(params[:id])
	
	if current_user.moderator == false
		raise Exceptions::AccessDeniedException
	end
	
    @event.approve_event
    @event.save
    respond_to do |format|
      format.html { redirect_to approval_url }
      format.json { head :ok }
    end
  end

  def decline
    @event = Event.find(params[:id])
	
	if current_user.moderator == false
		raise Exceptions::AccessDeniedException
	end
	
    @event.decline_event
    @event.save
    respond_to do |format|
      format.html { redirect_to approval_url }
      format.json { head :ok }
    end
  end
end
