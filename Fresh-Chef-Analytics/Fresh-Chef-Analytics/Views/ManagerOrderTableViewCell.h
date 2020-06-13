//
//  ManagerOrderTableViewCell.h
//  Fresh-Chef-Analytics
//
//  Created by rgallardo on 7/26/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ManagerOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *waiterLabel;
@property (weak, nonatomic) IBOutlet UILabel *tableLable;
@property (weak, nonatomic) IBOutlet UILabel *tableSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel; // time since order for open orders and time of order for closed orders

@end

NS_ASSUME_NONNULL_END
