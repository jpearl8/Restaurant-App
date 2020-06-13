//
//  FunTableViewCell.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/17/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "FunTableViewCell.h"
#import "Helpful_funs.h"

@implementation FunTableViewCell

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
    if (self.customerComment.text){
        [self.funDelegate customerCommentForIndex:self.index withComment:self.customerComment.text];
//        self.customerComments[self.index] = self.customerComment.text;
    }
    //handle text editing finished
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    int characterLimit = 140;
    NSString *newText = [self.customerComment.text stringByReplacingCharactersInRange:range withString:text];
    self.charsRemaining.text = [NSString stringWithFormat: @"%d", (int)(characterLimit - newText.length)];
    return newText.length < characterLimit;
}

- (void) prepareForReuse{
    //self.amount.text = @"0";
    self.customerComment.text = @"";
    NSArray <UIButton *>* buttons = @[self.b0, self.b2, self.b4, self.b6, self.b8, self.b10];
    for (int i = 0; i < buttons.count; i++){
        [[Helpful_funs shared] defineSelect:buttons[i] withSelect:NO];
    }
    [super prepareForReuse];
}

- (IBAction)buttonTouch:(UIButton *)sender {

    NSArray <UIButton *>* buttons = @[self.b0, self.b2, self.b4, self.b6, self.b8, self.b10];
    for (int i = 0; i < buttons.count; i++){
        if ([buttons[i].restorationIdentifier isEqualToString:sender.restorationIdentifier]){
            [[Helpful_funs shared] defineSelect:buttons[i] withSelect:YES];
        } else {
            [[Helpful_funs shared] defineSelect:buttons[i] withSelect:NO];
        }
    }
    [self.funDelegate customerRatingForIndex:self.index withRating:[NSNumber numberWithFloat:[sender.restorationIdentifier floatValue]]];
   // self.customerRatings[self.index] = [NSNumber numberWithFloat:[sender.restorationIdentifier floatValue]];
}






@end
