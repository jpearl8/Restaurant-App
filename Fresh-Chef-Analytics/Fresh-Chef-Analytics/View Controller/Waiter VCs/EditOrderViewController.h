//
//  EditOrderViewController.h
//  Fresh-Chef-Analytics
//
//  Created by rgallardo on 7/24/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenOrder.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditOrderViewController : UIViewController
@property (strong, nonatomic) NSArray <OpenOrder *>* openOrders;
@property (strong, nonatomic) NSMutableArray <OpenOrder *>* editableOpenOrders;
@property (strong, nonatomic) Waiter *waiter;
@property (strong, nonatomic) NSNumber *index;

@end

NS_ASSUME_NONNULL_END
