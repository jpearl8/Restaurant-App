//
//  WaiterCell.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 8/8/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "WaiterCell.h"

@implementation WaiterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.waiterComment.delegate = self;
    self.waiterComment.placeholder = @"Comments on your waiter";
    self.waiterComment.placeholderColor = [UIColor lightGrayColor];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)textViewDidChange:(UITextView *)textView{
    [self.waiterDelegate waiterComment:self.waiterComment.text];
    // self.customerComments[self.index] = self.customerComment.text;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    int characterLimit = 140;
    NSString *newText = [self.waiterComment.text stringByReplacingCharactersInRange:range withString:text];
    self.charsRemaining.text = [NSString stringWithFormat: @"%d", (int)(characterLimit - newText.length)];
    return newText.length < characterLimit;
}
- (IBAction)changeWaiterRating:(HCSStarRatingView *)sender {
    NSLog(@"%f", sender.value);
    //self.customerRatings[self.index] = [NSNumber numberWithDouble:(2 * sender.value)];
    [self.waiterDelegate waiterRating:[NSNumber numberWithDouble:(2 * sender.value)]];
}

- (IBAction)buttonTouch:(UIButton *)sender {
    NSArray <UIButton *>* buttons = @[self.b00, self.b02, self.b04, self.b06, self.b08, self.b010];
    for (int i = 0; i < buttons.count; i++){
        if ([buttons[i].restorationIdentifier isEqualToString:sender.restorationIdentifier]){
            [[Helpful_funs shared] defineSelect:buttons[i] withSelect:YES];
            
        } else {
            [[Helpful_funs shared] defineSelect:buttons[i] withSelect:NO];
        }
    }
    if ([sender.restorationIdentifier floatValue]< 0){
        self.waiterRatingNum = 0;
    } else{
        self.waiterRatingNum = [NSNumber numberWithDouble:([sender.restorationIdentifier floatValue] / 10.0)];
    }
    [self.waiterDelegate waiterRating:self.waiterRatingNum];
}

@end
