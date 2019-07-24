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

NS_ASSUME_NONNULL_BEGIN

@interface OpenOrder : PFObject<PFSubclassing>
@property NSArray *dishes;
@property NSArray *amounts;
@property Waiter *waiter;
@property PFUser *restaurant;
<<<<<<< HEAD
+ (void) postNewOrder: (NSArray *) order withRestaurant: (PFUser *) restaurant withWaiter : (Waiter *) waiter withCompletion : (PFBooleanResultBlock  _Nullable)completion;

=======
+ (void) postNewOrder : (OpenOrder *) order withCompletion : (PFBooleanResultBlock  _Nullable)completion;
>>>>>>> 21b49196f2c7fd4ab947dfc1797a2964f8df1c89
- (NSUInteger) searchOrderforDish:(OpenOrder *)openOrder withDish:(Dish *)dish;
@end
NS_ASSUME_NONNULL_END
