xml.events do
  @events.each do |event_obj|
    xml.event(:id => event_obj.id) do
      xml.name(event_obj.name)

      xml.description(event_obj.description)
      xml.summary(event_obj.summary)

      xml.starttime(event_obj.event_start)
      xml.endtime(event_obj.event_end)

      xml.location(event_obj.location)
      xml.image(dropbox_url_for(event_obj.flyer_url))

      categories = []
      event_obj.categories.each do |c|
        categories << c.name
      end
      
      xml.categories(categories.join(","));
      xml.cancelled(event_obj.cancelled)
    end
  end
end
