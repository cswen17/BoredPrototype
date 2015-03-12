# Parse input events file and add events to database

require 'date'
# include Event

fname = "events.txt"

def parse_line(line)
  # don't match whitespace after the pipe in order to have an empty string URL in its own array element
  words = line.split(%r{\s*\|})
  words = words.map(&:lstrip)
  p words
end

def try_fmt(data, ln_num)
  begin
    fail if (data.length < 12)
    data[0] = Integer data[0]
    data[4] = DateTime.parse(data[4])
    data[5] = DateTime.parse(data[5])
    cats = data[6].split(",")
    fail if !(cats.length == 2 && Integer(cats[0]).between?(0, 9) && Integer(cats[1]).between?(0, 9))
    data[9] = Integer(data[9])
    data[10] = Integer(data[10])
  rescue
    puts "Error in parsing line " + String(ln_num) + " of auto-loaded events."
    exit(1)
  end
end

def create_event(data)
=begin
  Event.create!(
  :id => data[0],
  :name => data[1],
  :description => data[2],
  :location => data[3], 
  :start_time => data[4], 
  :end_time => data[5], 
  :event_start => data[4],
  :event_end => data[5],
  :categories => data[6], 
  :approval_rating => 1, # ?
  :approver_id => string, 
  :flyer_file_name => data[7], 
  :flyer_content_type => "image", # ?
  :created_at => Time.now, 
  :updated_at => Time.now, 
  :summary => data[8], 
  :cancelled => false, 
  :organization_id => data[9], 
  :user_id => data[10], 
  :url => data[11]
  )
=end
1
end

File.open(fname, "r") do |f|
  x = 0
  f.each_line do |line|
    x += 1
    data = parse_line(line)
    fmt_data = try_fmt(data, x)
    create_event(fmt_data)
  end
end

