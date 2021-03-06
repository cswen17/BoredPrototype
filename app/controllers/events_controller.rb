require 'net/http'
require 'dropbox_sdk'
class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  # GET /events.xml
  def index
    @events = Event.current_approved
    @categories = Category.all or []

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
      format.xml
    end
  end
  
  def my
	@events = Event.find(:all, :conditions => [
        'user_id = ?', current_user.id
    ])

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
    @categories = Category.all or []

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @categories = Category.all or []
    @event = Event.find(params[:id])

	if !@event.can_modify?(current_user)
		raise Exceptions::AccessDeniedException
	end
  end

  # POST /events
  # POST /events.json
  def create
    is_facebook_event = params.delete("is_facebook_event")
    facebook_cover_url = params.delete("facebook_cover_url")

    categories = params[:event].delete("categories")
    
    uploaded_flyer = params[:event].delete(:flyer_url)

    if is_facebook_event == "true" and facebook_cover_url != nil
      params[:event][:flyer_url] = facebook_cover_url
    elsif uploaded_flyer != nil
      flyer_buf = ''
      uploaded_flyer.read(uploaded_flyer.size(), flyer_buf)

      original = uploaded_flyer.original_filename
      response = dropbox_client().put_file(original, flyer_buf)
      logger.info response
      params[:event][:flyer_url] = original
    else
      params[:event][:flyer_url] = ''
    end

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

    is_facebook_event = params.delete("is_facebook_event")
    facebook_cover_url = params.delete("facebook_cover_url")

	uploaded_flyer = params[:event][:flyer_url]
    if uploaded_flyer != nil
      flyer_buf = ''
      uploaded_flyer.read(uploaded_flyer.size(), flyer_buf)

      original = uploaded_flyer.original_filename
      response = dropbox_client().put_file(original, flyer_buf)
      logger.info response
      params[:event][:flyer_url] = original
    elsif is_facebook_event and facebook_cover_url != nil
      params[:event][:flyer_url] = facebook_cover_url
    else
      params[:event][:flyer_url] = @event.flyer_url
    end

    updated_categories = params[:event].delete("categories")
	@event.update_attributes(params[:event])
	
    editEvent(@event, params, updated_categories)
	
  end

  # This function takes in an initialized event (event) and a list of parameters
  # (params), checks the invariants of the event, and then either creates it
  # if it is valid or returns an error if it is not.
  def editEvent(event, params, category_names)
    # this category stuff is ratchet and makes a lot of database queries
    # which is bad for performance. We need to figure out the right way
    # to do this in rails, which may be automatic in some way :/
    if !category_names.nil?
      event.categories.clear
      category_names.each do |category_name|
        category = Category.find_by_name(category_name) 
        event.categories << category
      end
    end

    respond_to do |format|
      # event.errors.empty?
      if event.save 
		flash[:notice] = "Successfully created/updated #{event.name}."
        format.html { redirect_to :action => 'my' }
        format.json { render json: event, status: :created, location: event }
      else
        @categories = Category.all or []
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
      format.html { redirect_to events_my_url }
      format.json { head :ok }
    end
  end

  def approval
    # This controller action is only for rendering the APPROVAL
    # dashboard for moderators. It doesn't do anything but fetch
    # a template from the app/views/events/ directory
    ids = []
    Organization.for_user(current_user).each do |org|
      ids << org.id
    end
    @events = Event.where(organization_id: ids)

    respond_to do |format|
      format.html
    end
  end

  def approve
    @event = Event.find(params[:id])
	
	if current_user.is_admin == false
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
	
	if current_user.is_admin == false
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
