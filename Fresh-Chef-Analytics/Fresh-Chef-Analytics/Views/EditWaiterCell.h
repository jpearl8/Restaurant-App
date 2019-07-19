//
//  EditWaiterCell.h
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/18/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Waiter.h"

NS_ASSUME_NONNULL_BEGIN

@protocol EditWaiterCellDelegate;

@interface EditWaiterCell : UITableViewCell
@property (weak, nonatomic) id<EditWaiterCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *waiterName;
@property (weak, nonatomic) IBOutlet UILabel *waiterYearsAt;
@property (weak, nonatomic) IBOutlet UILabel *waiterRating;
@property (weak, nonatomic) IBOutlet UILabel *waiterTips;
@property (weak, nonatomic) IBOutlet UILabel *waiterTableTops;
@property (weak, nonatomic) IBOutlet UILabel *waiterNumCustomers;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (strong, nonatomic) Waiter *waiter;
@end
@protocol EditWaiterCellDelegate

- (void) editWaiterCell:(EditWaiterCell*)editWaiterCell didTap:(Waiter *) waiter;

@end
NS_ASSUME_NONNULL_END
