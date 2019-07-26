//
//  WaitOrderTableViewCell.m
//  Fresh-Chef-Analytics
//
//  Created by rgallardo on 7/24/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "WaitOrderTableViewCell.h"
#import "SingleOpenOrder.h"

@implementation WaitOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.ordersTable.delegate = self;
    self.ordersTable.dataSource = self;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.openOrders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SingleOpenOrder *cell = [tableView dequeueReusableCellWithIdentifier: @"OpenOrder"];
    OpenOrder *openOrder = self.openOrders[indexPath.row];
    cell.dishName.text = openOrder.dish.name;
    cell.amount.text = [NSString stringWithFormat:@"%d", [openOrder.amount intValue]];
    return cell;
    
}

@end
