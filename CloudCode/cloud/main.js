/*---------------All helper functions here----------------------*/

// less than user distance = 5
// 0-3 miles more than user distance = 4
// 4-5 miles more than user distance = 3
// 6-10 miles more than user distance = 2
// more than 10 miles more than user distance = 1
function distanceeval(lat1, lon1, lat2, lon2, user_dist) {
   rest_dist = computeDistance (lat1, lon1, lat2, lon2);
   if (rest_dist <= user_dist)
      return 1
   else if (rest_dist <= user_dist + 3)
      return 2
   else if (rest_dist <= user_dist + 5)
      return 3
   else if (rest_dist <= user_dist + 10)
      return 4
   else
      return 5
}

/* given point A (lat1, lon1) and point B (lat2, lon2), return the dist between the two points in miles*/
function computeDistance1(lat1, lon1, lat2, lon2) {
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

function computeDistance(lat1, lon1, lat2, lon2) {
    var point1 = new Parse.GeoPoint(lat1, lon1);
    var point2 = new Parse.GeoPoint(lat2, lon2);
    return point1.milesTo(point2);
}

/* current time may be given as NSDate 
given array of open times in hours, check if restaurant is open
hours is a string in the format given by yelp,
and current_time is in __:__ format, military time*/
function isOpen (current_time, current_day, hours){
   if (hours.length == 0) {
      return true;
   }
   splitted = hours[current_day].split(",", 5)
   current_hour = parseInt(current_time.substring(0, 2));
   current_minute = parseInt(current_time.substring(3));
   for (var i = 0; i < splitted.length; i++) {
      line = splitted[i]
      if (line.indexOf("-") != -1) {
         start = line.substring(0, line.indexOf("-"))
         start_hour = parseInt(start.substring(0, start.indexOf(":")))
         start_min = parseInt(start.substring(start.indexOf(":") + 1, start.indexOf(":") + 3))
         if (start.indexOf("pm") != -1)
            start_hour += 12
         end = line.substring(line.indexOf("-") + 1, line.length)
         end_hour = parseInt(end.substring(0, end.indexOf(":")))
         end_min = parseInt(end.substring(end.indexOf(":")+1, end.indexOf(":")+3))
         if (end.indexOf("pm") != -1)
            end_hour += 12
         if (current_hour >= start_hour && current_hour < end_hour)
            return true
      }
      //equivalent to open 24 hours
      else if (line === "24") {
         return true;
      }
      //equivalent to closed
      else if (line === "0") {
         return false;
      }
   }
   return false;
}

/* Yelp data has categories in array form, which includes the cuisine type */
/* preferences is a String representing cuisine type */
function checkCuisine(preferences, categories) {
   for (var j = 0; j < preferences.length; j++) {
      var pref = preferences[j].toLowerCase();
      for (var i = 0; i < categories.length; i++) {
         if (categories[i].toLowerCase() === pref) {
            return true
         }
      }
   }
   return false
}

// use this for matching ambience, type of cuisine, and parking
function matchStringOption(rest_ambience, user_ambience) {
   for (var i = 0; i < rest_ambience.length; i++) {
      for (var j = 0; j < user_ambience.length; j++) {
         if (rest_ambience[i].toLowerCase() === user_ambience[j].toLowerCase()) {
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
      if (rest_options.charAt(i) !== "0") {
         if ((rest_options.charAt(i) === user_options.charAt(i)))
            total++
         else if (rest_options.charAt(i) !== 0 && user_options.charAt(i) !== 0)
            total--
      }
   }
   return total
}

/* cost1 and cost2 are dollar sign strings */ 
function costDiff (cost1, cost2) {
   return Math.abs(cost1 - cost2)
}

/*run a for loop over all open restaurants and get the score sortmin*/
function finsAllScore(){
   var restlist //list of restaurants sorted by their score
   return restlist
}


// function to sort restscorearray
function sortfunction(a,b) {
   if (a.score == b.score)
      return 0;
   else
      return (a.score >= b.score) ? 1 :-1;
}

/*------------------------------------------------------------------------------*/

/*request should have the following parameters
*distance: int 1 - 5
*cost: int 1 - 4
*loc: double array of coordinates
*cuisine: string array of cuisine preferences
*/

Parse.Cloud.define("MatchRestaurant", function(request, response) {
   
   var currloc = request.params.loc; //double array
   var query = new Parse.Query("Restaurants");
   var prefquery = new Parse.Query("Preferences");
   var results = [];
   var restscorearray = []; // scores associated with each restaurnt
   var ans = [];
   
   query.limit(1000);

   var lat = parseFloat(currloc[0]);
   var lon = parseFloat(currloc[1]);
   //filter by coordinates
   query.greaterThan("latitude", lat - .5);
   query.lessThan("latitude", lat + .5);
   query.greaterThan("longitude", lon - .5);
   query.lessThan("longitude", lon + .5);

   prefquery.get(request.params.objid[0], {
      success: function(pref) {
         query.find({
            success: function(res) {
               var time = request.params.currtime[0] //string
               var dayofweek = parseInt(request.params.day[0]) //int
               //find all restaurants that are open
               for (var i = 0; i < res.length; ++i) {
                  if (isOpen(time, dayofweek, res[i].get("hours")) && res[i].id.toString() !== "3ciH3tuf3m") {
                     results[results.length] = res[i];
                  }
               }
               //find vector score for all matching restaurants
               for (var i = 0; i < results.length; ++i) {
                  var distance = pref.get("Distance"); //int of distance category
                  var cost = pref.get("Cost"); //dollar sign string
                  var cuisine = pref.get("Cuisine"); //string array
                  var options = pref.get("Options"); //string
                  var ambience = pref.get("Ambience"); //string

                  //ideally the numbers should be between 0 and 5
                  var scaling = 5; //magic number to scale the values
                  var distweight = 1;
                  var costweight = 1;
                  var optionsweight = 1;
                  var cuisineweight = 1.5;
                  var rest = results[i];
                  //dist
                  var distval = distanceeval(rest.get("latitude"), rest.get("longitude"), currloc[0], currloc[1], distance);
                  //cost
                  var costval = costDiff(rest.get("cost").length, cost);
                  //cuisine
                  var cuisineval = 0;
                  if (checkCuisine(cuisine, rest.get("categories")))
                     cuisineval = 0;
                  else
                     cuisineval = scaling;
                  //options and ambience
                  var optionsval = scaling - compareOptions(options, rest.get("options"));
                  if (matchStringOption(ambience, rest.get("ambience")))
                     optionsval--;
                  else optionsval++;

                  //compute vector norm
                  var restscore = Math.sqrt(Math.pow(distval*distweight, 2)+Math.pow(costval*costweight, 2)+Math.pow(optionsval*optionsweight, 2)+Math.pow(cuisineval*cuisineweight, 2));
                  //adds the rest score pair to restscorearrays
                  restscorearray[restscorearray.length] = {name: rest.get("url"), score: restscore, objid: rest.id.toString()};

               }
               // sort restscorearray by score
               restscorearray.sort(sortfunction);
               var len = 20;
               if (restscorearray.length < 20) {
                  len = 20;
               }
               for (var i = 0; i < len; i++) {
                  ans[ans.length] = restscorearray[i]["objid"];
               }
               if (ans.length === 0) {
                  ans[0] = "3ciH3tuf3m";
               }
               response.success(ans);
            },
            error: function(error) {
               alert("Error: " + error.code + " " + error.message);
            }  
         });
      },
      error: function(error) {
         alert("Error: " + error.code + " " + error.message);
      }
   });
});

// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});
