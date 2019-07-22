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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    [self.waiterRating setFont:[UIFont systemFontOfSize:18]];
    [self.waiterTabletops setFont:[UIFont systemFontOfSize:18]];
    [self.waiterNumCustomers setFont:[UIFont systemFontOfSize:18]];
    [self.waiterTips setFont:[UIFont systemFontOfSize:18]];
    [self.waiterTime setFont:[UIFont systemFontOfSize:18]];
    if (self.selectedIndex == 0) {
        [self.waiterRating setFont:[UIFont boldSystemFontOfSize:25]];
    } else if (self.selectedIndex == 1) {
        [self.waiterTabletops setFont:[UIFont boldSystemFontOfSize:25]];
    } else if (self.selectedIndex == 2) {
        [self.waiterNumCustomers setFont:[UIFont boldSystemFontOfSize:25]];
    } else if (self.selectedIndex == 3) {
        [self.waiterTips setFont:[UIFont boldSystemFontOfSize:25]];
    } else if (self.selectedIndex == 4) {
        [self.waiterTime setFont:[UIFont boldSystemFontOfSize:25]];
    } else {
        NSLog(@"Nothing selected?????");
    }
}

@end
