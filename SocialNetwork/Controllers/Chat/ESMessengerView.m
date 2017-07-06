//
//  ESMessengerView.m
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "AFNetworking.h"
#import "ESAccountViewController.h"
#import "IDMPhotoBrowser.h"
#import "AppDelegate.h"
#import "AudioPackage.h"
#import "VideoPackage.h"
#import "ESMessengerView.h"
#import "SCLAlertView.h"
#import "JTSImageInfo.h"
#import "ProgressHUD.h"
#import "JTSImageViewController.h"
#import "TOWebViewController.h"
#import "ESTravelTimeline.h"

BOOL initialized;
int countIsTyping;

@interface ESMessengerView ()
{
    /**
     *  Id of the conversation, needed to identify it.
     */
    NSString *groupId;
    /**
     *  Title in the navigation bar.
     */
    NSString *username;
    /**
     *  Mutable array with the messages.
     */
    NSMutableArray *messages;
    /**
     *  Mutable array with the messenger items.
     */
    NSMutableArray *messengerItems;
    /**
     *  Mutable dictionary with the users' profile pictures.
     */
    NSMutableDictionary *profilePictures;
    /**
     *  Index of the message bubble in case the user selects one of the message bubbles.
     */
    NSIndexPath *selectedIndex;
    /**
     *  For every conversation exist two firebase object. This is the messages object.
     */
    Firebase *firebase1;
    /**
     *  For every conversation exist two firebase object. This is the typing object.
     */
    Firebase *firebase2;
    /**
     *  Image of an outgoing message bubble.
     */
    JSQMessagesBubbleImage *imgBubbleOutgoing;
    /**
     *  Image of an incoming message bubble.
     */
    JSQMessagesBubbleImage *imgBubbleIncoming;
    /**
     *  Placeholder of the users' profile picture, displayed as long as the users' pictures aren't loaded.
     */
    JSQMessagesAvatarImage *placeholderProfilePicture;
}
@end
@implementation ESMessengerView

- (id)initWith:(NSString *)_groupId andName:(NSString *)_username{
    self = [super init];
    groupId = _groupId;
    username = _username;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openLink:) name:@"openLinkInChat" object:nil];
    self.title = username;
    if ([groupId length] == 20) {
        NSString *firstName = [[username componentsSeparatedByString:@" "] objectAtIndex:0];
        self.title = firstName;
    } else 	{
        self.title = username;
    }
    messengerItems = [[NSMutableArray alloc] init];
    messages = [[NSMutableArray alloc] init];
    profilePictures = [[NSMutableDictionary alloc] init];
    PFUser *user = [PFUser currentUser];
    self.senderId = user.objectId;
    self.senderDisplayName = [user objectForKey:kESUserDisplayNameKey];
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    imgBubbleOutgoing = [bubbleFactory outgoingMessagesBubbleImageWithColor:MESSAGE_OUT_COLOUR];
    imgBubbleIncoming = [bubbleFactory incomingMessagesBubbleImageWithColor:MESSAGE_IN_COLOUR];
    placeholderProfilePicture = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"AvatarPlaceholderProfile.png"] diameter:30.0];
    firebase1 = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/Message/%@", kESChatFirebaseCredentialKey, groupId]];
    firebase2 = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/Typing/%@", kESChatFirebaseCredentialKey, groupId]];
    
    initialized = NO;
    self.automaticallyScrollsToMostRecentMessage = NO;
    
    [firebase1 observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        BOOL incoming = [self addNewMessage:snapshot.value];
        if (incoming) [self updateFirebaseMessage:snapshot.value];
        
        if (initialized)
        {
            if (incoming) [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
            [self finishReceivingMessage];
        }
    }];
    [firebase1 observeEventType:FEventTypeChildChanged withBlock:^(FDataSnapshot *snapshot) {
        [self updateMessage:snapshot.value];
    }];
    [firebase1 observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        [self finishReceivingMessage];
        [self scrollToBottomAnimated:NO];
        self.automaticallyScrollsToMostRecentMessage = YES;
        initialized	= YES;
    }];
    
    [firebase2 observeEventType:FEventTypeChildChanged withBlock:^(FDataSnapshot *snapshot) {
        if ([user.objectId isEqualToString:snapshot.key] == NO) {
            BOOL typing = [snapshot.value boolValue];
            self.showTypingIndicator = typing;
            if (typing) {
                [self scrollToBottomAnimated:YES];
            }
        }
    }];
    [firebase2 updateChildValues:@{user.objectId:@NO}];
    [ESUtility clearUnreadMessagesCounterFor:groupId];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.collectionView.collectionViewLayout.springinessEnabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isMovingFromParentViewController) {
        [ESUtility clearUnreadMessagesCounterFor:groupId];
        [firebase1 removeAllObservers];
        [firebase2 removeAllObservers];
    }
}
- (void)openLink:(NSNotification *)note {
    [self.inputToolbar.contentView.textView resignFirstResponder];
    NSDictionary *dict = note.userInfo;
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:[dict objectForKey:@"url"]];
    [self.navigationController pushViewController:webViewController animated:YES];
}
# pragma mark - Sending new messages

