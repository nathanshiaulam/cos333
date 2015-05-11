/*-----------Send email-----------------------------------*/

Parse.Cloud.define("sendMail", function(request, response) {
   var Mandrill = require('mandrill');
   Mandrill.initialize('LtpBZu58pKUpHSie8dPTxw');

   var prefquery = new Parse.Query("User");
   prefquery.equalTo("email", request.params.email);
   prefquery.find({
      success: function(results) {


         Mandrill.sendEmail({
         message: {
         text: "Your password is: " + results.password,
         subject: "Your Noms account password",
         from_email: "evelynjding@gmail.com",
         from_name: "Noms App",
         to: [
         {
         email: request.params.email,
            name: "Noms User"
         }
         ]
         },
         
         async: true
         },{
         success: function(httpResponse) {
         console.log(httpResponse);
         response.success("Email sent!");
         },
         error: function(httpResponse) {
         console.error(httpResponse);
         response.error("Uh oh, something went wrong");
         }
         });
      },
      error: function(error) {
         alert("Error: " + error.code + " " + error.message);
      }
});
});

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

// Yelp data has categories in array form, which includes the cuisine type 
// preferences is a String representing cuisine type 
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

// given a String of length 12 with the options (0,1,2), calculates their similarity
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

// cost1 and cost2 are dollar sign strings
function costDiff (cost1, cost2) {
   return Math.abs(cost1 - cost2)
}

//run a for loop over all open restaurants and get the score sortmin
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

//change weights if user rejects a restaurant
Parse.Cloud.define("ChangeWeights", function(request, response) {
   var currpref = new Parse.Query("Preferences");
   var currrest = new Parse.Query("Restaurants");
   var currloc = request.params.loc; //double array

   currpref.get(request.params.prefid[0], {
      success: function(pref) {
         currrest.get(request.params.restid[0], {
            success: function(rest) {
               var scaling = 5;
               var prefdist = pref.get("Distance");
               var prefcost = pref.get("Cost");
               var prefoptions = pref.get("Options");
               var prefcuisine = pref.get("Cuisine");
               var prefdist = pref.get("Distance");

               //dist
               var distval = computeDistance(rest.get("latitude"), rest.get("longitude"), currloc[0], currloc[1]);
               //cost
               var costval = costDiff(rest.get("cost").length, prefcost);
               //cuisine
               var cuisineval = 0;
               if (checkCuisine(prefcuisine, rest.get("categories")))
                  cuisineval = 0;
               else
                  cuisineval = scaling;
               //options
               var optionsval = compareOptions(prefoptions, rest.get("options"));

               var weights = pref.get("Weights");
               //change weights hierarchically
               if (cuisineval != 0) {
                  weights[3]+=0.05;
               }
               else if (distval > prefdist) {
                  weights[0]+=0.05;
               }
               else if (costval != 0) {
                  weights[1]+=0.05;
               }
               else {
                  weights[2]+=0.05;
               };

               pref.set("Weights", weights);
               pref.save(null,{
                  success: function (object) { 
                    response.success(object);
                  }, 
                  error: function (object, error) { 
                     response.error(error);
                  }
               });
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

                  // ideally the numbers should be between 0 and 5
                  var scaling = 5; //magic number to scale the values
                  // weights of preferences
                  var distweight = pref.get("Weights")[0];
                  var costweight = pref.get("Weights")[1];
                  var optionsweight = pref.get("Weights")[2];
                  var cuisineweight = pref.get("Weights")[3];
                  // loop over restaurants
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
                  if (rest.get("big_img_url") !== "")
                     restscorearray[restscorearray.length] = {name: rest.get("url"), score: restscore, objid: rest.id.toString()};

               }
               // sort restscorearray by score
               restscorearray.sort(sortfunction);
               var len = 20;
               if (restscorearray.length < 20) {
                  len = restscorearray;
               }
               for (var i = 0; i < len; i++) {
                  ans[ans.length] = restscorearray[i]["objid"];
               }
               if (ans.length === 0) {
                  ans[0] = "AcrRPC4Bmf";
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
