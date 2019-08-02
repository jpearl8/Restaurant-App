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
    [self.delegate customerCommentForIndex:self.index withComment:self.customerComment.text];
   // self.customerComments[self.index] = self.customerComment.text;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    int characterLimit = 140;
    NSString *newText = [self.customerComment.text stringByReplacingCharactersInRange:range withString:text];
    self.charsRemaining.text = [NSString stringWithFormat: @"%d", (int)(characterLimit - newText.length)];
    return newText.length < characterLimit;
}

- (void) prepareForReuse{
    self.customerComment.text = @"";
     self.customerRating.value = 2.5;
    [super prepareForReuse];
}

- (IBAction)changeCustomerRating:(HCSStarRatingView *)sender {
    NSLog(@"%f", sender.value);
    //self.customerRatings[self.index] = [NSNumber numberWithDouble:(2 * sender.value)];
    [self.delegate customerRatingForIndex:self.index withRating:[NSNumber numberWithDouble:(2 * sender.value)]];
}


@end
