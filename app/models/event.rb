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
	
	if in_user.moderator == true
		return true
	end

	!in_user.organizations.where('id = ?', self.organization.id).empty?
  end

  def option_event_start
    default_time_option(self.event_start, 1)
  end

  def option_event_end
    default_time_option(self.event_end, 3)
  end

  def default_time_option(optional_hour_minute, offset)
    if optional_hour_minute.nil?
      return closest_half_hour(minute_offset=offset)
    else
      return optional_hour_minute.strftime('%H:%M')
    end
  end

  def edit_event_start
    default_date_text(self.event_start)
  end

  def edit_event_end
    default_date_text(self.event_end)
  end

  def default_date_text(optional_datetime)
    if optional_datetime.nil?
      return Time.now.strftime('%m/%d/%Y')
    else
      return optional_datetime.strftime('%m/%d/%Y')
    end
  end

  def approve_event
    self.approval_rating = 100
	self.save!
  end

  def decline_event
    self.approval_rating = -1
	self.save!
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

  def category_ids_as_class
    # [view helper function]: wraps category ids in a list of css classes
    # so that we can store them in an html attribute for the event
    category_id_classes_array = []
    self.categories.each do |c|
      category_id_classes_array << "category-button-#{c.id}"
    end
    return category_id_classes_array.to_json
  end

end
