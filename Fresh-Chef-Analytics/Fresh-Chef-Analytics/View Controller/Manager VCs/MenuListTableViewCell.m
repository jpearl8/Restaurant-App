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
}

@end
