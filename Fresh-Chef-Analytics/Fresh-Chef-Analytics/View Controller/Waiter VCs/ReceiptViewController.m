//
//  ReceiptViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "ReceiptViewController.h"
#import "ReceiptTableViewCell.h"

@interface ReceiptViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *receiptTable;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UITextField *tip;
@property (weak, nonatomic) IBOutlet UILabel *finalPrice;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *restaurantAddress;
@property (weak, nonatomic) IBOutlet UILabel *restaurantName;


@end

@implementation ReceiptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.receiptTable.dataSource = self;
    self.receiptTable.delegate = self;
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.customerOrder.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReceiptTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"receiptCell"];
    order *order = self.customerOrder[indexPath.row];
    cell.order = order;
    cell.dishName.text = order.dish.name;
    cell.dishAmount.text = [NSString stringWithFormat:@"%.0f", order.amount];
    cell.calculatedPrice.text = [NSString stringWithFormat:@"%.0f", ([order.dish.price floatValue] * order.amount)];
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
