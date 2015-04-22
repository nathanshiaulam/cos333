/* given point A (lat1, lon1) and point B (lat2, lon2), return the dist between the two points in miles*/
function distance(lat1, lon1, lat2, lon2) {
    var radlat1 = Math.PI * lat1/180
    var radlat2 = Math.PI * lat2/180
    var radlon1 = Math.PI * lon1/180
    var radlon2 = Math.PI * lon2/180
    var theta = lon1-lon2
    var radtheta = Math.PI * theta/180
    var dist = Math.sin(radlat1) * Math.sin(radlat2) + Math.cos(radlat1) * Math.cos(radlat2) * Math.cos(radtheta);
    dist = Math.acos(dist)
    dist = dist * 180/Math.PI
    dist = dist * 60 * 1.1515
    return dist
}

/* current time may be given as NSDate */
/* given string for time, check if restaurant is open*/
/* assumes that day is an NSInteger representing day of week,
hours is a string in the format given by yelp,
and current_time is in __:__ format, military time*/
function isOpen (current_time, day, hours){
	splitted = hours.split(",", 5)
	for (var i = 0; i < 7; i++) {
		line = hours[i]
		if (line.indexOf("-") != -1) {
			start = line.substring(0, line.indexOf("-")-1)
			start_time = start.substring(0, start.indexOf(":") + 3)
			if (start.indexOf("pm") != -1)
				start_time += 12
			end = line.substring(line.indexOf("-") + 2, line.length)
			end_time = start.substring(0, end.indexOf(":") + 3)
			if (end.indexOf("pm") != -1)
				end_time += 12
			current_hour = current_time.substring(0, 2)
			current_minute = current_time.substring(3, 5)
			if (current_hour > start_time.substring(0, 2) && current_minute > start_time.substring(3, 5) &&
				current_hour < end_time.substring(0, 2) && current_minute < end_time.substring(3, 5))
				return true
		}
		else {
			return false
		}
	}
	return false
}

/* Yelp data has categories in array form, which includes the cuisine type */
/* preference is a String representing cuisine type */
function checkCuisine(preference, categories) {
	preference = preference.toLowerCase();
	for (var i = 0; i < categories.length; i++) {
		if (categories[i].toLowerCase().indexOf(preference) != -1) {
			return true
		}
	}
	return false
}

// use this for matching ambience, type of cuisine, and parking
function matchStringOption(rest_ambience, user_ambience) {
	splitted = rest_ambience.split(",", 5)
	user_split = user_ambience.split(",", 10)
	for (var i = 0; i < splitted.length; i++) {
		for (var j = 0; j < user_split.length; j++) {
			if (splitted[i].toLowerCase() == user_split[j].toLowerCase()) {
				return true
			}
		}
	}
	return false
}

/* given a String of length 12 with the options (0,1, 2), calculates their similarity*/
function compareOptions (rest_options, user_options) {
	total = 0
	for (var i = 0; i < 12; i++) {
		if (rest_options.charAt(i) == user_options.charAt(i))
			total++
		else if (rest_options.charAt(i) != 0 && user_options.charAt(i) != 0)
			total--
	}
	return total
}