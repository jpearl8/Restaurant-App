//
//  EditWaitViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "EditWaitViewController.h"
#import "WaiterManager.h"
#import "EditWaiterCell.h"

@interface EditWaitViewController ()

@end

@implementation EditWaitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.roster = [[WaiterManager shared] roster];
    //make profile pictures round

}

- (void)editWaiterCell:(EditWaiterCell *)editWaiterCell didTap:(Waiter *)waiter
{
    [[WaiterManager shared] removeWaiterFromTable:waiter withCompletion:^(NSError * _Nullable error) {
        if (error == nil)
        {
            self.roster = [[WaiterManager shared] roster];
            [self.tableView reloadData];
        }
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditWaiterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditWaiterCell" forIndexPath:indexPath];
    Waiter *waiter = self.roster[indexPath.row];
    cell.waiter = waiter;
    cell.cellView.layer.cornerRadius = cell.cellView.frame.size.width/6;
    cell.delegate = self;
    cell.waiterName.text = waiter.name;
    cell.waiterYearsAt.text = [@"Served " stringByAppendingString:[[NSString stringWithFormat:@"%@", waiter.yearsWorked] stringByAppendingString:@"  Years"]];
    cell.waiterRating.text = [[NSString stringWithFormat:@"%@", waiter.rating] stringByAppendingString:@" ✯'s"];
    cell.waiterTableTops.text = [[NSString stringWithFormat:@"%@", waiter.tableTops] stringByAppendingString:@" Tabletops"];
    cell.waiterNumCustomers.text = [[NSString stringWithFormat:@"%@", waiter.numOfCustomers] stringByAppendingString:@" customers served"];
    cell.waiterTips.text = [@"$" stringByAppendingString:[[NSString stringWithFormat:@"%@", waiter.tipsMade] stringByAppendingString:@" Total Tips"]];
    if(waiter.image!=nil){
        [waiter.image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if(!error){
                cell.profileImage.image = [UIImage imageWithData:imageData];
            } else {
                NSLog(@"Error setting waiter image with error: %@", error.localizedDescription);
            }
        }];
    } else {
        cell.profileImage.image = nil;
    }
    cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width / 2;
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
