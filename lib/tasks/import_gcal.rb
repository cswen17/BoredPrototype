def import_gcal(calendar_id)

  require 'rubygems'
  require 'yaml'
  require 'google/api_client'

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
                          :parameters => {'calendarId' => calendar_id,
                                          'timeMin' => cur_utc_time})

  @to_import = (JSON.parse result.data.to_json)["items"] #TODO: Remove @ sign. Only needed for irb loading

  @to_import.each do |cur_event|
    event = Event.new
    event.name=cur_event["summary"]
    if cur_event["description"] != nil
      event.description = cur_event["description"]
      event.summary = cur_event["description"]
    else
      event.description = "An AB Films Movie"
      event.summary = "An AB Films Movie"
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
    event.categories = "6" #CHANGE ME!
    event.location = cur_event["location"] || 'Unknown'
    event.organization_id = "3" #CHANGE ME!
    event.user = User.first #CHANGE ME!

    if (event.start_time != nil && event.end_time != nil) 
      event.add_event_start_time; #sets event_start field
      event.add_event_end_time; #sets event_end field
    end

    puts event.check_invariants
#    require 'debugger'; debugger
    puts event.errors
    event.save
  end

end

#load 'lib/tasks/import_gcal.rb'
