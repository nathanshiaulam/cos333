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
    //need to categorize from 1 - 5 based on dist
    return dist
}

/* current time may be given as NSDate 
given array of open times in hours, check if restaurant is open
hours is a string in the format given by yelp,
and current_time is in __:__ format, military time*/
<<<<<<< Updated upstream:matching.js
function isOpen (current_hour, current_minute, day, hours){
	splitted = hours.split(",", 5)
	for (var i = 0; i < 7; i++) {
		line = hours[i]
=======
function isOpen (current_time, hours){
	if (hours.length == 0) {
		return true;
	}
	splitted = hours[current_time.getDay()].split(",", 5)
	current_hour = current_time.getHours()
	current_minute = current_time.getMinutes()
	for (var i = 0; i < splitted.length; i++) {
		line = splitted[i]
>>>>>>> Stashed changes:CloudCode/cloud/matching.js
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
/* preference is a String representing cuisine type */
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

/* returns the similarity score given user vector and rstaurant data */
function giveSimScore(user, restaurant) {
	//ideally the numbers should be between 0 and 5
	var scaling = 5 //magic number to scale the values
	var difdist = 0
	var difcost = 0
	var difoptions = 0
	var difcuisine = 0
	var weights = [w1,w2,w3,w4]
	var score = 0

	//cost
	difcost = costDiff(user["cost"], restaurant["cost"])
	//distance
	difdist = costDist(user["dist"], restaurant["dist"])
	//options and ambience
	difoptions = 5 - compareOptions(user["options"], restaurant["options"])
	if (matchStringOption(user["ambience]", restaurant["ambience"]))
		difoptions--
	else difoptions++
	//cuisine match
	if (checkCuisine(user["cuisine"], restaurant["cuisine"])
		difcuisine = 0
	else difcuisine = scaling
	
	//compute vector norm
	score = Math.sqrt((Math.pow(difdist*w1, 2))+Math.pow(difcost*w2, 2))
				+Math.pow(difoptions*w3, 2))+Math.pow(difcuisine*w4, 2)))
	
	return score
}

/*run a for loop over all open restaurants and get the score sortmin*/
function finsAllScore(){
	var restlist //list of restaurants sorted by their score
	return restlist
}