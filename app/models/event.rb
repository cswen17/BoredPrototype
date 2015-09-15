include ActionView::Helpers::DateHelper

class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization

  has_and_belongs_to_many   :categories

  validates_presence_of(
    :name, :description, :location,
    :event_start, :event_end,
    :approval_rating, :user 
  )
  validates_size_of :location, :maximum => 100

  #### SCOPES ####
  scope :all, order("event_start ASC")
  scope :upcoming, where("event_end >= ?",
                         Time.current.strftime("%Y-%m-%d %H:%M"))
  scope :approved, where("approval_rating = ?", 100)
                     .order("event_start ASC")
  scope :current_approved, where("event_end >= ? and approval_rating = ?",
                                 Time.current.strftime("%Y-%m-%d %H:%M"),
                                   100)
  scope :awaiting_approval, where("approval_rating = ?", 0)
  scope :approved_upcoming, where("event_end >= ?",
                                  Time.current.strftime("%Y-%m-%d %H:%M"))
                              .where("approval_rating = ?", 100)

  #### PUBLIC METHODS ####

  def approval_status
    if self.approval_rating == 0
      return "needs_approval"
    elsif self.approval_rating == -1
      return "declined"
    else
      return "approved"
    end
  end
  
  def can_modify?(in_user)
	if in_user.nil?
		return false
	end
	
	if in_user.is_admin == true or in_user.is_developer == true
		return true
	end

	!in_user.organizations.where('id = ?', self.organization.id).empty?
  end

  def approve_event
    self.approval_rating = 100
	self.save!
  end

  def decline_event
    self.approval_rating = -1
	self.save!
  end

  # event timebins
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

  def date_class_array
    event_timebins = []
    event_timebins << "today" if is_today?
    event_timebins << "tomorrow" if is_tomorrow?
    event_timebins << "this_week" if is_this_week?
    event_timebins << "next_week" if is_next_week?
    event_timebins << "this_month" if is_this_month?
    event_timebins << "next_month" if is_next_month?
    event_timebins << "this_year" if is_this_year?
    return event_timebins.to_json
  end

  # we use this array to draw the event time category buttons
  def self.event_timebins 
    return {
      :today      => "Today",
      :tomorrow   => "Tomorrow",
      :this_week  => "This Week",
      :next_week  => "Next Week",
      :this_month => "This Month",
      :next_month => "Next Month",
      :this_year  => "This Year"
    }
  end

  # We can probably get away with letting the user upload something
  # crappy...it is their choice after all
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

  def category_ids_as_class
    # [view helper function]: wraps category ids in a list of
    # css classes so that we can store them in an html attribute
    # for the event
    category_id_classes_array = []
    self.categories.each do |c|
      category_id_classes_array << "category-button-#{c.id}"
    end
    return category_id_classes_array.to_json
  end

  def formatted_start_and_end_times
    # [view helper function]: displays start and end times in
    # a consolidated way, the date comes first and then the times
    start_day = self.event_start.strftime('%B %e')
    end_day = self.event_end.strftime('%B %e')
    start_time = self.event_start.strftime('%l:%M')
    end_time = self.event_end.strftime('%l:%M')
    start_am_pm = self.event_start.strftime('%P')
    end_am_pm = self.event_end.strftime('%P')
    result = ''
    if start_day == end_day
      result = "#{start_day}, "
    else
      result = "#{start_day}-#{end_day}, "
    end

    if start_am_pm == end_am_pm
      result += "#{start_time}-#{end_time}#{start_am_pm}"
    else
      result += "#{start_time}#{start_am_pm}-#{end_time}#{end_am_pm}"
    end
    return result
  end

  # when adding an error message, try to follow any examples you see here:
  # google.com/design/spec/patterns/errors.html#errors-user-input-errors
  CREATE_EVENT_ERRORS = {
    :name           => 'A name is required',
    :location       => 'A location is required',
    :description    => 'A description is required',
  }

  def create_event_errors_hash
    # [view helper function]
    # this function will go through our errors hash and return a new
    # hash that contains error messages that follow material design
    create_event_errors = {}

    self.errors.each do |validation_key, err_msg|
      pretty_err_msg = CREATE_EVENT_ERRORS[validation_key] 
      if pretty_err_msg == nil
        create_event_errors[validation_key] = err_msg
      else
        create_event_errors[validation_key] = pretty_err_msg
      end
    end

    return create_event_errors
  end
end
