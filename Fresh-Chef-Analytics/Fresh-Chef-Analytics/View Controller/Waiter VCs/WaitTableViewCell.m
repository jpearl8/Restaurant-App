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

    //[self didTapCheckBox:self.checkBox];
    // Initialization code
}
//-(void)didTapCheckBox:(BEMCheckBox *)checkBox{
//    self.checked = self.checkBox.on;
//}

- (IBAction)didStep:(UIStepper *)sender;{
    self.amount.text = [NSString stringWithFormat:@"%.20lf",sender.value];
    self.orderAmount = [self.amount.text integerValue];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



@end
