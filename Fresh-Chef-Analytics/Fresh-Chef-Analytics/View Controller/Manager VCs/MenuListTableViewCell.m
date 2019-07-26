//
//  MenuListTableViewCell.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/17/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "MenuListTableViewCell.h"

@implementation MenuListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.image.layer.cornerRadius = 0.8 * self.image.bounds.size.height;
    self.image.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    [self.orderFrequency setFont:[UIFont systemFontOfSize:18]];
    [self.rating setFont:[UIFont systemFontOfSize:18]];
    [self.price setFont:[UIFont systemFontOfSize:18]];
    if (self.selectedIndex == 0) {
        [self.orderFrequency setFont:[UIFont boldSystemFontOfSize:20]];
    } else if (self.selectedIndex == 1) {
        [self.rating setFont:[UIFont boldSystemFontOfSize:20]];
    } else if (self.selectedIndex == 2) {
        [self.price setFont:[UIFont boldSystemFontOfSize:20]];
    } else {
        NSLog(@"Nothing selected?????");
    }

    if ([self.ratingCategory isEqualToString: @"high"]) {
        [self.rating setTextColor:UIColor.greenColor];
    } else if ([self.ratingCategory isEqualToString: @"medium"]) {
        [self.rating setTextColor:UIColor.grayColor];
    } else {
        [self.rating setTextColor:UIColor.redColor];
    }
}

@end
