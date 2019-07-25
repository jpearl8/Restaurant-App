//
//  OpenOrders=.h
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/24/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "Waiter.h"
#import "Dish.h"
#import "OpenOrder.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClosedOrder : PFObject<PFSubclassing>
@property NSArray *dishes;
@property NSArray *amounts;
@property Waiter *waiter;
@property PFUser *restaurant;
+ (void) postOldOrderWithOpenOrder:(OpenOrder *)openOrder withCompletion:(PFBooleanResultBlock)completion;
+ (void) postOldOrder: (NSArray *) dishes withAmount : (NSArray *) amounts withRestaurant: (PFUser *) restaurant withWaiter : (Waiter *) waiter withCompletion : (PFBooleanResultBlock  _Nullable)completion;
@end
NS_ASSUME_NONNULL_END
