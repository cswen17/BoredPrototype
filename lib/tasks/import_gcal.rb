#! /usr/bin/ruby
require 'rubygems'
require 'yaml'
require 'google/api_client'

calendars = []

temp_cal = {}

#org_name must be an organization name in Teudu
temp_cal['org_name'] = 'AB Films'
temp_cal['id'] = '64usuav4123o6ea6gptm75efdc@group.calendar.google.com'
temp_cal['default_description'] = 'An AB Films Movie'
temp_cal['default_cat'] = EventsHelper.category_hash['Movies'].to_s

calendars << temp_cal

temp_cal = {}
temp_cal['org_name'] = 'ACM@CMU'
temp_cal['id'] = '4k7vn521n3ok8vrb8k8niegohk@group.calendar.google.com'
temp_cal['default_description'] = 'An event hosted by the Association for Computing Machinery'
temp_cal['default_cat'] = EventsHelper.category_hash['Professional'].to_s + ',' + 
                          EventsHelper.category_hash['Academic'].to_s

calendars << temp_cal

ROBOT_USERID = User.where(:first_name => 'Robot').first.id
ROBOT_ORGID = Organization.where(:name => 'Robot').first.id

def import_gcal(cal)
  #  calendar_id = '64usuav4123o6ea6gptm75efdc@group.calendar.google.com'

  oauth_yaml = YAML.load_file('/Users/aveshsingh/.google-api.yaml')
  client = Google::APIClient.new
  client.authorization.client_id = oauth_yaml["client_id"]
  client.authorization.client_secret = oauth_yaml["client_secret"]
  client.authorization.scope = oauth_yaml["scope"]
  client.authorization.refresh_token = oauth_yaml["refresh_token"]
  client.authorization.access_token = oauth_yaml["access_token"]

  if client.authorization.refresh_token && client.authorization.expired?
    client.authorization.fetch_access_token!
  end

  service = client.discovered_api('calendar', 'v3')

  cur_utc_time = Time.now.utc.strftime("%Y-%m-%dT%H:%M:00.0z")

  result = client.execute(:api_method => service.events.list,
                          :parameters => {'calendarId' => cal['id'],
                            'timeMin' => cur_utc_time})

  @to_import = (JSON.parse result.data.to_json)["items"] 

  @to_import.each do |cur_event|
    event = Event.new
    event.name=cur_event["summary"]

    if cur_event["description"] != nil
      event.description = cur_event["description"]
      event.summary = cur_event["description"]
    else
      event.description = cal['default_description']
      event.summary = cal['default_description']
    end

    if cur_event["start"] == nil
      next
    end

    start_time = Time.parse(cur_event["start"]["dateTime"] || cur_event["start"]["date"]) 

    if (start_time < Time.now)
      next
    end

    event.start_time=start_time.strftime("%Y-%d-%m %H:%M")
    event.end_time=Time.parse(cur_event["end"]["dateTime"] || cur_event["end"]["date"]).strftime("%Y-%d-%m %H:%M")
    event.categories = cal['default_cat']
    event.location = cur_event["location"] || 'Unknown'

    if Organization.where(:name => cal['org_name']) 
      
      if(Organization.where(:name => cal['org_name']).first != nil)
        event.organization_id = Organization.where(:name => cal['org_name']).first.id
      else
        event.organization_id =  ROBOT_ORGID
      end

      event.user = User.find(ROBOT_USERID)

#      Add Robot User to organization if it hasn't already been added
      if(OrganizationUser.where(:user_id => ROBOT_USERID, :organization_id => event.organization_id).size == 0)
        o = OrganizationUser.new
        o.user_id = ROBOT_USERID
        o.organization_id = event.organization_id
        o.save
      end

      if (event.start_time != nil && event.end_time != nil) 
        event.add_event_start_time; #sets event_start field
        event.add_event_end_time; #sets event_end field
      end

      puts event.check_invariants
      puts event.errors
      event.save
    else
      puts 'Organization with name ' + cal['org_name'] + ' does not exist.'
    end

  end
end

  #load 'lib/tasks/import_gcal.rb'

  for cal in calendars do
    import_gcal(cal)
  end
