//
//  FunTableViewCell.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/17/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dish.h"
#import "UITextView+Placeholder.h"
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FunCellDelegate <NSObject>
- (void)customerCommentForIndex:(int)index withComment:(NSString *)comment;
- (void)customerRatingForIndex:(int)index withRating:(NSNumber *)rating;

@end

@interface FunTableViewCell : UITableViewCell <UITextViewDelegate> 
@property (weak, nonatomic) IBOutlet UILabel *charsRemaining;
@property (nonatomic, weak) id <FunCellDelegate> funDelegate;
@property (weak, nonatomic) IBOutlet UILabel *dishName;
@property (strong, nonatomic) IBOutlet UIView *specialView;
@property (weak, nonatomic) IBOutlet UILabel *dishType;
@property (weak, nonatomic) IBOutlet UILabel *dishDescription;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (strong, nonatomic) IBOutlet  UITextView *customerComment;
@property (weak, nonatomic) IBOutlet UIButton *b0;
@property (weak, nonatomic) IBOutlet UIButton *b2;
@property (weak, nonatomic) IBOutlet UIButton *b4;
@property (weak, nonatomic) IBOutlet UIButton *b6;
@property (weak, nonatomic) IBOutlet UIButton *b8;
@property (weak, nonatomic) IBOutlet UIButton *b10;
@property (strong, nonatomic) NSMutableArray *customerRatings;
@property (strong, nonatomic) NSMutableArray *customerComments;
@property (assign, nonatomic) int index;



@end

NS_ASSUME_NONNULL_END
