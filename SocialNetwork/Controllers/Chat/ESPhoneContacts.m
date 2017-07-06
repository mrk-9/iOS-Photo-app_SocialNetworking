//
//  ESPhoneContacts.m
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "SCLAlertView.h"
#import "ESPhoneContacts.h"

@implementation ESPhoneContacts

@synthesize delegate, users1, users2;

# pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Contacts", nil);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(done)];
    
    users1 = [[NSMutableArray alloc] init];
    users2 = [[NSMutableArray alloc] init];
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
                    CFErrorRef *error = NULL;
                    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
                    ABRecordRef sourceBook = ABAddressBookCopyDefaultSource(addressBook);
                    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, sourceBook, kABPersonFirstNameProperty);
                    CFIndex personCount = CFArrayGetCount(allPeople);
                    
                    [users1 removeAllObjects];
                    for (int i=0; i<personCount; i++) {
                        ABMultiValueRef tmp;
                        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
                        NSString *first = @"";
                        tmp = ABRecordCopyValue(person, kABPersonFirstNameProperty);
                        if (tmp != nil) {
                            first = [NSString stringWithFormat:@"%@", tmp];
                        }
                        
                        NSString *last = @"";
                        tmp = ABRecordCopyValue(person, kABPersonLastNameProperty);
                        if (tmp != nil) {
                            last = [NSString stringWithFormat:@"%@", tmp];
                        }
                        
                        NSMutableArray *emails = [[NSMutableArray alloc] init];
                        ABMultiValueRef multi1 = ABRecordCopyValue(person, kABPersonEmailProperty);
                        for (CFIndex j=0; j<ABMultiValueGetCount(multi1); j++) {
                            tmp = ABMultiValueCopyValueAtIndex(multi1, j);
                            if (tmp != nil) {
                                [emails addObject:[NSString stringWithFormat:@"%@", tmp]];
                            }
                        }
                        
                        NSMutableArray *phones = [[NSMutableArray alloc] init];
                        ABMultiValueRef multi2 = ABRecordCopyValue(person, kABPersonPhoneProperty);
                        for (CFIndex j=0; j<ABMultiValueGetCount(multi2); j++) {
                            tmp = ABMultiValueCopyValueAtIndex(multi2, j);
                            if (tmp != nil) {
                                [phones addObject:[NSString stringWithFormat:@"%@", tmp]];
                            }
                        }
                        
                        NSString *name = [NSString stringWithFormat:@"%@ %@", first, last];
                        [users1 addObject:@{@"name":name, @"emails":emails, @"phones":phones}];
                    }
                    CFRelease(allPeople);
                    CFRelease(addressBook);
                    
                    NSMutableArray *emails = [[NSMutableArray alloc] init];
                    for (NSDictionary *user in users1) {
                        [emails addObjectsFromArray:user[@"emails"]];
                    }
                    
                    PFUser *user = [PFUser currentUser];
                    
                    PFQuery *query = [PFQuery queryWithClassName:kESUserClassNameKey];
                    [query whereKey:kESUserObjectIdKey notEqualTo:user.objectId];
                    [query whereKey:kESUserEmailKey containedIn:emails];
                    [query orderByAscending:kESUserDisplayNameKey];
                    [query setLimit:1000];
                    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        if (error == nil)
                        {
                            [users2 removeAllObjects];
                            for (PFUser *user in objects)
                            {
                                [users2 addObject:user];
                                NSString *email = [user objectForKey:kESUserEmailKey];
                                NSMutableArray *remove = [[NSMutableArray alloc] init];
                                for (NSDictionary *user in users1) {
                                    for (NSString *_email in user[@"emails"]) {
                                        if ([_email isEqualToString:email]) {
                                            [remove addObject:user];
                                            break;
                                        }
                                    }
                                }
                                for (NSDictionary *user in remove) {
                                    [users1 removeObject:user];
                                }
                            }
                            [self.tableView reloadData];
                        }
                    }];
                }
            };
        });
    });
}

