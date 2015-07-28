class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  # GET /events.xml
  def index
    @events = Event.current_approved
    @categories = Category.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
      format.xml
    end
  end
  
  def my
	@events = Event.find(:all, :conditions => ['user_id = ?', current_user.id])

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
    @categories = Category.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @categories = Category.all
    @event = Event.find(params[:id])
	if !@event.can_modify?(current_user)
		raise Exceptions::AccessDeniedException
	end
  end

  # POST /events
  # POST /events.json
  def create
    categories = params[:event].delete("categories")
    @event = Event.new(params[:event])
	@event.user = current_user

    editEvent(@event, params, categories)
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

	if !@event.can_modify?(current_user)
		raise Exceptions::AccessDeniedException
	end
	
    updated_categories = params[:event].delete("categories")
	@event.update_attributes(params[:event])
	
    @event.event_start = params[:event][:event_start]
    @event.event_end = params[:event][:event_end]
	
    editEvent(@event, params, updated_categories)
	
  end

  # This event takes in an initialized event (event) and a list of parameters (params),
  # checks the invariants of the event, and then either creates it if it is
  # valid or returns an error if it is not.
  def editEvent(event, params, category_names)
    # this may need to be moved to the model
    if !category_names.nil?
      event.categories.clear
      category_names.each do |category_name|
        category = Category.find_by_name(category_name) 
        event.categories << category
      end
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
      # event.errors.empty?
      if true # and event.save 
		flash[:notice] = "Successfully updated #{event.name}."
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
