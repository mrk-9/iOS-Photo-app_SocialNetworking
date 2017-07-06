//
//  ESSelectRecipientsViewController.m
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

#import "SCLAlertView.h"
#import "ESSelectRecipientsViewController.h"

@implementation ESSelectRecipientsViewController

@synthesize delegate, viewHeader, searchBar;

# pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Select contacts", nil);;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    users = [[NSMutableArray alloc] init];
    selection = [[NSMutableArray alloc] init];
    self.tableView.tableHeaderView = viewHeader;
    [self loadUsers];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadUsers];
}
- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)done {
    if ([selection count] == 0) {
        SCLAlertView *alert =[[SCLAlertView alloc]init];
        [alert showNotice:self.parentViewController title:NSLocalizedString(@"Hold On...",nil) subTitle:NSLocalizedString(@"Please select some recipients.", nil) closeButtonTitle:@"OK" duration:0.0f];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        if (delegate != nil) {
            NSMutableArray *selectedUsers = [[NSMutableArray alloc] init];
            for (PFUser *user in users) {
                if ([selection containsObject:user.objectId])
                    [selectedUsers addObject:user];
            }
            [delegate selectedRecipients:selectedUsers];
        }
    }];
}

# pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    PFUser *user = users[indexPath.row];
    cell.textLabel.text = user[kESUserDisplayNameKey];
    if ([selection containsObject:user.objectId]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

# pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PFUser *user = users[indexPath.row];
    BOOL selected = [selection containsObject:user.objectId];
    if (selected) [selection removeObject:user.objectId]; else [selection addObject:user.objectId];
    [self.tableView reloadData];
}

# pragma mark - UISearchBar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText length] > 1) {
        [self searchUsers:[searchText lowercaseString]];
    }
    else [self loadUsers];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)_searchBar {
    [_searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)_searchBar {
    [_searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar {
    [self searchBarCancel];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar_ {
    [searchBar_ resignFirstResponder];
}

- (void)searchBarCancel {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    
    [self loadUsers];
}

# pragma mark - ()

- (void)loadUsers {
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:kESUserClassNameKey];
    [query whereKey:kESUserObjectIdKey notEqualTo:user.objectId];
    [query orderByAscending:@"createdAt"];
    [query setLimit:20];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error == nil) {
            [users removeAllObjects];
            [users addObjectsFromArray:objects];
            [self.tableView reloadData];
        }
        else {
            SCLAlertView *alert =[[SCLAlertView alloc]init];
            [alert showError:self.parentViewController title:NSLocalizedString(@"Hold On...",nil) subTitle:NSLocalizedString(@"There seems to be a network error.", nil) closeButtonTitle:@"OK" duration:0.0f];
        };
    }];
}

- (void)searchUsers:(NSString *)search_lower {
    PFUser *user = [PFUser currentUser];
    
    PFQuery *query = [PFQuery queryWithClassName:kESUserClassNameKey];
    [query whereKey:kESUserObjectIdKey notEqualTo:user.objectId];
    [query whereKey:kESUserDisplayNameLowerKey containsString:search_lower];
    [query orderByAscending:kESUserDisplayNameKey];
    [query setLimit:50];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error == nil) {
            [users removeAllObjects];
            [users addObjectsFromArray:objects];
            [self.tableView reloadData];
        }
        else {
            SCLAlertView *alert =[[SCLAlertView alloc]init];
            [alert showError:self.parentViewController title:NSLocalizedString(@"Hold On...",nil) subTitle:NSLocalizedString(@"There seems to be a network error.", nil) closeButtonTitle:@"OK" duration:0.0f];
        }
    }];
}

@end
