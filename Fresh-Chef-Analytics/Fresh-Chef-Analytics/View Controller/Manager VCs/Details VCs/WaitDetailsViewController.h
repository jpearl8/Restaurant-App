//
//  WaitDetailsViewController.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Waiter.h"

NS_ASSUME_NONNULL_BEGIN

@interface WaitDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *ratingView;

@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UIImageView *waiterProfileImage;
@property (strong, nonatomic) Waiter *waiter;
@property (weak, nonatomic) IBOutlet UILabel *waiterName;
@property (weak, nonatomic) IBOutlet UILabel *waiterTime;
@property (weak, nonatomic) IBOutlet UILabel *waiterTabletops;
@property (weak, nonatomic) IBOutlet UILabel *waiterNumCustomers;
@property (weak, nonatomic) IBOutlet UILabel *waiterTipsPC;
@property (weak, nonatomic) IBOutlet UILabel *waiterTipsPT;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

NS_ASSUME_NONNULL_END
