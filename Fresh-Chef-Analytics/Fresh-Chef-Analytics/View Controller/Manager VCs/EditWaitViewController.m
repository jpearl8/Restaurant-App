//
//  EditWaitViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "EditWaitViewController.h"
#import "Waiter.h"
#import "WaiterManager.h"
#import "EditWaiterCell.h"

@interface EditWaitViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *roster;
@end

@implementation EditWaitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.roster = [[WaiterManager shared] roster];
    // Do any additional setup after loading the view.
}
- (IBAction)saveWaiter:(id)sender {
    Waiter *newWaiter = [Waiter addNewWaiter:self.nameField.text withYears:[NSNumber numberWithFloat:[self.yearsField.text floatValue]] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded)
        {
            NSLog(@"yay");
        }
        else
        {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [self didAddWaiter:newWaiter];
    
}
- (void) didAddWaiter: (Waiter *) waiter
{
    [[WaiterManager shared] addWaiter:waiter];
    self.roster = [[WaiterManager shared] roster];
    [self.tableView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditWaiterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditWaiterCell" forIndexPath:indexPath];
    Waiter *waiter = self.roster[indexPath.row];
    cell.waiter = waiter;
    cell.waiterName.text = waiter.name;
    cell.waiterYearsAt.text = [NSString stringWithFormat:@"%@", waiter.yearsWorked];
    cell.waiterRating.text = [NSString stringWithFormat:@"%@", waiter.rating];
    cell.waiterTableTops.text = [NSString stringWithFormat:@"%@", waiter.tableTops];
    cell.waiterNumCustomers.text = [NSString stringWithFormat:@"%@", waiter.numOfCustomers];
    cell.waiterTips.text = [NSString stringWithFormat:@"%@", waiter.tipsMade];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.roster.count;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
