//
//  EditOrderViewCell.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/31/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "EditOrderViewCell.h"
#import "UIRefs.h"

@implementation EditOrderViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.amount.delegate = self;
    self.contentView.layer.borderWidth = .5f;
    self.contentView.layer.borderColor = [[UIRefs shared] colorFromHexString:[UIRefs shared].purpleAccent].CGColor;

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)textViewDidChange:(UITextView *)textView{
    NSLog(@"%@", self.amount.text);
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    [self.delegate changeAmount:[f numberFromString:self.amount.text] atIndex:self.index];
    // self.customerComments[self.index] = self.customerComment.text;
}


- (IBAction)didDelete:(UIButton *)sender {
    [self.delegate deleteRowAtIndex:self.index];
}

@end
