//
//  WaiterCell.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 8/8/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"
#import "UITextView+Placeholder.h"
#import "Waiter.h"
#import "Helpful_funs.h"

NS_ASSUME_NONNULL_BEGIN
@protocol WaiterCellDelegate <NSObject>
- (void)waiterComment:(NSString *)comment;

- (void)waiterRating:(NSNumber *)rating;

@end

@interface WaiterCell : UITableViewCell <UITextViewDelegate>
@property (nonatomic, weak) id <WaiterCellDelegate> waiterDelegate;
@property (strong, nonatomic) IBOutlet HCSStarRatingView *waiterRating;
@property (strong, nonatomic) IBOutlet UIImageView *waiterPic;
@property (strong, nonatomic) IBOutlet UITextView *waiterComment;
@property (strong, nonatomic) IBOutlet UILabel *waiterNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *charsRemaining;
@property (strong, nonatomic) Waiter *waiter;


@property (weak, nonatomic) IBOutlet UIButton *b010;
@property (weak, nonatomic) IBOutlet UIButton *b08;
@property (weak, nonatomic) IBOutlet UIButton *b06;
@property (weak, nonatomic) IBOutlet UIButton *b04;
@property (weak, nonatomic) IBOutlet UIButton *b02;
@property (weak, nonatomic) IBOutlet UIButton *b00;
@property (strong, nonatomic) NSNumber *waiterRatingNum;
@property (strong, nonatomic) IBOutlet UIView *specialView;
@end

NS_ASSUME_NONNULL_END
