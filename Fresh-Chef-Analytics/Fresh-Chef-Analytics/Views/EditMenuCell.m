//
//  EditMenuTableViewCell.m
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/17/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "EditMenuCell.h"

@implementation EditMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *buttonTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapRemove:)];
    [self.removeButton addGestureRecognizer:buttonTapGesture];
    [self.removeButton setUserInteractionEnabled:YES];
    
}
- (void) didTapRemove:(UITapGestureRecognizer *)sender
{
    [self.delegate editMenuCell:self didTap:self.dish];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
