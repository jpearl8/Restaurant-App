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


- (IBAction)didStep:(specialStepper *)sender {
    self.amount.text = [NSString stringWithFormat:@"%.0f",sender.value];
}


- (void) prepareForReuse{
    self.amount.text = @"0";
    [super prepareForReuse];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



@end
