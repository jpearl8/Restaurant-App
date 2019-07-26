//
//  SingleOpenOrder.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/25/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SingleOpenOrder : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dishName;
@property (weak, nonatomic) IBOutlet UILabel *amount;

@end

NS_ASSUME_NONNULL_END
