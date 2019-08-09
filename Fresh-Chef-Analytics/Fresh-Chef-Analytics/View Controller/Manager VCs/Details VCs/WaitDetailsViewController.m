//
//  WaitDetailsViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "WaitDetailsViewController.h"
#import "WaiterManager.h"
#import "HCSStarRatingView.h"
@interface WaitDetailsViewController ()

@end

@implementation WaitDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    double numberStars = [[[WaiterManager shared] averageRating:self.waiter] doubleValue];
    HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(self.ratingView.frame.size.width/2, self.ratingView.frame.size.height/2, (30 * numberStars), 30)];
    starRatingView.value = numberStars;
    starRatingView.minimumValue = numberStars;
    starRatingView.maximumValue = numberStars;
    starRatingView.tintColor = [UIColor grayColor];
    [self.ratingView addSubview:starRatingView];
    self.waiterName.text = self.waiter.name;
    self.waiterTime.text = [@"Served " stringByAppendingString:[[NSString stringWithFormat:@"%@", self.waiter.yearsWorked] stringByAppendingString:@"  Years"]];
    self.waiterTabletops.text  = [[NSString stringWithFormat:@"%@", self.waiter.tableTops] stringByAppendingString:@" Tabletops"];
    self.waiterNumCustomers.text = [[NSString stringWithFormat:@"%@", self.waiter.numOfCustomers] stringByAppendingString:@" customers served"];
    if(self.waiter.image!=nil){
        [self.waiter.image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if(!error){
                self.waiterProfileImage.image = [UIImage imageWithData:imageData];
            } else {
                NSLog(@"Error setting waiter image with error: %@", error.localizedDescription);
            }
        }];
    } else {
        self.waiterProfileImage.image = nil;
    }
    self.waiterTipsPT.text = [@"$" stringByAppendingString:[[NSString stringWithFormat:@"%@", [[WaiterManager shared] averageTipsByTable:self.waiter]] stringByAppendingString:@" Tips per Table"]];
    self.waiterTipsPC.text = [@"$" stringByAppendingString:[[NSString stringWithFormat:@"%@", [[WaiterManager shared] averageTipByCustomer:self.waiter]] stringByAppendingString:@" Tips per Customer"]];


}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.waiter.comments count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"SimpleTableView"];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SimpleTableView"];
    }
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    backgroundView.backgroundColor = [UIColor colorWithRed:.94 green:.72 blue:.69 alpha:0.8];
    [cell addSubview:backgroundView];
    [cell sendSubviewToBack:backgroundView];
    cell.textLabel.text = self.waiter.comments[indexPath.row];
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:21 weight:UIFontWeightThin]];
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
