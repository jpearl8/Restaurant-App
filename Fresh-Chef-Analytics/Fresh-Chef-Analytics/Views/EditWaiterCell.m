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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    //make profile pictures round
    self.profileImage.layer.cornerRadius = 0.5 * self.profileImage.bounds.size.height;
    self.profileImage.layer.masksToBounds = YES;
    // Configure the view for the selected state
}

@end
