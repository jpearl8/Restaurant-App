//
//  EditMenuCell.h
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/17/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dish.h"

NS_ASSUME_NONNULL_BEGIN

@protocol EditMenuCellDelegate;
@interface EditMenuCell : UITableViewCell
@property (weak, nonatomic) id<EditMenuCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *dishView;
@property (weak, nonatomic) IBOutlet UILabel *dishName;
@property (weak, nonatomic) IBOutlet UILabel *dishType;
@property (weak, nonatomic) IBOutlet UILabel *dishPrice;
@property (weak, nonatomic) IBOutlet UILabel *dishRating;
@property (weak, nonatomic) IBOutlet UILabel *dishFrequency;
@property (weak, nonatomic) IBOutlet UILabel *dishDescription;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (strong, nonatomic) Dish *dish;
@end

@protocol EditMenuCellDelegate

- (void) editMenuCell:(EditMenuCell*)editMenuCell didTap:(Dish *)dish;

@end
NS_ASSUME_NONNULL_END
