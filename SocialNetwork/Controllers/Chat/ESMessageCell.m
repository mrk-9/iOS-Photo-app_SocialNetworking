//
//  ESMessageCell.h
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

#import "ESMessageCell.h"
#import "JSBadgeView.h"

@implementation ESMessageCell

@synthesize imgUser, description, lastMessage, elapsed, readLabel, badgeView, dummyView;

- (void)feedTheCell:(NSDictionary *)dummy_message
{
    message = dummy_message;
    imgUser.layer.cornerRadius = imgUser.frame.size.width/2;
    imgUser.layer.masksToBounds = YES;
    dummyView = [[UIView alloc]init];
    dummyView.frame = imgUser.frame;
    dummyView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:dummyView];
    if ([message[@"groupId"] length] == 20) {
        [imgUser setImage:[UIImage imageNamed:@"AvatarPlaceholderProfile"]];
        NSString *groupId = message[@"groupId"];
        NSString *otherUserId = [groupId stringByReplacingOccurrencesOfString:[PFUser currentUser].objectId withString:@""];
        PFQuery *query = [PFQuery queryWithClassName:kESUserClassNameKey];
        [query whereKey:kESUserObjectIdKey equalTo:otherUserId];
        [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             if (error == nil)
             {
                 PFUser *user = [objects firstObject];
                 if ([user objectForKey:kESUserProfilePicMediumKey]) {
                     [imgUser setFile:[user objectForKey:kESUserProfilePicMediumKey]];
                     [imgUser loadInBackground];
                 }
             }
         }];
        
    }
    else {
        PFQuery *query = [PFQuery queryWithClassName:kESUserClassNameKey];
        [query whereKey:kESUserObjectIdKey equalTo:[message objectForKey:@"lastUser"]];
        [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             if (error == nil)
             {
                 PFUser *user = [objects firstObject];
                 [imgUser setFile:[user objectForKey:kESUserProfilePicMediumKey]];
                 [imgUser loadInBackground];
             }
         }];
    }
    readLabel.hidden = YES;
    readLabel.text = @"";
    if ([[message objectForKey:@"status"] isEqualToString:@"Read"] && [message[@"lastUser"]isEqualToString:[PFUser currentUser].objectId]) {
        //readLabel.hidden = NO;
        //readLabel.text = NSLocalizedString(@"Read", nil);
    } else if ([[message objectForKey:@"status"] isEqualToString:@"Delivered"] && [message[@"lastUser"]isEqualToString:[PFUser currentUser].objectId]) {
        // readLabel.hidden = NO;
        // readLabel.text = NSLocalizedString(@"Delivered", nil);
    }
    //---------------------------------------------------------------------------------------------------------------------------------------------
    description.text = message[@"description"];
    lastMessage.text = message[@"lastMessage"];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'zzz'"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *date = [formatter dateFromString:message[@"date"]];
    NSTimeInterval seconds = [[NSDate date] timeIntervalSinceDate:date];
    elapsed.text = [ESUtility calculateElapsedPeriod:seconds];
    elapsed.textColor = [UIColor colorWithRed:0.0863 green:0.4941 blue:0.9843 alpha:1];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    int count = [message[@"counter"] intValue];
    badgeView.hidden = YES;
    badgeView = [[JSBadgeView alloc] initWithParentView:dummyView alignment:JSBadgeViewAlignmentTopRight];
    if (count == 0) {
        //        badgeView.badgeText = @"";
        badgeView.hidden = YES;
    }
    else {
        badgeView.hidden = NO;
        badgeView.badgeText = [NSString stringWithFormat:@"%i",count];
    }
}

@end
