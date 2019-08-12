//
//  WaitListViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "WaitListViewController.h"
#import "HCSStarRatingView.h"

@interface WaitListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *roster;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *filteredWaiters;
@property (strong, nonatomic) NSArray *sortedRoster;
@property (weak, nonatomic) IBOutlet MKDropdownMenu *dropDown;
@property (strong, nonatomic) NSArray *dropDownCats;
@property (weak, nonatomic) IBOutlet UIView *searchLabelView;
@property (weak, nonatomic) IBOutlet UILabel *dropDownLabel;
@end

@implementation WaitListViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    self.dropDown.delegate = self;
    self.dropDown.dataSource = self;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    self.searchLabelView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.searchLabelView.layer.borderWidth = 0.3;
    self.dropDownCats = @[@"RATING", @"TABLETOPS", @"# CUSTOMERS SERVED", @"AVERAGE CUSTOMER TIP", @"AVERAGE TABLE TIP"];
    self.selectedIndex = 0;
    self.dropDownLabel.text = @"SORT";
    self.roster = [[WaiterManager shared] roster];
    self.filteredWaiters = [[WaiterManager shared] rosterByRating];
    self.searchBar.hidden = YES;
    [self.tableView setContentOffset:CGPointMake(0, self.searchBar.frame.size.height) animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu
{
    return 1;
}
- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component
{
    return [self.dropDownCats count];
}
- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    UIFont * font = [UIFont systemFontOfSize:10];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    
    NSAttributedString *titleForComponent = [[NSAttributedString alloc] initWithString:self.dropDownCats[row] attributes:attributes];
    return titleForComponent;
}



- (IBAction)pressedSearch:(id)sender {
    self.searchBar.hidden = !(self.searchBar.hidden);
    if (self.searchBar.hidden == NO)
    {
        [self.tableView setContentOffset:CGPointZero animated:YES];
    }
    else
    {
        [self.tableView setContentOffset:CGPointMake(0, self.searchBar.frame.size.height) animated:YES];
    }
}
- (NSString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.dropDownCats[row];
}
- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedIndex = row;
    if (row == 0) {
        self.sortedRoster = [[WaiterManager shared] rosterByRating];
    } else if (row == 1) {
        self.sortedRoster = [[WaiterManager shared] rosterByTables];
    } else if (row == 2) {
        self.sortedRoster = [[WaiterManager shared] rosterByCustomers];
    } else if (row == 3) {
        self.sortedRoster = [[WaiterManager shared] rosterByTipsCustomers];
    } else if (row == 4) {
        self.sortedRoster = [[WaiterManager shared] rosterByTipsTables];
    } else if (row == 5) {
        self.sortedRoster = [[WaiterManager shared] rosterByYears];
    } else {
        self.sortedRoster = self.roster;
    }
    
    self.dropDownLabel.text = self.dropDownCats[row];
    self.filteredWaiters = self.sortedRoster;
    [self.tableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.tableView scrollToRowAtIndexPath:indexPath
                         atScrollPosition:UITableViewScrollPositionTop
                                 animated:YES];
    [self.tableView setContentOffset:CGPointMake(0, self.searchBar.frame.size.height) animated:YES];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filteredWaiters.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WaiterListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WaiterListCell" forIndexPath:indexPath];
    Waiter *waiter = self.filteredWaiters[indexPath.row];
    cell.waiter = waiter;
    cell.waiterName.text = [waiter.name uppercaseString];
    cell.selectedIndex = self.selectedIndex;
    cell.waiterTime.text = [@"Served " stringByAppendingString:[[NSString stringWithFormat:@"%@", waiter.yearsWorked] stringByAppendingString:@" Years"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.waiterTabletops.text  = [[NSString stringWithFormat:@"%@", waiter.tableTops] stringByAppendingString:@" Tabletops"];
    cell.waiterNumCustomers.text = [[NSString stringWithFormat:@"%@", waiter.numOfCustomers] stringByAppendingString:@" Customers"];
    cell.waiterTipsPT.text = [@"$" stringByAppendingString:[NSString stringWithFormat:@"%.2f", [[[WaiterManager shared] averageTipsByTable:cell.waiter] floatValue]]];
    cell.waiterTipsPC.text = [@"$" stringByAppendingString:[NSString stringWithFormat:@"%.2f", [[[WaiterManager shared] averageTipByCustomer:cell.waiter] floatValue]]];
    if(waiter.image!=nil){
        [waiter.image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if(!error){
                cell.waiterProfileImage.image = [UIImage imageWithData:imageData];
            } else {
                NSLog(@"Error setting waiter image with error: %@", error.localizedDescription);
            }
        }];
    } else {
        cell.waiterProfileImage.image = [UIImage imageNamed:@"profile_tab"];
    }
    cell.waiterProfileImage.layer.cornerRadius = cell.waiterProfileImage.frame.size.width / 2;

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject[@"name"] containsString:[searchText lowercaseString]];
        }];
        self.filteredWaiters = [self.roster filteredArrayUsingPredicate:predicate];
        NSLog(@"%@", self.filteredWaiters);
    }
    else {
        self.filteredWaiters = self.roster;
    }
    [self.tableView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"waiterDetails"]) {
        WaiterListTableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        
        Waiter *waiter = self.filteredWaiters[indexPath.row];
        WaitDetailsViewController *deetController = [segue destinationViewController];
        deetController.waiter = waiter;
    }
}

@end
