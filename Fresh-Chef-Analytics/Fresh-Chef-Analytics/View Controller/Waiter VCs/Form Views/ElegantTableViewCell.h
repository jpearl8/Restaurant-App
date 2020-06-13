//
//  ElegantTableViewCell.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/19/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dish.h"
#import "UITextView+Placeholder.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ElegantCellDelegate <NSObject>
- (void)customerCommentForIndex:(int)index withComment:(NSString *)comment;
- (void)customerRatingForIndex:(int)index withRating:(NSNumber *)rating;
@end

@interface ElegantTableViewCell : UITableViewCell <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *charsRemaining;
@property (nonatomic, weak) id <ElegantCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *dishName;
@property (weak, nonatomic) IBOutlet UILabel *dishType;
@property (weak, nonatomic) IBOutlet UILabel *dishDescription;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UISlider *customerRating;
@property (strong, nonatomic) IBOutlet  UITextView *customerComment;
@property (strong, nonatomic) NSMutableArray *customerRatings;
@property (strong, nonatomic) NSMutableArray *customerComments;
@property (assign, nonatomic) int index;
@end

NS_ASSUME_NONNULL_END
