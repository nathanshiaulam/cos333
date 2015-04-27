
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

// function to sort restscorearray
function sortfunction(a,b) {
	if (a.score == b.score)
		return 0;
	else
		return (a.score >= b.score) ? 1 :-1;
}

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
	var restscorearray = []; // scores associated with each restaurnt
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
		  		if (res.length !== 1000) {
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
	//ideally the numbers should be between 0 and 5
		var scaling = 5; //magic number to scale the values
		var w1 = 1;
		var w2 = 1;
		var w3 = 1;
		var w4 = 1;
		var rest = results[i];
		//dist
        var distval = helper.distance(rest.get("latitude"), rest.get("longitude"), currloc[0], currloc[1]);
        //cost
        var costval = helper.costDiff(rest.get("cost").len, cost);
        //cuisine
		var cuisineval = 0;
		if (helper.checkCuisine(cuisine, rest.get("categories")))
			cuisineval = 0;
		else
			cuisineval = scaling;
        //options and ambience
        var optionsval = scaling - helper.compareOptions(user.get("options"), rest.get("options"));
        if (helper.matchStringOption(user.get("ambience"), rest.get("ambience")))
			optionsval--;
		else optionsval++;

		//compute vector norm
		var restscore = Math.sqrt(Math.pow(distval*w1, 2)+Math.pow(costval*w2, 2)
				+Math.pow(optionsval*w3, 2)+Math.pow(cuisine*w4, 2));

		//adds the rest score pair to restscorearray
		restscorearray[restscorearray.length] = {id:res.get('business_id'), score: restscore};
    }

    // sort restscorearray by score
    restscorearray.sort(sortfunction);

    return restscorearray;
});

