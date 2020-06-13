//
//  EditWaiterCell.m
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/18/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "EditWaiterCell.h"

@implementation EditWaiterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *buttonTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapRemove:)];
    [self.removeButton addGestureRecognizer:buttonTapGesture];
    [self.removeButton setUserInteractionEnabled:YES];
    self.removeButton.layer.shadowRadius  = 1.5f;
    self.removeButton.layer.shadowColor   = [UIColor colorWithRed:176.f/255.f green:199.f/255.f blue:226.f/255.f alpha:1.f].CGColor;
    self.removeButton.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    self.removeButton.layer.shadowOpacity = 0.9f;
    self.removeButton.layer.masksToBounds = NO;
    
    UIEdgeInsets shadowInsets     = UIEdgeInsetsMake(0, 0, -1.5f, 0);
    UIBezierPath *shadowPath      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(self.removeButton.bounds, shadowInsets)];
    self.removeButton.layer.shadowPath    = shadowPath.CGPath;
}
- (void) didTapRemove:(UITapGestureRecognizer *)sender
{
    [self.delegate editWaiterCell:self didTap:self.waiter];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    //make profile pictures round
    self.profileImage.layer.cornerRadius = 0.5 * self.profileImage.bounds.size.height;
    self.profileImage.layer.masksToBounds = YES;
    // Configure the view for the selected state
}

@end
