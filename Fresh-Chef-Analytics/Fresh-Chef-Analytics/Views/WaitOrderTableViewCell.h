//
//  WaitOrderTableViewCell.h
//  Fresh-Chef-Analytics
//
//  Created by rgallardo on 7/24/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WaitOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tableNumber;
@property (weak, nonatomic) IBOutlet UILabel *customerNumber;
@property (weak, nonatomic) IBOutlet UILabel *waiterName;
@property (weak, nonatomic) IBOutlet UITableView *ordersTable;

@end

NS_ASSUME_NONNULL_END
