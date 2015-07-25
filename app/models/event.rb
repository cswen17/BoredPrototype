include ActionView::Helpers::DateHelper

class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization

  has_and_belongs_to_many   :categories

  validates_presence_of :name, :description,  :summary, :location, :start_time, :end_time, :categories, :approval_rating, :event_start, :event_end, :user, :organization
  validates_size_of :location, :maximum => 100
  validates_size_of :summary, :maximum => 300

  before_save :add_event_times

  before_validation :check_invariants
 


  #### SCOPES ####
  scope :all, order("start_time ASC")
  scope :upcoming, where("event_end >= ?", Time.current.strftime("%Y-%m-%d %H:%M"))
  scope :approved, where("approval_rating = ?", 100).order("event_start ASC")
  scope :current_approved, where("event_end >= ? and approval_rating = ?", Time.current.strftime("%Y-%m-%d %H:%M"),100)
  scope :awaiting_approval, where("approval_rating = ?", 0)
  scope :approved_upcoming, where("event_end >= ?", Time.current.strftime("%Y-%m-%d %H:%M")).where("approval_rating = ?", 100)


  #### PAPERCLIP ####
  has_attached_file :flyer
  
  validates_attachment_content_type :flyer, :content_type => /^image\/(jpg|jpeg|pjpeg|png|x-png|gif)$/, :message => 'must be of the following formats: jpeg, png, or gif '
  validates_attachment_size :flyer, :in => 0..500.kilobytes , :message => 'must be at maximum 500 kb'
  
  #### DATA ####
  EVENT_TIMES = ["12:00 am", "00:00"], ["12:30 am", "00:30"], ["1:00 am", "1:00"], ["1:30 am", "1:30"], ["2:00 am", "2:00"], ["2:30 am", "2:30"], ["3:00 am", "3:00"], ["3:30 am", "3:30"], ["4:00 am", "4:00"], ["4:30 am", "4:30"], ["5:00 am", "5:00"], ["5:30 am", "5:30"], ["6:00 am", "6:00"], ["6:30 am", "6:30"], ["7:00 am", "7:00"], ["7:30 am", "7:30"], ["8:00 am", "8:00"], ["8:30 am", "8:30"], ["9:00 am", "9:00"], ["9:30 am", "9:30"], ["10:00 am", "10:00"], ["10:30 am", "10:30"], ["11:00 am", "11:00"], ["11:30 am", "11:30"], ["12:00 pm", "12:00"], ["12:30 pm", "12:30"], ["1:00 pm", "13:00"], ["1:30 pm", "13:30"], ["2:00 pm", "14:00"], ["2:30 pm", "14:30"], ["3:00 pm", "15:00"], ["3:30 pm", "15:30"], ["4:00 pm", "16:00"], ["4:30 pm", "16:30"], ["5:00 pm", "17:00"], ["5:30 pm", "17:30"], ["6:00 pm", "18:00"], ["6:30 pm", "18:30"], ["7:00 pm", "19:00"], ["7:30 pm", "19:30"], ["8:00 pm", "20:00"], ["8:30 pm", "20:30"], ["9:00 pm", "21:00"], ["9:30 pm", "21:30"], ["10:00 pm", "22:00"], ["10:30 pm", "22:30"], ["11:00 pm", "23:00"], ["11:30 pm", "23:30"]
  EVENT_CATEGORIES = %w(Arts Sports Professional Cultural Music Movies Academic Social Service)

  include EventsHelper
  
  #### PUBLIC METHODS ####

  def approval_status
    if self.approval_rating == 0
      "needs_approval"
    elsif self.approval_rating == -1
      "declined"
    else
      "approved"
    end
  end
  
  def can_modify?(in_user)
	if in_user.nil?
		return false
	end
	
	if in_user.moderator == true
		return true
	end

	!in_user.organizations.where("id = ?", self.organization.id).empty?
  end

  # Parses an event's time and returns it as an array of Datetime objects
  # "year-month-day hour-minute"
  # This is in 24-hour time, separated by a %
  # "year-month-day hour-minute%year-month-day hour-minute"
  def get_start_times
    times = []
    self.start_time.split('%').each do |t|
      times.push(DateTime.strptime(t, '%m-%d-%Y %H:%M'))
    end
    times
  end

  def get_end_times
    times = []
    self.end_time.split('%').each do |t|
      times.push(DateTime.strptime(t, '%m-%d-%Y %H:%M'))
    end
    times
  end

  def get_datetime_from_time_string(str)
	begin
    	DateTime.strptime(str, '%Y-%m-%d %H:%M:%S') 
	rescue => e
		logger.warn("Get DateTime from Time String Error: #{e} of #{str}")
		Time.now
	end
  end


  def merge_times(date, time)
    return "" + date.split('/').reverse.join('-') + " " + time
  end

  def add_event_times
    puts self.start_time
    puts self.end_time
    self.event_start = get_datetime_from_time_string(self.start_time)
    self.event_end = get_datetime_from_time_string(self.end_time)
  end

  def add_event_start_time
    puts self.start_time
    self.event_start = get_datetime_from_time_string(self.start_time)
  end

  def add_event_end_time
    puts self.end_time
    self.event_end = get_datetime_from_time_string(self.end_time)
  end

  def edit_start_date
    if self.start_time.nil?
      return Time.now.strftime('%m/%d/%Y')
    else
      old_date = DateTime.strptime(self.start_time, '%Y-%d-%m %H:%M') rescue Time.now
      old_date.strftime('%m/%d/%Y')
    end
  end

  def edit_end_date
    if self.end_time.nil?
      return Time.now.strftime('%m/%d/%Y')
    else
      old_date = DateTime.strptime(self.end_time, '%Y-%d-%m %H:%M') rescue Time.now
      old_date.strftime('%m/%d/%Y')
    end
  end
  

  # Approval
  def approve_event
    self.approval_rating = 100
	self.save!
  end

  def decline_event
    self.approval_rating = -1
	self.save!
  end
  
  def in_category?(cat)
	if(!self.categories.nil?)
		return EventsHelper::cat_to_array(self.categories).include?(cat)
	else
		return false
	end
  end
  
  
  #event timebins
  def is_today?
	self.event_start.day === (Date.today.day) and is_this_week? and is_this_year?
  end
  
  def is_tomorrow?
	self.event_start.day === (Date.today.day + 1)
  end
  
  def is_this_week?
	self.event_start.to_date.cweek === Date.today.cweek
  end
  
  def is_next_week?
	self.event_start.to_date.cweek === (Date.today.cweek + 1)
  end
  
  def is_this_month?
	self.event_start.month == Date.today.month and is_this_year?
  end
  
  def is_next_month?
	self.event_start.month == (Date.today.month + 1) and is_this_year?
  end
  
  def is_this_year?
	self.event_start.year == Date.today.year
  end
  
  def date_class_string
	s = ""
	s = " today" if is_today?
	s = s + " tomorrow" if is_tomorrow?
	s = s + " this_week" if is_this_week?
	s = s + " next_week" if is_next_week?
	s = s + " this_month" if is_this_month?
	s = s + " next_month" if is_next_month?
	s = s + " this_year" if is_this_year?
	s
  end

  # This function checks the current invariants for the event.
  # If any of the invariants are not satisfied, then it returns
  # false and adds an appropriate error to the errors array in 
  # the current event.  Otherwise, it returns true.
  #
  # the current invariants for events are as follows:
  # 1. The start and end date and time are not empty
  # 2. The number of categories is > 0
  # 3. The start time is before or equal to the end time
  # 4. All of the variables exist
  # 5. There is not a duplicate event in the database
  #
  # Note: If you edit this function, please edit the spec above as well
  def check_invariants
    validEvent = true

    # This block checks if the start and end times are empty
    if :start_time_date.empty? or :end_time_date.empty?
      errors.add :start_time, "should be added."
      validEvent = false
    end
    
    # This block checks if the name field exists
    if (self.name.nil?)
      errors.add :name, "should not be empty."
      validEvent = false
    end

    # This block checks if the description field exists
    if (self.description.nil?)
      errors.add :description, "should not be empty."
      validEvent = false
    end

    # This block checks if the location field exists
    if (self.location.nil?)
      errors.add :location, "should not be empty."
      validEvent = false
    end

    # This block checks if the approval_rating field exists
    if (self.approval_rating.nil?)
      errors.add :approval_rating, "should not be empty."
      validEvent = false
    end

    # This block checks if the event_start field exists
    if (self.event_start.nil?)
      errors.add :event_start, "should not be empty."
      validEvent = false
    end

    # This block checks if the event_end field exists
    if (self.event_end.nil?)
      errors.add :event_end, "should not be empty."
      validEvent = false
    end

    # This block checks if there are any duplicate events when submitting a new event
    if(self.id == nil) 
      if (Event.exists?(:location => self.location, :start_time => self.start_time, :end_time => self.end_time))
        errors.add :location, "invalid: Cannot be a duplicate event."
        validEvent = false
      end
    else
      if (Event.where("location = ? AND start_time = ? AND end_time = ? AND NOT id = ?", self.location, self.start_time, self.end_time, self.id).length >= 1)
        errors.add :location, "invalid: Created a duplicate event via editing"
      end
    end

    # This block checks to make sure that the organization
    # matches the specified user
    if !can_modify?(self.user)
      errors.add :organization, "should be one that you are a member of"
      validEvent = false
    end

    return validEvent
  end

  private

  def check_empty_dates
    if :start_time_date.empty? or :end_time_date.empty?
      flash[:error] = 'You must give a date'
      errors.add :start_time, :message => "You need to input a date"
      return false
    else
      return true
    end
  end
  
  # We can probably get away with letting the user upload something crappy...it is their choice after all
  def dimensions_fine?
	  temp_file = flyer.queued_for_write[:original]
	  unless temp_file.nil?
		dimensions = Paperclip::Geometry.from_file(temp_file)
		width = dimensions.width
		height = dimensions.height
		
		if width < 200 && height < 400
		  errors.add("flyer", "dimensions are too small.  Minimum width: 200px, minimum height: 400px")
		  puts "flyer not valid"
		  false
	    else
		  true
		end
	  end
	  true
	end
end
