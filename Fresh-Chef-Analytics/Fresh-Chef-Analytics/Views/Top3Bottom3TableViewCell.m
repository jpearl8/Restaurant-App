//
//  Top3Bottom3TableViewCell.m
//  Fresh-Chef-Analytics
//
//  Created by rgallardo on 7/22/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "Top3Bottom3TableViewCell.h"

@implementation Top3Bottom3TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.image.layer.cornerRadius = 0.8 * self.image.bounds.size.height;
    self.image.layer.masksToBounds = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    [self.frequency setFont:[UIFont systemFontOfSize:18]];
    [self.rating setFont:[UIFont systemFontOfSize:18]];
    [self.price setFont:[UIFont systemFontOfSize:18]];
//    [self.profit setFont:[UIFont systemFontOfSize:18]];
    
    if (self.selectedIndex == 0) {
        [self.frequency setFont:[UIFont boldSystemFontOfSize:20]];
    } else {
        [self.rating setFont:[UIFont boldSystemFontOfSize:20]];
    }
    // set rating color
    if ([self.ratingCategory isEqualToString: @"high"]) {
        [self.rating setTextColor:UIColor.greenColor];
    } else if ([self.ratingCategory isEqualToString: @"medium"]) {
        [self.rating setTextColor:UIColor.grayColor];
    } else {
        [self.rating setTextColor:UIColor.redColor];
    }
    if ([self.freqCategory isEqualToString: @"high"]) {
        [self.frequency setTextColor:UIColor.greenColor];
    } else if ([self.freqCategory isEqualToString: @"medium"]) {
        [self.frequency setTextColor:UIColor.grayColor];
    } else {
        [self.frequency setTextColor:UIColor.redColor];
    }
    if ([self.profitCategory isEqualToString: @"high"]) {
        [self.profit setTextColor:UIColor.greenColor];
    } else if ([self.profitCategory isEqualToString: @"medium"]) {
        [self.profit setTextColor:UIColor.grayColor];
    } else {
        [self.profit setTextColor:UIColor.redColor];
    }
}

@end
