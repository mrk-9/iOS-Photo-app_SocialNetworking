//
//  SideViewController.m
//  d'Netzwierk
//
//  Created by Eric Schanet on 26.06.14.
//
//

#import "SideViewController.h"
#import "MMSideDrawerTableViewCell.h"
#import "MMSideDrawerSectionHeaderView.h"
#import "ESFindFriendsCell.h"
#import "ESAccountViewController.h"
#import "ESProfileImageView.h"
#import "MFSideMenu.h"
#import "ESSideTableViewCell.h"
#import "MBProgressHUD.h"
#import "ESTravelTimeline.h"


@implementation SideViewController
@synthesize _tableView,navController,hud, mbhud;
#pragma mark - Initialization

- (id)initWithNavigationController:(UINavigationController *)navigationController {
    self = [super init];
    if (self) {

    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated {
    [self._tableView reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width-45, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    
    [self._tableView setDelegate:self];
    [self._tableView setDataSource:self];
    [self.view addSubview:self._tableView];
    [self._tableView setBackgroundColor:[UIColor darkGrayColor]];
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    [self.view addSubview:_tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuStateEventOccurred:)
                                                 name:MFSideMenuStateNotificationEvent
                                               object:nil];
}


- (void)menuStateEventOccurred:(NSNotification *)notification {
    MFSideMenuStateEvent event = [[[notification userInfo] objectForKey:@"eventType"] intValue];
    if (event == MFSideMenuStateEventMenuDidOpen) {
        [self._tableView reloadData];
    }
}

#pragma mark - UITableView Data source and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 2;
        case 2:
            return 3;
        case 3:
            return 1;
        case 4:
            return 1;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ESSideTableViewCell *cell = (ESSideTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[ESSideTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, cell.bounds.size.width-40, cell.bounds.size.height)];
            nameLabel.textColor = [UIColor whiteColor];
            ESProfileImageView *avatarImageView = [[ESProfileImageView alloc] init];
            avatarImageView.frame = CGRectMake( 4.0f, 4.0f, 35.0f, 35.0f);
            PFUser *user = [PFUser currentUser];
            PFFile *profilePictureSmall = [user objectForKey:kESUserProfilePicSmallKey];
            [avatarImageView setFile:profilePictureSmall];
            [cell.contentView addSubview:avatarImageView];
            //[cell.contentView addSubview:nameLabel];
            if ([user objectForKey:kESUserDisplayNameKey]) {
                cell.textLabel.text = [user objectForKey:kESUserDisplayNameKey];
            }
            else {
                cell.textLabel.text = [user objectForKey:@"username"];
            }
        }
        
} else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"Popular", nil);
            UIImageView *avatarImageView = [[UIImageView alloc] init];
            avatarImageView.frame = CGRectMake( 12.0f, 10.0f, 20.0f, 20.0f);
            [avatarImageView setImage:[UIImage imageNamed:@"icon-fire"]];
            avatarImageView.alpha = 0.5;
            [cell.contentView addSubview:avatarImageView];
        }
        else {
            cell.textLabel.text = NSLocalizedString(@"Recent", nil);
            UIImageView *avatarImageView = [[UIImageView alloc] init];
            avatarImageView.frame = CGRectMake( 12.0f, 10.0f, 20.0f, 20.0f);
            [avatarImageView setImage:[UIImage imageNamed:@"iconclock"]];
            avatarImageView.alpha = 0.5;
            [cell.contentView addSubview:avatarImageView];
        }
        
        
    }
