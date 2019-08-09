//
//  Top3Bottom3TableViewCell.m
//  Fresh-Chef-Analytics
//
//  Created by rgallardo on 7/22/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "Top3Bottom3TableViewCell.h"
#import "UIRefs.h"

@implementation Top3Bottom3TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    NSString *greenGood = [[UIRefs shared] green];
    NSString *redBad = [[UIRefs shared] red];
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    [self.frequency setFont:[UIFont systemFontOfSize:18]];
    [self.price setFont:[UIFont systemFontOfSize:18]];
//    [self.profit setFont:[UIFont systemFontOfSize:18]];
    
    if (self.selectedIndex == 0) {
        [self.frequency setFont:[UIFont boldSystemFontOfSize:20]];
        [self.frequency setTransform:CGAffineTransformMakeTranslation(0, -76)];
        [self.ratingView setTransform:CGAffineTransformMakeTranslation(0, 76)];
    }
    else
    {
        [self.frequency setTransform:CGAffineTransformMakeTranslation(0, 10)];
        [self.ratingView setTransform:CGAffineTransformMakeTranslation(0, -10)];
    }
    // set rating color
    if ([self.ratingCategory isEqualToString: @"high"]) {
        self.ratingView.backgroundColor = [[UIRefs shared] colorFromHexString:greenGood];
    } else if ([self.ratingCategory isEqualToString: @"medium"]) {
        self.ratingView.backgroundColor = [UIColor grayColor];
    } else {
        self.ratingView.backgroundColor = [[UIRefs shared] colorFromHexString:redBad];    }
    if ([self.freqCategory isEqualToString: @"high"]) {
        [self.frequency setTextColor:[[UIRefs shared] colorFromHexString:greenGood]];
    } else if ([self.freqCategory isEqualToString: @"medium"]) {
        [self.frequency setTextColor:UIColor.grayColor];
    } else {
        [self.frequency setTextColor:[[UIRefs shared] colorFromHexString:redBad]];
    }
    if ([self.profitCategory isEqualToString: @"high"]) {
        [self.profit setTextColor:[[UIRefs shared] colorFromHexString:greenGood]];
    } else if ([self.profitCategory isEqualToString: @"medium"]) {
        [self.profit setTextColor:UIColor.grayColor];
    } else {
        [self.profit setTextColor:[[UIRefs shared] colorFromHexString:redBad]];
    }
}

@end
