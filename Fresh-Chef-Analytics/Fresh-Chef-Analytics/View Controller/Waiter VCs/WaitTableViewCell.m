//
//  WaitTableViewCell.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/17/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "WaitTableViewCell.h"


@implementation WaitTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.checkBox.boxType = BEMBoxTypeSquare;
    // Configure the view for the selected state
}

@end
