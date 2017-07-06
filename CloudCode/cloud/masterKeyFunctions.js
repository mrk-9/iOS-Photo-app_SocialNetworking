/*Parse.Cloud.define('editUser', function(request, response) {
    var userId = request.params.userId,
        newColText = request.params.newColText;

    var User = Parse.Object.extend('_User'),
        user = new User({ objectId: userId });
        
    Parse.Cloud.useMasterKey();
	var secondQuery = new Parse.Query("SensitiveData");
 secondQuery.equalTo("user", user);
 secondQuery.first({
  success: function(object) {
	var email = object.get('email');
	user.set('email', email);
    user.set('emailChanged', 'YES');

    user.save().then(function(user) {
        response.success(user);
    }, function(error) {
        response.error(error)
    });
  },
  error: function(error) {
    alert("Error: " + error.code + " " + error.message);
  }
});
    
});*/