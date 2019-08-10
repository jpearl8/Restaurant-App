//
//  WaiterListTableViewCell.m
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/19/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "WaiterListTableViewCell.h"

@implementation WaiterListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.waiterProfileImage.layer.cornerRadius = 0.8 * self.waiterProfileImage.bounds.size.height;
    self.waiterProfileImage.layer.masksToBounds = YES;
    self.cellView.layer.borderWidth = 0.3;
    self.cellView.layer.borderColor = [UIColor grayColor].CGColor;
    [self allHidden];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self allHidden];
    // Configure the view for the selected state
//    [self.waiterRating setFont:[UIFont systemFontOfSize:18]];
//    [self.waiterTabletops setFont:[UIFont systemFontOfSize:18]];
//    [self.waiterNumCustomers setFont:[UIFont systemFontOfSize:18]];
//    [self.waiterTipsPT setFont:[UIFont systemFontOfSize:18]];
//    [self.waiterTipsPC setFont:[UIFont systemFontOfSize:18]];
//    [self.waiterTime setFont:[UIFont systemFontOfSize:18]];
    if (self.selectedIndex == 0) {
        self.ratingView.hidden = NO;
    } else if (self.selectedIndex == 1) {
        self.waiterTabletops.hidden = NO;
    } else if (self.selectedIndex == 2) {
        self.waiterNumCustomers.hidden = NO;
    } else if (self.selectedIndex == 3) {
        self.waiterTipsPC.hidden = NO;
        self.averageCustomerLabel.hidden = NO;
    } else if (self.selectedIndex == 4) {
        self.waiterTipsPT.hidden = NO;
        self.averageTableLabel.hidden = NO;
    }
    else {
        NSLog(@"Nothing selected?????");
    }
}
- (void) allHidden
{
    self.ratingView.hidden = YES;
    self.waiterTipsPT.hidden = YES;
    self.waiterTipsPC.hidden = YES;
    self.waiterNumCustomers.hidden = YES;
    self.waiterTabletops.hidden = YES;
    self.averageTableLabel.hidden = YES;
    self.averageCustomerLabel.hidden = YES;
}
@end
