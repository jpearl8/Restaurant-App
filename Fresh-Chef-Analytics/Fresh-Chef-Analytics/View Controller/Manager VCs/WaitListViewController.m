//
//  WaitListViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "WaitListViewController.h"
#import "WaiterManager.h"
#import "WaiterListTableViewCell.h"
#import "WaitDetailsViewController.h"

@interface WaitListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *roster;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *filteredWaiters;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortByControl;
@property (strong, nonatomic) NSArray *sortedRoster;

@end

@implementation WaitListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    self.roster = [[WaiterManager shared] roster];
    self.sortedRoster = [[NSArray alloc] initWithArray:self.roster];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sortedRoster.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WaiterListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WaiterListCell" forIndexPath:indexPath];
    Waiter *waiter;
    waiter = self.sortedRoster[indexPath.row];
    cell.waiter = waiter;
    cell.selectedIndex = self.selectedIndex;
    cell.waiterName.text = waiter.name;
    cell.waiterTime.text = [[NSString stringWithFormat:@"%@", waiter.yearsWorked] stringByAppendingString:@" years"];
    cell.waiterRating.text = [[NSString stringWithFormat:@"%@", waiter.rating] stringByAppendingString:@" stars"];
    cell.waiterTabletops.text  = [[NSString stringWithFormat:@"%@", waiter.tableTops] stringByAppendingString:@" tables"];
    cell.waiterNumCustomers.text = [[NSString stringWithFormat:@"%@", waiter.numOfCustomers] stringByAppendingString:@" customers served"];
    cell.waiterTips.text = [[NSString stringWithFormat:@"%@", waiter.tipsMade] stringByAppendingString:@" tips made"];
    if(waiter.image!=nil){
        [waiter.image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if(!error){
                cell.waiterProfileImage.image = [UIImage imageWithData:imageData];
            } else {
                NSLog(@"Error setting waiter image with error: %@", error.localizedDescription);
            }
        }];
    } else {
        cell.waiterProfileImage.image = nil;
    }
    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject[@"name"] containsString:searchText];
        }];
        self.filteredWaiters = [self.roster filteredArrayUsingPredicate:predicate];
    }
    else {
        self.filteredWaiters = self.roster;
    }
    [self.tableView reloadData];
}

- (IBAction)onEditSortBy:(id)sender {
    // reload data
    self.selectedIndex = self.sortByControl.selectedSegmentIndex;
//    NSInteger selectedIndex = self.sortByControl.selectedSegmentIndex;
    if (self.selectedIndex == 0) {
        self.sortedRoster = [[WaiterManager shared] rosterByRating];
    } else if (self.selectedIndex == 1) {
        self.sortedRoster = [[WaiterManager shared] rosterByTables];
    } else if (self.selectedIndex == 2) {
        self.sortedRoster = [[WaiterManager shared] rosterByCustomers];
    } else if (self.selectedIndex == 3) {
        self.sortedRoster = [[WaiterManager shared] rosterByTips];
    } else if (self.selectedIndex == 4) {
        self.sortedRoster = [[WaiterManager shared] rosterByYears];
    } else {
        self.sortedRoster = self.roster;
    }
    [self.tableView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"waiterDetails"]) {
        WaiterListTableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Waiter *waiter = self.roster[indexPath.row];
        WaitDetailsViewController *deetController = [segue destinationViewController];
        deetController.waiter = waiter;
    }
}

@end
