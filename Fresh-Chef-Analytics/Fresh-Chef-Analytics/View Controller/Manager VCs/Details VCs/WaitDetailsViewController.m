//
//  WaitDetailsViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "WaitDetailsViewController.h"
#import "WaiterManager.h"
#import "UIRefs.h"

@interface WaitDetailsViewController ()
@property (strong, nonatomic) IBOutlet UIView *noComments;

@end

@implementation WaitDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.ratingView.layer.shadowRadius  = 1.5f;
    self.ratingView.layer.shadowColor   = [UIColor colorWithRed:176.f/255.f green:199.f/255.f blue:226.f/255.f alpha:1.f].CGColor;
    self.ratingView.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    self.ratingView.layer.shadowOpacity = 0.9f;
    self.ratingView.layer.masksToBounds = NO;
    self.waiterName.text = [self.waiter.name uppercaseString];
    self.waiterTime.text = [[NSString stringWithFormat:@"%@", self.waiter.yearsWorked] stringByAppendingString:@"  YEARS"];
    self.rating.text = [NSString stringWithFormat:@"%@", [[WaiterManager shared] averageRating:self.waiter]];
    self.waiterTabletops.text  = [NSString stringWithFormat:@"%@", self.waiter.tableTops];
    self.waiterNumCustomers.text = [NSString stringWithFormat:@"%@", self.waiter.numOfCustomers];
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
    self.waiterTipsPT.text = [@"$" stringByAppendingString:[NSString stringWithFormat:@"%.2f", [[[WaiterManager shared] averageTipsByTable:self.waiter] floatValue]]];
    self.waiterTipsPC.text = [@"$" stringByAppendingString:[NSString stringWithFormat:@"%.2f", [[[WaiterManager shared] averageTipByCustomer:self.waiter] floatValue]]];
}


-(void)noCommentsCheck {
    if ([self.waiter.comments count] == 0){
        self.tableView.hidden = YES;
        self.noComments.hidden = NO;
        self.noComments.layer.cornerRadius = 5;
        //self.noOrders.frame.size.width/2;
        self.noComments.layer.borderWidth = .5f;
        self.noComments.layer.borderColor = [[UIRefs shared] colorFromHexString:[UIRefs shared].purpleAccent].CGColor;
    } else {
        self.tableView.hidden = NO;
        self.noComments.hidden = YES;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self noCommentsCheck];
    return [self.waiter.comments count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"SimpleTableView"];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SimpleTableView"];
    }
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    backgroundView.backgroundColor = [[UIRefs shared] colorFromHexString:@"#fbfaf1"];
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
