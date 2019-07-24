//
//  ElegantTableViewCell.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/19/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "ElegantTableViewCell.h"

@implementation ElegantTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.customerComment.delegate = self;
    self.customerComment.placeholder = @"Comments for the chef";
    self.customerComment.placeholderColor = [UIColor lightGrayColor];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)textViewDidChange:(UITextView *)textView{
    self.order.customerComments = self.customerComment.text;
}

- (void) prepareForReuse{
    self.customerComment.text = @"0";
    self.customerRating.value = 5;
    [super prepareForReuse];
}

- (IBAction)changeCustomerRating:(UISlider *)sender {
    NSLog(@"%f", sender.value);
    self.order.customerRating = sender.value;
}

@end
