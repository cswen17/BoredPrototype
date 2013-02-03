xml.events do
  xml.categories('Thursday, Friday, Saturday, Sunday')
  @events.each do |event_obj|
    xml.event(:id => event_obj.id) do
      xml.name(event_obj.name)

      xml.description(event_obj.description)
      xml.summary(event_obj.summary)

      xml.starttime(event_obj.event_start)
      xml.endtime(event_obj.event_end)

      xml.location(event_obj.location)
      xml.image(event_obj.flyer)

      mycat = Array.new
      count = 0

      EventsHelper::all_categories.each	do |c|
      	event_obj.categories.split(",").each do |cat|
           if c.second.to_s == cat	     
              mycat.insert(count, c.first)
	      count += 1
	   end
        end
      end

      xml.categories(mycat.join(","));
      xml.cancelled(event_obj.cancelled)
    end
  end
end
