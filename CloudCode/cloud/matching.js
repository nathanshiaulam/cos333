// less than user distance = 5
// 0-3 miles more than user distance = 4
// 4-5 miles more than user distance = 3
// 6-10 miles more than user distance = 2
// more than 10 miles more than user distance = 1
function distance (lat1, lon1, lat2, lon2, user_dist) {
	rest_dist = computeDistance (lat1, lon1, lat2, lon2);
	if (rest_dist <= user_dist)
		return 5
	else if (rest_dist <= user_dist + 3)
		return 4
	else if (rest_dist <= user_dist + 5)
		return 3
	else if (rest_dist <= user_dist + 10)
		return 2
	else
		return 1
}

/* given point A (lat1, lon1) and point B (lat2, lon2), return the dist between the two points in miles*/
function computeDistance(lat1, lon1, lat2, lon2) {
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
    //need to categorize from 1 - 5 based on dist
    return dist
}

/* current time may be given as NSDate 
given array of open times in hours, check if restaurant is open
hours is a string in the format given by yelp,
and current_time is in __:__ format, military time*/
function isOpen (current_time, hours){
	if (hours.length == 0) {
		return true;
	}
	splitted = hours[current_time.getDay()].split(",", 5)
	current_hour = current_time.getHours()
	current_minute = current_time.getMinutes()
	for (var i = 0; i < splitted.length; i++) {
		line = splitted[i]
		if (line.indexOf("-") != -1) {
			start = line.substring(0, line.indexOf("-")-1)
			start_time = start.substring(0, start.indexOf(":") + 3)
			if (start.indexOf("pm") != -1)
				start_time += 12
			end = line.substring(line.indexOf("-") + 2, line.length)
			end_time = start.substring(0, end.indexOf(":") + 3)
			if (end.indexOf("pm") != -1)
				end_time += 12
			if (current_hour > start_time.substring(0, 2) && current_minute > start_time.substring(3, 5) &&
				current_hour < end_time.substring(0, 2) && current_minute < end_time.substring(3, 5))
				return true
		}
		//equivalent to open 24 hours
		else if (line == "24") {
			return true;
		}
		//equivalent to closed
		else if (line == "0") {
			return false;
		}
	}
	return false;
}

/* Yelp data has categories in array form, which includes the cuisine type */
/* preferences is a String representing cuisine type */
function checkCuisine(preferences, categories) {
	for (var j = 0; j < preferences.length; j++) {
		var pref = preference[j].toLowerCase();
		for (var i = 0; i < categories.length; i++) {
			if (categories[i].toLowerCase().indexOf(preference) != -1) {
				return true
			}
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

/* given a String of length 12 with the options (0,1,2), calculates their similarity*/
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

/* cost1 and cost2 are dollar sign strings */ 
function costDiff (cost1, cost2) {
	return abs(cost.length - cost2.length)
}

/*run a for loop over all open restaurants and get the score sortmin*/
function finsAllScore(){
	var restlist //list of restaurants sorted by their score
	return restlist
}