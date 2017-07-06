Parse.Cloud.afterSave(Parse.User, function(request, response) {
                      var user = request.object;
                      if (user.existed()) { return; }
                      var roleName = "friendsOf_" + user.id;
                      var friendRole = new Parse.Role(roleName, new Parse.ACL(user));
                      return friendRole.save().then(function(friendRole) {
                                                    var acl = new Parse.ACL();
                                                    acl.setReadAccess(friendRole, true);
                                                    acl.setReadAccess(user, true);
                                                    acl.setWriteAccess(user, true);
                                                    var friendData = new Parse.Object("FriendData", {
                                                                                      user: user,
                                                                                      ACL: acl,
                                                                                      profile: "my friend profile"
                                                                                      });
                                                    return friendData.save();
                                                    });
                      });