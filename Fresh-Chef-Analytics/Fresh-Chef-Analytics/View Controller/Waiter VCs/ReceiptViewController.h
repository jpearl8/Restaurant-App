//
//  ReceiptViewController.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenOrder.h"
#import "ClosedOrder.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReceiptViewController : UIViewController
@property (strong, nonatomic) NSArray<OpenOrder *>*openOrders;
@property (strong, nonatomic) Waiter *waiter;
@property (strong, nonatomic) NSMutableArray <Dish *>*dishesArray;
@end

NS_ASSUME_NONNULL_END
