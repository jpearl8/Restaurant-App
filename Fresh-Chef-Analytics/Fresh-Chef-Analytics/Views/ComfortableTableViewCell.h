//
//  ComfortableTableViewCell.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/19/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//
#import "HCSStarRatingView.h"
#import <UIKit/UIKit.h>
#import "Dish.h"
#import "order.h"
#import "UITextView+Placeholder.h"

NS_ASSUME_NONNULL_BEGIN

@interface ComfortableTableViewCell : UITableViewCell <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *charsRemaining;
@property (strong, nonatomic) order *order;
@property (weak, nonatomic) IBOutlet UILabel *dishName;
@property (weak, nonatomic) IBOutlet UILabel *dishType;
@property (weak, nonatomic) IBOutlet UILabel *dishDescription;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *customerRating;
@property (strong, nonatomic) IBOutlet  UITextView *customerComment;
@end

NS_ASSUME_NONNULL_END
