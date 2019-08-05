//
//  OrderCell.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 8/2/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *waiterName;
@property (strong, nonatomic) IBOutlet UILabel *tableNum;
@property (strong, nonatomic) IBOutlet UILabel *customerNum;
@property (strong, nonatomic) IBOutlet UIButton *orderButton;
@property (strong, nonatomic) IBOutlet UILabel *amoutsLabel;
@property (strong, nonatomic) IBOutlet UILabel *ordersLabel;

@end

NS_ASSUME_NONNULL_END