- (BOOL)addNewMessage:(NSDictionary *)messengerItem {
    JSQMessage *message;
    NSString *displayName = [messengerItem objectForKey:@"name"];
    NSString *userId = [messengerItem objectForKey:@"userId"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'zzz'"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *date = [formatter dateFromString:[messengerItem objectForKey:@"date"]];
    
    if ([[messengerItem objectForKey:@"type"] isEqualToString:@"text"]) {
        NSString *text = [messengerItem objectForKey:@"text"];
        message = [[JSQMessage alloc] initWithSenderId:userId senderDisplayName:displayName date:date text:text];
    }
    if ([[messengerItem objectForKey:@"type"] isEqualToString:@"picture"]) {
        JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:nil];
        photoItem.appliesMediaViewMaskAsOutgoing = [userId isEqualToString:self.senderId];
        message = [[JSQMessage alloc] initWithSenderId:userId senderDisplayName:displayName date:date media:photoItem];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[messengerItem objectForKey:@"picture"]]];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFImageResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            photoItem.image = (UIImage *)responseObject;
            [self.collectionView reloadData];
        }  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"createNewPhotoMessage picture load error.");
        }];
        [[NSOperationQueue mainQueue] addOperation:operation];
    }
    if ([[messengerItem objectForKey:@"type"] isEqualToString:@"video"]) {
        VideoPackage *videoItem = [[VideoPackage alloc] initWithFileURL:[NSURL URLWithString:[messengerItem objectForKey:@"video"]] rdyToPlay:NO];
        videoItem.appliesMediaViewMaskAsOutgoing = [userId isEqualToString:self.senderId];
        message = [[JSQMessage alloc] initWithSenderId:userId senderDisplayName:displayName date:date media:videoItem];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:messengerItem[@"thumbnail"]]];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFImageResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            videoItem.rdyToPlay = YES;
            videoItem.img = (UIImage *)responseObject;
            [self.collectionView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"createNewVideoMessage picture load error.");
        }];
        [[NSOperationQueue mainQueue] addOperation:operation];
    }
    if ([[messengerItem objectForKey:@"type"] isEqualToString:@"audio"]) {
        AudioPackage *audioItem = [[AudioPackage alloc] initWithFileURL:[NSURL URLWithString:[messengerItem objectForKey:@"audio"]] Duration:[messengerItem objectForKey:@"duration"]];
        audioItem.appliesMediaViewMaskAsOutgoing = [userId isEqualToString:self.senderId];
        message = [[JSQMessage alloc] initWithSenderId:userId senderDisplayName:displayName date:date media:audioItem];
        
    }
    [messengerItems addObject:messengerItem];
    [messages addObject:message];
    return ([message.senderId isEqualToString:self.senderId] == NO);
}

