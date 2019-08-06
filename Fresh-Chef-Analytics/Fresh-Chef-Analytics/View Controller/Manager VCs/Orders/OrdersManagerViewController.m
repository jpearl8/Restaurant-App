//
//  OrdersManagerViewController.m
//  Fresh-Chef-Analytics
//
//  Created by rgallardo on 7/24/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "OrdersManagerViewController.h"
#import "ManagerOrderTableViewCell.h"
#import "OrderManager.h"

@interface OrdersManagerViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) NSMutableDictionary *openOrdersByTable;
@property (strong, nonatomic) NSArray *closedOrders;
@property (strong, nonatomic) NSArray *tables;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *openContainer;
@property (weak, nonatomic) IBOutlet UIView *closedContainer;
@property (strong, nonatomic) NSString *whichOrders;
@end

@implementation OrdersManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.openOrdersByTable = [[OrderManager shared] openOrdersByTable];
    self.closedOrders = [[OrderManager shared] closedOrders];
    self.tables = [self.openOrdersByTable allKeys];
    self.whichOrders = @"Open";
}


- (IBAction)showContainer:(id)sender {
    NSInteger selectedIndex = self.segmentedControl.selectedSegmentIndex;

    if (selectedIndex == 0)
    {
        self.titleLabel.text = @"Open Orders";
        [UIView animateWithDuration:0.5 animations:^{
            self.openContainer.alpha = 1;
            self.closedContainer.alpha = 0;
        }];
    }
    else if (selectedIndex == 1)
    {
        self.titleLabel.text = @"Closed Orders";
        [UIView animateWithDuration:0.5 animations:^{
            self.openContainer.alpha = 0;
            self.closedContainer.alpha = 1;
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    <#code#>
//}
//
//- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    <#code#>
//}

@end
