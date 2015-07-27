<<<<<<< HEAD
=======
module EventsHelper
  def closest_half_hour(minute_offset = 0)
    # Ok I spent 30 minutes trying to figure this out but apparently
    # %l returns the hour with some leading whitespace - you need to
    # use .lstrip in order to trim it off the top in order to get it
    # to compare nicely.
    Time.at((Time.now.advance(:minutes => minute_offset*30).to_f / (30*60) ).round * 30*60).strftime("%H:%M").lstrip
  end

  def get_check_id(name)
    'check-' + name.downcase
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
>>>>>>> cleanup