- (void)updateMessage:(NSDictionary *)messengerItem {
    for (int i=0; i<[messengerItems count]; i++) {
        NSDictionary *temp = [messengerItems objectAtIndex:i];
        if ([[messengerItem objectForKey:@"key"] isEqualToString:[temp objectForKey:@"key"]]) {
            messengerItems[i] = messengerItem;
            break;
        }
    }
    [self.collectionView reloadData];
}

- (void)loadUserProfilePicture:(NSString *)senderId {
    PFQuery *query = [PFQuery queryWithClassName:kESUserClassNameKey];
    [query whereKey:kESUserObjectIdKey equalTo:senderId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error == nil) {
            if ([objects count] != 0) {
                PFUser *user = [objects firstObject];
                PFFile *file = [user objectForKey:kESUserProfilePicSmallKey];
                [file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                    if (error == nil) {
                        UIImage *image = [UIImage imageWithData:imageData];
                        profilePictures[senderId] = [JSQMessagesAvatarImageFactory avatarImageWithImage:image diameter:30.0];
                        [self.collectionView reloadData];
                    }
                }];
            }
        }
    }];
}

- (void)sendMessage:(NSString *)text withPicture:(UIImage *)picture withVideo:(NSURL *)video andWithAudio:(NSString *)audio {
    
    PFUser *currentUser = [PFUser currentUser];
    NSMutableDictionary *messengerItem = [[NSMutableDictionary alloc] init];
    [messengerItem setObject:currentUser.objectId forKey:@"userId"];
    [messengerItem setObject:[currentUser objectForKey:kESUserDisplayNameKey] forKey:@"name"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'zzz'"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [messengerItem setObject:[formatter stringFromDate:[NSDate date]] forKey:@"date"];
    [messengerItem setObject:@"Delivered" forKey:@"status"];
    [messengerItem setObject:@"" forKey:@"picture"];
    [messengerItem setObject:@"" forKey:@"thumbnail"];
    [messengerItem setObject:@"" forKey:@"video"];
    [messengerItem setObject:@"" forKey:@"audio"];
    [messengerItem setObject:@0 forKey:@"duration"];
    
    if (text != nil) {
        [messengerItem setObject:text forKey:@"text"];
        [messengerItem setObject:@"text" forKey:@"type"];
        [self eventuallySaveMessage:messengerItem];
    }
    else if (picture != nil) {
        [ProgressHUD show:@"Sending" Interaction:NO];
        PFFile *file = [PFFile fileWithName:@"picture.jpg" data:UIImageJPEGRepresentation(picture, 0.6)];
        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error == nil) {
                [messengerItem setObject:file.url forKey:@"picture"];
                [messengerItem setObject:[NSString stringWithFormat:NSLocalizedString(@"%@ sent a picture", nil),[currentUser objectForKey:kESUserDisplayNameKey]] forKey:@"text"];
                [messengerItem setObject:@"picture" forKey:@"type"];
                [ProgressHUD dismiss];
                [self eventuallySaveMessage:messengerItem];
                
            }
            else {
                NSLog(@"sendPictureMessage picture save error.");
                [ProgressHUD showError:@"Error"];
            }
        }];
    }
    else if (video != nil) {
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:video.path error:nil];
        unsigned long long fileSize = [attributes fileSize]; // result would be in bytes
        
        if(fileSize <= 10485760) {
            
            [ProgressHUD show:@"Sending" Interaction:NO];
            UIImage *picture = [ESUtility createThumbnailForVideo:video];
            UIImage *squared = [ESUtility createSquareImageForImage:picture withSize:320];
            NSNumber *duration = [ESUtility durationForVideo:video];
            PFFile *fileThumbnail = [PFFile fileWithName:@"picture.jpg" data:UIImageJPEGRepresentation(squared, 0.6)];
            [fileThumbnail saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error == nil) {
                    PFFile *fileVideo = [PFFile fileWithName:@"video.mp4" data:[[NSFileManager defaultManager] contentsAtPath:video.path]];
                    [fileVideo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (error == nil) {
                            [messengerItem setObject:fileVideo.url forKey:@"video"];
                            [messengerItem setObject:fileThumbnail.url forKey:@"thumbnail"];
                            [messengerItem setObject:duration forKey:@"duration"];
                            [messengerItem setObject:[NSString stringWithFormat:NSLocalizedString(@"%@ sent a video", nil),[currentUser objectForKey:kESUserDisplayNameKey]] forKey:@"text"];
                            [messengerItem setObject:@"video" forKey:@"type"];
                            
                            [self eventuallySaveMessage:messengerItem];
                            [ProgressHUD dismiss];
                        }
                        else {
                            [ProgressHUD showError:@"Error"];
                            NSLog(@"sendVideoMessage video save error.");
                        }
                    }];
                }
            }];
        }else{
            [ProgressHUD showError:@"Video is too long for upload"];
        }
        
    }
    else if (audio != nil) {
        NSNumber *duration = [ESUtility durationAudioMessage:audio];
        PFFile *file = [PFFile fileWithName:@"audio.m4a" data:[[NSFileManager defaultManager] contentsAtPath:audio]];
        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error == nil) {
                [messengerItem setObject:file.url forKey:@"audio"];
                [messengerItem setObject:duration forKey:@"duration"];
                [messengerItem setObject:[NSString stringWithFormat:NSLocalizedString(@"%@ sent a recorded message", nil),[currentUser objectForKey:kESUserDisplayNameKey]] forKey:@"text"];
                [messengerItem setObject:@"audio" forKey:@"type"];
                
                [self eventuallySaveMessage:messengerItem];
            }
        }];    }
}
- (void)eventuallySaveMessage:(NSMutableDictionary *)messengerItem {
    
    Firebase *reference = [firebase1 childByAutoId];
    [messengerItem setObject:reference.key forKey:@"key"];
    [reference setValue:messengerItem];
    [ESUtility deliverPushTo:groupId withText:[messengerItem objectForKey:@"text"]];
    [ESUtility resetUnreadMessagesCounterFor:groupId withCounter:1 andLastMessage:[messengerItem objectForKey:@"text"]];
    [ESUtility setDeliveredForMessage:groupId andString:NSLocalizedString(@"Delivered", nil)];
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    [self finishSendingMessage];
}

