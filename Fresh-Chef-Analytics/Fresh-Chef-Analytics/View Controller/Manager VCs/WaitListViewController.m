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
@interface WaitListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *roster;

@end

@implementation WaitListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.roster = [[WaiterManager shared] roster];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.roster.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WaiterListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WaiterListCell" forIndexPath:indexPath];
    Waiter *waiter = self.roster[indexPath.row];
    cell.waiter = waiter;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
