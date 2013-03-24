module EventsHelper
  def closest_half_hour(minute_offset = 0)
    # Ok I spent 30 minutes trying to figure this out but apparently
    # %l returns the hour with some leading whitespace - you need to
    # use .lstrip in order to trim it off the top in order to get it
    # to compare nicely.
    # Time.at((Time.now.advance(:minutes => minute_offset*30).to_f / (30*60) ).round * 30*60).strftime("%l:%M %P").lstrip
    Time.at((Time.now.advance(:minutes => minute_offset*30).to_f / (30*60) ).round * 30*60).strftime("%H:%M").lstrip
  end
  @@category_hash = {
  "Arts" => 1, 
  "Sports" =>2,
  "Professional" => 3,
  "Cultural" => 4,
  "Music" => 5,
  "Movies" => 6,
  "Academic" => 7,
  "Social" => 8,
  "Service" => 9
  }

  def self.category_hash
    @@category_hash
  end

  def self.all_categories
    categories = []
    @@category_hash.each do |c|
      categories << c
    end
    return categories
  end

  def get_check_id(name)
    'check-' + name.downcase
  end

  def self.cat_to_array(categories)
    # Takes an event's category string as stored in the database and returns
    # an array where each element is the category number (type string)
    categories.split(',')
  end

  def get_cat_classes(categories)
    # Takes an event's category string as stored in the database and returns
    # a correct css class string with the cat-# css classes
    cat_classes = ''
    categories.split(',').each do |c|
      cat_classes += 'cat-' + c + ' '
    end
    return cat_classes[0..-2]
  end
  
  def self.cat_to_id(cat)
	return @@category_hash[cat]
  end

  def categories_javascript()
    return nested_array_to_javascript(EventsHelper.all_categories)
  end

  #Turns an array, even a nested one, from Ruby to Javascript
  def nested_array_to_javascript(option)
  	retVal = ""

  	if option.kind_of?(Array)
  		retVal += "["
  		option.each do |elem|
  			retVal += nested_array_to_javascript(elem)
  			retVal += ","
  		end

  		#Remove last comma from retVal
  		retVal = retVal[0...-1]

  		retVal += "]"
  	end

  	if option.kind_of?(String)
  		retVal += "\'" + option + "\'"
  	end

  	if option.kind_of?(Integer)
  		retVal += option.to_s()
  	end

  	return retVal
  end
end