- (void)updateFirebaseMessage:(NSDictionary *)messengerItem {
    
    NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"readreceipt"]) {
        if ([messengerItem[@"status"] isEqualToString:@"Read"] == NO)
        {
            [[firebase1 childByAppendingPath:messengerItem[@"key"]] updateChildValues:@{@"status":@"Read"} withCompletionBlock:^(NSError *error, Firebase *ref)
             {
                 if (error != nil) NSLog(@"messageUpdate network error.");
             }];
            [ESUtility setReadForMessage:groupId andString:NSLocalizedString(@"Read",nil)];
        }
    }
    
}
# pragma mark - IQAudioRecorderController delegates

- (void)audioRecorderController:(IQAudioRecorderController *)controller didFinishWithAudioAtPath:(NSString *)path {
    [self sendMessage:nil withPicture:nil withVideo:nil andWithAudio:path];
}
- (void)audioRecorderControllerDidCancel:(IQAudioRecorderController *)controller {
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSURL *video = info[UIImagePickerControllerMediaURL];
    UIImage *picture = info[UIImagePickerControllerOriginalImage];
    [self sendMessage:nil withPicture:picture withVideo:video andWithAudio:nil];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    countIsTyping = countIsTyping + 1;
    PFUser *currentUser = [PFUser currentUser];
    [firebase2 updateChildValues:@{currentUser.objectId:@YES}];
    [self performSelector:@selector(shouldStopTypingIndicator) withObject:nil afterDelay:2.0];
    return YES;
}
- (void)shouldStopTypingIndicator {
    countIsTyping = countIsTyping - 1;
    if (countIsTyping == 0) {
        PFUser *currentUser = [PFUser currentUser];
        [firebase2 updateChildValues:@{currentUser.objectId:@NO}];
    }
}

