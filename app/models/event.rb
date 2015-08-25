include ActionView::Helpers::DateHelper

class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization

  has_and_belongs_to_many   :categories

  validates_presence_of(
    :name, :description,  :summary, :location,
    :event_start, :event_end,
    :approval_rating, :user 
  )
  validates_size_of :location, :maximum => 100
  validates_size_of :summary, :maximum => 300

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
  @@CREATE_EVENT_ERRORS = {
    :name            => 'A name is required',
    :location        => 'A location is required',
    :description     => 'A description is required',
    :day_time_range => 'An event\'s start is required to be before its end'
  }

  def create_event_errors_hash
    # this function will go through our errors hash and return a new
    # hash that contains error messages that follow material design
    create_event_errors = {}

    self.errors.each do |validation_key, err_msg|
      pretty_err_msg = @@CREATE_EVENT_ERRORS[validation_key] 
      if pretty_err_msg == nil
        create_event_errors[validation_key] = err_msg
      else
        create_event_errors[validation_key] = pretty_err_msg
      end
    end

    return create_event_errors
  end

end
