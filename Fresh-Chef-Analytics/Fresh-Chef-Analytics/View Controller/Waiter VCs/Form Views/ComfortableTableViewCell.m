//
//  ComfortableTableViewCell.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/19/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "ComfortableTableViewCell.h"

@implementation ComfortableTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)textViewDidChange:(UITextView *)textView{
    self.customerComments[self.index] = self.customerComment.text;
}

- (void) prepareForReuse{
    self.customerComment.text = @"0";
     self.customerRating.value = 2.5;
    [super prepareForReuse];
}

- (IBAction)changeCustomerRating:(HCSStarRatingView *)sender {
    NSLog(@"%f", sender.value);
    self.customerRatings[self.index] = 2 * sender.value;
}


@end
