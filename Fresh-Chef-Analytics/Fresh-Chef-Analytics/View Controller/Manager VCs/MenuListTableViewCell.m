//
//  MenuListTableViewCell.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/17/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "MenuListTableViewCell.h"
#import "UIRefs.h"
@implementation MenuListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.image.layer.cornerRadius = 0.8 * self.image.bounds.size.height;
    self.image.layer.masksToBounds = YES;
    self.ratingView.layer.shadowRadius  = 1.5f;
    self.ratingView.layer.shadowColor   = [UIColor colorWithRed:176.f/255.f green:199.f/255.f blue:226.f/255.f alpha:1.f].CGColor;
    self.ratingView.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    self.ratingView.layer.shadowOpacity = 0.9f;
    self.ratingView.layer.masksToBounds = NO;
    
    UIEdgeInsets shadowInsets     = UIEdgeInsetsMake(0, 0, -1.5f, 0);
    UIBezierPath *shadowPath      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(self.ratingView.bounds, shadowInsets)];
    self.ratingView.layer.shadowPath    = shadowPath.CGPath;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    NSString *greenGood = [[UIRefs shared] green];
    NSString *redBad = [[UIRefs shared] red];


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
        self.ratingView.backgroundColor = [[UIRefs shared] colorFromHexString:greenGood];
    } else if ([self.ratingCategory isEqualToString: @"medium"]) {
        self.ratingView.backgroundColor = [UIColor grayColor];
    } else {
        self.ratingView.backgroundColor = [[UIRefs shared] colorFromHexString:redBad];    }
    if ([self.freqCategory isEqualToString: @"high"]) {
        [self.orderFrequency setTextColor:[[UIRefs shared] colorFromHexString:greenGood]];
    } else if ([self.freqCategory isEqualToString: @"medium"]) {
        [self.orderFrequency setTextColor:UIColor.grayColor];
    } else {
        [self.orderFrequency setTextColor:[[UIRefs shared] colorFromHexString:redBad]];
    }
}

@end
