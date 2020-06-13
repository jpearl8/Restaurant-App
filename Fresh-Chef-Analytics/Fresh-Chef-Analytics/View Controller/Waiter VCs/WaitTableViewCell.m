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




- (void) prepareForReuse{
    self.amount.text = @"0";
    [super prepareForReuse];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



- (IBAction)didStep:(UIStepper *)sender {
    [self.delegate stepperIncrement:sender.value withDish:self.dish];
    self.amount.text = [NSString stringWithFormat:@"%.0f",sender.value];
}
- (IBAction)plusDish:(UIButton *)sender {
    self.value++;
    self.amount.text = [NSString stringWithFormat:@"%.0f",self.value];
    [self.delegate stepperIncrement:self.value withDish:self.dish];
}
- (IBAction)minusDish:(UIButton *)sender {
    if (self.value != 0){
        self.value--;
    }
    self.amount.text = [NSString stringWithFormat:@"%.0f",self.value];
    [self.delegate stepperIncrement:self.value withDish:self.dish];
}

@end
