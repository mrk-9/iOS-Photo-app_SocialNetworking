Parse.Cloud.define("friend", function(request, response) {
                   var userToFriend = new Parse.User();
                   userToFriend.id = request.params.friendId;
                   
                   var roleName = "friendsOf_" + request.user.id;
                   var roleQuery = new Parse.Query("_Role");
                   roleQuery.equalTo("name", roleName);
                   roleQuery.first().then(function(role) {
                                          role.getUsers().add(userToFriend);
                                          return role.save();
                                          
                                          }).then(function() {
                                                  response.success("Success!");    
                                                  });
                   });