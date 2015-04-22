
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.define("findRestaurant", function(request, response) {
<<<<<<< Updated upstream
  response.success("Hello world!");
});

Parse.Cloud.define("MatchRestaurant", function(request, response) {

});
=======
  	var distance = request.params.distance;
  	var currloc = request.params.loc;
  	var cost = request.params.cost;
  	var cuisine = request.params.cuisine;
  	var skipnum = 0;
	var query = new Parse.Query("Restaurant");
	var results = [];
	var foundall = false;
	while (!foundall) {
		query.limit(1000);
		query.skip(skipnum);
		query.find({
		  	success: function(res) {
		  		results = results.concat(res);
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
        var distbetween = 
    }
});
>>>>>>> Stashed changes