#pragma mark- JSQMessagesViewController

- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)name date:(NSDate *)date {
    [self sendMessage:text withPicture:nil withVideo:nil andWithAudio:nil];
}

- (void)didPressAccessoryButton:(UIButton *)sender {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil
                                               otherButtonTitles:NSLocalizedString(@"Take photo or video", nil), NSLocalizedString(@"Choose existing photo", nil),NSLocalizedString(@"Choose existing video", nil),NSLocalizedString(@"Record audio", nil), nil];
    action.tag = 2;
    [action showInView:self.view];
}

#pragma mark- JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return messages[indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = [messages objectAtIndex:indexPath.item];
    if ([message.senderId isEqualToString:self.senderId] == YES) {
        return imgBubbleOutgoing;
    }
    else {
        return imgBubbleIncoming;
    }
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = messages[indexPath.item];
    if (profilePictures[message.senderId] == nil) {
        [self loadUserProfilePicture:message.senderId];
        return placeholderProfilePicture;
    }
    else return profilePictures[message.senderId];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item % 3 == 0) {
        JSQMessage *message = messages[indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    else return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = [messages objectAtIndex:indexPath.item];
    if ([message.senderId isEqualToString:self.senderId] == NO) {
        if (indexPath.item > 0) {
            JSQMessage *previous = messages[indexPath.item-1];
            if ([previous.senderId isEqualToString:message.senderId]) {
                return nil;
            }
        }
        return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
    }
    else return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = [messages objectAtIndex:indexPath.item];
    if ([message.senderId isEqualToString:self.senderId] == YES) {
        NSDictionary *messengerItem = messengerItems[indexPath.item];
        return [[NSAttributedString alloc] initWithString:[messengerItem objectForKey:@"status"]];
    }
    else return nil;
}

# pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    JSQMessage *message = [messages objectAtIndex:indexPath.item];
    if ([message.senderId isEqualToString:self.senderId] == YES) {
        cell.textView.textColor = [UIColor whiteColor];
    }
    else {
        cell.textView.textColor = [UIColor blackColor];
    }
    return cell;
}

# pragma mark - JSQMessagesCollectionView layout delegate

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    else return 0;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = [messages objectAtIndex:indexPath.item];
    if ([message.senderId isEqualToString:self.senderId] == NO) {
        if (indexPath.item > 0) {
            JSQMessage *previous = messages[indexPath.item-1];
            if ([previous.senderId isEqualToString:message.senderId]) {
                return 0;
            }
        }
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    else return 0;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = [messages objectAtIndex:indexPath.item];
    if ([message.senderId isEqualToString:self.senderId] == YES) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    else return 0;
}