else if (indexPath.section == 3) {
    if (indexPath.row == 0) {    cell.textLabel.text = NSLocalizedString(@"Tasks", nil);
        UIImageView *avatarImageView = [[UIImageView alloc] init];
        avatarImageView.frame = CGRectMake( 12.0f, 10.0f, 20.0f, 20.0f);
        [avatarImageView setImage:[UIImage imageNamed:@"clockIcon"]];
        avatarImageView.alpha = 0.5;
        [cell.contentView addSubview:avatarImageView];
        
    }
}
else if (indexPath.section == 4) {
    if (indexPath.row == 0) {    cell.textLabel.text = NSLocalizedString(@"Travels", nil);
        UIImageView *avatarImageView = [[UIImageView alloc] init];
        avatarImageView.frame = CGRectMake( 12.0f, 10.0f, 20.0f, 20.0f);
        [avatarImageView setImage:[UIImage imageNamed:@"locationIcon"]];
        avatarImageView.alpha = 0.5;
        [cell.contentView addSubview:avatarImageView];
    }
}
    
    else {
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"Find Friends", nil);
            UIImageView *avatarImageView = [[UIImageView alloc] init];
            avatarImageView.frame = CGRectMake( 10.0f, 10.0f, 25.0f, 18.0f);
            [avatarImageView setImage:[UIImage imageNamed:@"IconFollowers.png"]];
            avatarImageView.alpha = 0.5;
            [cell.contentView addSubview:avatarImageView];
        }
    
        else if (indexPath.row == 2) {
            cell.textLabel.text = NSLocalizedString(@"Log Out", nil);
            UIImageView *avatarImageView = [[UIImageView alloc] init];
            avatarImageView.frame = CGRectMake( 15.0f, 12.0f, 16.0f, 18.0f);
            [avatarImageView setImage:[UIImage imageNamed:@"Logout.png"]];
            avatarImageView.alpha = 0.5;
            [cell.contentView addSubview:avatarImageView];
            hud = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            hud.frame = CGRectMake(180, 10, 25, 25);
            [cell.contentView addSubview:hud];
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"Settings", nil);
            UIImageView *avatarImageView = [[UIImageView alloc] init];
            avatarImageView.frame = CGRectMake( 13.0f, 12.0f, 18.0f, 18.0f);
            [avatarImageView setImage:[UIImage imageNamed:@"ButtonImageSettings.png"]];
            avatarImageView.alpha = 0.5;
            [cell.contentView addSubview:avatarImageView];
        }
      
                
                    }
    
    return cell;

}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Deselect row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section == 3) {
            [self postNotificationWithString:@"OpenMyTasks"];
        }
    else {
        if (indexPath.row == 0) {
            //   [self postNotificationWithString:@"FindFriendsOpen"];
        }

    if (indexPath.section == 4) {
            [self postNotificationWithString:@"OpenMyTravels"];
        }
    else {
        if (indexPath.row == 0) {
            //   [self postNotificationWithString:@"FindFriendsOpen"];
        }

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self postNotificationWithString:@"ProfileOpen"];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self postNotificationWithString:@"OpenPopularFeed"];
        }
        else {
            [self postNotificationWithString:@"OpenRecentFeed"];
        }
        
    }
    else {
        if (indexPath.row == 0) {
           [self postNotificationWithString:@"FindFriendsOpen"];
        }
        else if (indexPath.row == 2) {
            self.mbhud = [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
            self.mbhud.labelText = NSLocalizedString(@"Logging out...", nil);
            self.mbhud.dimBackground = YES;
            [self performSelector:@selector(dummyLogout) withObject:nil afterDelay:0.2];
        }
        else if (indexPath.row == 1) {
            [self postNotificationWithString:@"OpenSettings"];
        }
    
        }
}
    }}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40.0)];
    if (section == 0) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 40.0)];
        titleLabel.text = NSLocalizedString(@"PROFILE", nil);
        titleLabel.font = [UIFont fontWithName:@"Arial" size:14];
        titleLabel.textColor = [UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1.0];
        [header addSubview:titleLabel];
        return header;
    }
    if (section == 1) {
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 40.0)];
        titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"POPULAR", nil)];
        [titleLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
        titleLabel.textColor = [UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1.0];
        [header addSubview:titleLabel];
        return header;
    }
    if (section == 2) {
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 40.0)];
        titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"SETTINGS", nil)];
        [titleLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
        titleLabel.textColor = [UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1.0];
        [header addSubview:titleLabel];
        return header;
    }
    if (section == 3) {
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 40.0)];
        titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"MYTASKS", nil)];
        [titleLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
        titleLabel.textColor = [UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1.0];
        [header addSubview:titleLabel];
        return header;
    }
    if (section == 4) {
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 40.0)];
        titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"MYTRAVELS", nil)];
        [titleLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
        titleLabel.textColor = [UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1.0];
        [header addSubview:titleLabel];
        return header;
    }

    
    return header;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return NSLocalizedString(@"Profile", nil);
        case 1:
            return NSLocalizedString(@"Feeds", nil);
        case 2:
            return NSLocalizedString(@"Settings", nil);
        case 3:
            return NSLocalizedString(@"MyTasks", nil);
        case 4:
            return NSLocalizedString(@"MyTravels", nil);
        default:
            return nil;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0;
}
- (void)postNotificationWithString:(NSString *)notification //post notification method and logic
{

    NSString *notificationName = @"ESNotification";
    NSString *key = @"CommunicationStringValue";
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:notification forKey:key];
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:dictionary];
}

- (void) dummyLogout {
    [self postNotificationWithString:@"LogHimOut"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
