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


  #### PAPERCLIP ####
  has_attached_file :flyer
  
  validates_attachment_content_type :flyer, :content_type => /^image\/(jpg|jpeg|pjpeg|png|x-png|gif)$/, :message => 'must be of the following formats: jpeg, png, or gif '
  validates_attachment_size :flyer, :in => 0..500.kilobytes , :message => 'must be at maximum 500 kb'
  
  #### DATA ####
  EVENT_TIMES = ["12:00 am", "00:00"], ["12:30 am", "00:30"], ["1:00 am", "1:00"], ["1:30 am", "1:30"], ["2:00 am", "2:00"], ["2:30 am", "2:30"], ["3:00 am", "3:00"], ["3:30 am", "3:30"], ["4:00 am", "4:00"], ["4:30 am", "4:30"], ["5:00 am", "5:00"], ["5:30 am", "5:30"], ["6:00 am", "6:00"], ["6:30 am", "6:30"], ["7:00 am", "7:00"], ["7:30 am", "7:30"], ["8:00 am", "8:00"], ["8:30 am", "8:30"], ["9:00 am", "9:00"], ["9:30 am", "9:30"], ["10:00 am", "10:00"], ["10:30 am", "10:30"], ["11:00 am", "11:00"], ["11:30 am", "11:30"], ["12:00 pm", "12:00"], ["12:30 pm", "12:30"], ["1:00 pm", "13:00"], ["1:30 pm", "13:30"], ["2:00 pm", "14:00"], ["2:30 pm", "14:30"], ["3:00 pm", "15:00"], ["3:30 pm", "15:30"], ["4:00 pm", "16:00"], ["4:30 pm", "16:30"], ["5:00 pm", "17:00"], ["5:30 pm", "17:30"], ["6:00 pm", "18:00"], ["6:30 pm", "18:30"], ["7:00 pm", "19:00"], ["7:30 pm", "19:30"], ["8:00 pm", "20:00"], ["8:30 pm", "20:30"], ["9:00 pm", "21:00"], ["9:30 pm", "21:30"], ["10:00 pm", "22:00"], ["10:30 pm", "22:30"], ["11:00 pm", "23:00"], ["11:30 pm", "23:30"]

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
end
