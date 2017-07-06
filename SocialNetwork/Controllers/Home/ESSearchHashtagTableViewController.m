//
//  ESSearchHashtagTableViewController.m
//  d'Netzwierk
//
//  Created by Eric Schanet on 04.12.14.
//
//
#import "ESHashtagTimelineViewController.h"
#import "ESSearchHashtagTableViewController.h"
#import <Parse/Parse.h>
#import "SCLAlertView.h"

#import "ESConstants.h"

@interface ESSearchHashtagTableViewController()
{
    NSMutableArray *hashes;
}

@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar1;

@end

@implementation ESSearchHashtagTableViewController

@synthesize viewHeader, searchBar1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Search hashtags", nil);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
    
    self.tableView.tableHeaderView = viewHeader;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    hashes = [[NSMutableArray alloc] init];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self searchBarCancelled];
}

#pragma mark - User actions

- (void)actionCleanup
{
    [hashes removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [hashes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    PFObject *hash = hashes[indexPath.row];
    NSString *hashtagString = [[NSString alloc]initWithFormat:@"#%@", [hash objectForKey:@"hashtag"]];
    cell.textLabel.text = hashtagString;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PFObject *_hashtag = hashes[indexPath.row];
    NSString *hashtag = [_hashtag objectForKey:@"hashtag"];
    
    ESHashtagTimelineViewController *hashtagSearch = [[ESHashtagTimelineViewController alloc] initWithStyle:UITableViewStyleGrouped andHashtag:hashtag];
    //hashtagSearch.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:hashtagSearch animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] >= 2)
    {
        NSString *search_lower = [[searchText lowercaseString] stringByReplacingOccurrencesOfString:@"#" withString:@""];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Hashtags"];
        [query whereKey:@"hashtag" containsString:search_lower];
        [query orderByAscending:@"updatedAt"];
        [query setLimit:1000];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             if (error == nil)
             {
                 [hashes removeAllObjects];
                 [hashes addObjectsFromArray:objects];
                 [self.tableView reloadData];
             }
             else {
                 SCLAlertView *alert =[[SCLAlertView alloc]init];
                 [alert showError:self.parentViewController title:NSLocalizedString(@"Hold On...",nil) subTitle:NSLocalizedString(@"There seems to be a network error.", nil) closeButtonTitle:@"OK" duration:0.0f];
             }
         }];
    }
    else
    {
        [hashes removeAllObjects];
        [self.tableView reloadData];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self searchBarCancelled];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelled
{
    searchBar1.text = @"";
    [searchBar1 resignFirstResponder];
}
- (void)done:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