# pragma mark - Responding to JSQCollectionView taps

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender {
    //implement functionality
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView
           atIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *messageItem = messages[indexPath.item];
    PFQuery *userQuery = [PFUser query];
    [ProgressHUD show:NSLocalizedString(@"Loading", nil)];
    [userQuery getObjectInBackgroundWithId:messageItem.senderId block:^(PFObject *object, NSError *error){
        [ProgressHUD dismiss];
        if (!error) {
            PFUser *tappedUser = (PFUser *)object;
            ESAccountViewController *accountViewController = [[ESAccountViewController alloc] initWithStyle:UITableViewStylePlain];
            [accountViewController setUser:tappedUser];
            self.tabBarController.tabBar.hidden = NO;
            [self.tabBarController setSelectedIndex:0];
            UINavigationController *navController = [self.tabBarController.viewControllers objectAtIndex:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [navController pushViewController:accountViewController animated:YES];
            });
        }
    }];
    
    
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath {
  	 JSQMessage *message = [messages objectAtIndex:indexPath.item];
    if ([message.senderId isEqualToString:self.senderId] == YES) {
        NSDictionary *messengerItem = messengerItems[indexPath.item];
        if ([[messengerItem objectForKey:@"status"] isEqualToString:@"Read"] == NO) {
            selectedIndex = indexPath;
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"Delete message", nil) otherButtonTitles:nil];
            action.tag = 1;
            [action showInView:self.view];
            return;
        }
    }
    if (message.isMediaMessage) {
        if ([message.media isKindOfClass:[JSQPhotoMediaItem class]]) {
            JSQPhotoMediaItem *mediaItem = (JSQPhotoMediaItem *)message.media;
            
            JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
#if TRY_AN_ANIMATED_GIF == 1
            imageInfo.imageURL = [NSURL URLWithString:@"http://media.giphy.com/media/O3QpFiN97YjJu/giphy.gif"];
#else
            imageInfo.image = mediaItem.image;
#endif
            imageInfo.referenceRect = CGRectMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2, 0, 0);
            imageInfo.referenceView = self.view;
            imageInfo.referenceContentMode = UIViewContentModeScaleAspectFit;
            imageInfo.referenceCornerRadius = 10;
            
            // Setup view controller
            JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                                   initWithImageInfo:imageInfo
                                                   mode:JTSImageViewControllerMode_Image
                                                   backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
            
            // Present the view controller.
            [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
        }
        if ([message.media isKindOfClass:[VideoPackage class]]) {
            VideoPackage *videoItem = (VideoPackage *)message.media;
            MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:videoItem.fileURL];
            [self presentMoviePlayerViewControllerAnimated:moviePlayer];
            [moviePlayer.moviePlayer play];
        }
        if ([message.media isKindOfClass:[AudioPackage class]]) {
            AudioPackage *audioItem = (AudioPackage *)message.media;
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
            MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:audioItem.fileURL];
            [self presentMoviePlayerViewControllerAnimated:moviePlayer];
            [moviePlayer.moviePlayer play];
        }
    }
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation {
    NSLog(@"didTapCellAtIndexPath %@", NSStringFromCGPoint(touchLocation));
}

#pragma mark- UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 1) {
        if (buttonIndex != actionSheet.cancelButtonIndex) {
            NSDictionary *messengerItem = messengerItems[selectedIndex.item];
            [[firebase1 childByAppendingPath:[messengerItem objectForKey:@"key"]] removeValue];
            [messengerItems removeObjectAtIndex:selectedIndex.item];
            [messages removeObjectAtIndex:selectedIndex.item];
            [self.collectionView reloadData];
            NSDictionary *last = [messengerItems lastObject];
            NSString *lastMessage = @"";
            if (last != nil) {
                lastMessage = [last objectForKey:@"text"];
            }
            [ESUtility resetUnreadMessagesCounterFor:groupId withCounter:1 andLastMessage:lastMessage];
        }
    }
    if (actionSheet.tag == 2) {
        if (buttonIndex != actionSheet.cancelButtonIndex) {
            if (buttonIndex == 0) {
                [ESUtility shouldPresentPhotoAndVideoCamera:self editable:YES];
            }
            if (buttonIndex == 1) {
                [ESUtility shouldPresentPhotoLibrary:self editable:NO];
            }
            if (buttonIndex == 2) {
                [ESUtility shouldPresentVideoLibrary:self editable:YES];
            }
            if (buttonIndex == 3) {
                IQAudioRecorderController *controller = [[IQAudioRecorderController alloc] init];
                controller.delegate = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:controller animated:YES completion:nil];
                });
            }
            if (buttonIndex == 4) {
                [self sendMessage:nil withPicture:nil withVideo:nil andWithAudio:nil];
            }
        }
    }
}


@end