- (void)done {
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - UITableView data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [users2 count];
    }
    if (section == 1) {
        return [users1 count];
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ((section == 0) && ([users2 count] != 0)) {
        return NSLocalizedString(@"Registered users", nil);
    }
    if ((section == 1) && ([users1 count] != 0)) {
        return NSLocalizedString(@"Non-registered users", nil);
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (indexPath.section == 0) {
        PFUser *user = users2[indexPath.row];
        cell.textLabel.text = user[kESUserDisplayNameKey];
        cell.detailTextLabel.text = user[kESUserEmailKey];
    }
    if (indexPath.section == 1) {
        NSDictionary *user = users1[indexPath.row];
        NSString *email = [[user objectForKey:@"emails"] firstObject];
        NSString *phone = [[user objectForKey:@"phones"] firstObject];
        cell.textLabel.text = [user objectForKey:@"name"];
        if (email != nil) {
            cell.detailTextLabel.text = email;
        }
        else cell.detailTextLabel.text = phone;
    }
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    return cell;
}

# pragma mark - UITableView delegate method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [self dismissViewControllerAnimated:YES completion:^{
            if (delegate != nil) [delegate selectedFromContacts:users2[indexPath.row]];
        }];
    }
    if (indexPath.section == 1) {
        selectedIndex = indexPath;
        [self userInviteAction:users1[indexPath.row]];
    }
}

# pragma mark - UIActionSheed delegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) return;
    NSDictionary *user = users1[selectedIndex.row];
    if (buttonIndex == 0) [self sendMail:user];
    if (buttonIndex == 1) [self sendSMS:user];
}
# pragma mark - MFMailComposeViewcontroller delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (result == MFMailComposeResultSent) {
        SCLAlertView *alert = [[SCLAlertView alloc]init];
        [alert showSuccess:self.parentViewController title:NSLocalizedString(@"Success",nil) subTitle:NSLocalizedString(@"The email has been sent.", nil) closeButtonTitle:@"OK" duration:1.0f];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    if (result == MessageComposeResultSent) {
        SCLAlertView *alert = [[SCLAlertView alloc]init];
        [alert showSuccess:self.parentViewController title:NSLocalizedString(@"Success",nil) subTitle:NSLocalizedString(@"The SMS has been sent.", nil) closeButtonTitle:@"OK" duration:1.0f];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - ()

- (void)userInviteAction:(NSDictionary *)user {
    if (([user[@"emails"] count] != 0) && ([user[@"phones"] count] != 0)) {
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel"
                                              destructiveButtonTitle:nil otherButtonTitles:@"Email invitation", @"SMS invitation", nil];
        [action showInView:self.view];
    }
    else if (([user[@"emails"] count] != 0) && ([user[@"phones"] count] == 0)) {
        [self sendMail:user];
    }
    else if (([user[@"emails"] count] == 0) && ([user[@"phones"] count] != 0)) {
        [self sendSMS:user];
    }
    else {
        SCLAlertView *alert = [[SCLAlertView alloc]init];
        [alert showError:self.parentViewController title:NSLocalizedString(@"Hold On...",nil) subTitle:NSLocalizedString(@"This contact does not have enough information to be invited.", nil) closeButtonTitle:@"OK" duration:0.0f];
    }
}

- (void)sendMail:(NSDictionary *)user {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
        [mailCompose setToRecipients:user[@"emails"]];
        [mailCompose setSubject:@""];
        [mailCompose setMessageBody:kESChatInviteUserMessage isHTML:YES];
        mailCompose.mailComposeDelegate = self;
        [self presentViewController:mailCompose animated:YES completion:nil];
    }
    else {
        SCLAlertView *alert = [[SCLAlertView alloc]init];
        [alert showError:self.parentViewController title:NSLocalizedString(@"Hold On...",nil) subTitle:NSLocalizedString(@"Please check you've correctly setup your email", nil) closeButtonTitle:@"OK" duration:0.0f];
    }
}

- (void)sendSMS:(NSDictionary *)user {
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *messageCompose = [[MFMessageComposeViewController alloc] init];
        messageCompose.recipients = user[@"phones"];
        messageCompose.body = kESChatInviteUserMessage;
        messageCompose.messageComposeDelegate = self;
        [self presentViewController:messageCompose animated:YES completion:nil];
    }
    else {
        SCLAlertView *alert = [[SCLAlertView alloc]init];
        [alert showError:self.parentViewController title:NSLocalizedString(@"Hold On...",nil) subTitle:NSLocalizedString(@"The SMS can not be sent", nil) closeButtonTitle:@"OK" duration:0.0f];
    }
}

@end
