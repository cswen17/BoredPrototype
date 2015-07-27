FactoryGirl.define do
  
  factory :organization do
    name "Ruby"
  end
  
  factory :event do
    name "JSA Awesome Event"
    description "This is an extremely awesome event and for the sake of awesomeness I just wanted to write this really long message to emphasize awesome things about this event, like it has a really long event description for no good reason than to annoy most people, except for Brian Yee. I also wanted to immortalize Brian's name in this message so that he could come back after 80 years and be like, OMG MY NAME IS IN A SUPERDY DUPER LONG DESCRIPTION. Btw, Brian isn't Japanese."
	location "Merson Courtyard"
	event_start 2.weeks.from_now
	event_end (2.weeks.from_now + 1.hours).to_datetime
	start_time 2.weeks.from_now.to_datetime.to_s
	end_time (2.weeks.from_now + 1.hours).to_datetime.to_s
	summary "Happens in our backyard"
	categories "4,6"
  end
  
  factory :user do
    id 36
    first_name "David"
    last_name "Black"
	andrew_id "dblack"
  end

  factory :events_organizations do
	association :event
	association :organization
  end
  
  factory :organizations_users do
	association :organization
	association :user
  end

end
