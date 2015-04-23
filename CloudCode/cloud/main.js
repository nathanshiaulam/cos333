
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

/*request should have the following parameters
*distance: int 1 - 5
*cost: int 1 - 4
*loc: double array of coordinates
*cuisine: string array of cuisine preferences
*/

Parse.Cloud.define("MatchRestaurant", function(request, response) {
	var helper = require('cloud/helper.js');
  	var distance = request.params.distance;
  	var currloc = request.params.loc;
  	var cost = request.params.cost;
  	var cuisine = request.params.cuisine;
  	var skipnum = 0;
	var query = new Parse.Query("Restaurant");
	var results = [];
	var foundall = false;
	var currentdate = new Date();
	//gets everything that's open
	while (!foundall) {
		query.limit(1000);
		query.skip(skipnum);
		query.find({
		  	success: function(res) {
				for (var i = 0; i < res.length; ++i) {
				    if (helper.isOpen(currentdate, res[i].get("Hours"))) {
				    	results.concat(res[i])
				    }
				}
		  		if (res.length !=== 1000) {
		  			foundall = true;
		  		}
		  	},
		  	error: function(error) {
		    	alert("Error: " + error.code + " " + error.message);
		  	}
		});
		skipnum = skipnum + 1000;
	}
	for (var i = 0; i < results.length; ++i) {
		var rest = results[i];
        var distval = helper.distance(rest.get("latitude"), rest.get("longitude"), currloc[0], currloc[1]);
        var costval = helper.costDiff(rest.get("cost").len, cost);
        var categoryval = helper.checkCuisine(cuisine, rest.get("categories"));

    }
});

