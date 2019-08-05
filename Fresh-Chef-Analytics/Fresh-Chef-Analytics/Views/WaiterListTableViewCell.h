//
//  WaiterListTableViewCell.h
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/19/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Waiter.h"

NS_ASSUME_NONNULL_BEGIN

@interface WaiterListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *waiterProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *waiterName;
@property (weak, nonatomic) IBOutlet UILabel *waiterTime;
@property (weak, nonatomic) IBOutlet UILabel *waiterRating;
@property (weak, nonatomic) IBOutlet UILabel *waiterTabletops;
@property (weak, nonatomic) IBOutlet UILabel *waiterNumCustomers;
@property (weak, nonatomic) IBOutlet UILabel *waiterTipsPC;
@property (weak, nonatomic) IBOutlet UILabel *waiterTipsPT;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (weak, nonatomic) IBOutlet UIView *cellView;
@property (strong, nonatomic) Waiter *waiter;
@end

NS_ASSUME_NONNULL_END
