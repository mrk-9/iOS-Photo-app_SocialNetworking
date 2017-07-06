//
//  ESMessengerView.h
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

#import "JSQMessages.h"
#import "IQAudioRecorderController.h"

@interface ESMessengerView : JSQMessagesViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, IQAudioRecorderControllerDelegate>

/**
 *  Custom init method because we need to pass some parameters.
 *
 *  @param _groupId  the id of the conversation
 *  @param _username the title that will be displayed in the navbar
 *
 *  @return id
 */
- (id)initWith:(NSString *)_groupId andName:(NSString *)_username;
/**
 *  Creating new message with an optional mediaItem.
 *
 *  @param messengerItem the dictionary of the message
 */
- (BOOL)addNewMessage:(NSDictionary *)messengerItem;
/**
 *  Update the messageView and tell it about the new message.
 *
 *  @param messengerItem dictionary of the messenger item
 */
- (void)updateMessage:(NSDictionary *)messengerItem;
/**
 *  Load the profile picture of the user.
 *
 *  @param senderId id of the user
 */
- (void)loadUserProfilePicture:(NSString *)senderId;
/**
 *  Send a new message with its content.
 *
 *  @param text    text of the message
 *  @param picture picture of the message
 *  @param video   video of the message
 *  @param audio   audio message
 */
- (void)sendMessage:(NSString *)text withPicture:(UIImage *)picture withVideo:(NSURL *)video andWithAudio:(NSString *)audio;
/**
 *  Save the message so that we don't loose it anymore.
 *
 *  @param messengerItem mutable dictionary of the message
 */
- (void)eventuallySaveMessage:(NSMutableDictionary *)messengerItem;
/**
 *  Update the Firebase because there is a new message.
 *
 *  @param messengerItem dictionary of the message
 */
- (void)updateFirebaseMessage:(NSDictionary *)messengerItem;

/**
 *  The other user has stopped typing, thus hide the typing indicator again.
 */
- (void)shouldStopTypingIndicator;
/**
 *  User has pressed the send button. We gather the information of the message item and call the sendMessage method.
 *
 *  @param button   the button that has been tapped
 *  @param text     text of the message
 *  @param senderId objectId of the PFUser that sent the message
 *  @param name     name of the PFUser that sent the message
 *  @param date     when the message has been sent
 */
- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)name date:(NSDate *)date ;
/**
 *  The user has pressed the accessorybutton, thus open a UIActionSheet where the user can decide what he wants to send
 */
- (void)didPressAccessoryButton:(UIButton *)sender;

@end
