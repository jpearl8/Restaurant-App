//
//  OrderManager.h
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/24/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "Dish.h"
#import "Waiter.h"
#import "OpenOrder.h"
#import "ClosedOrder.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderManager : NSObject
@property (strong, nonatomic) NSArray *openOrders;
@property (strong, nonatomic) NSArray *closedOrders;

+ (instancetype)shared;
- (void) fetchOpenOrderItems:(PFUser *) restaurant  withCompletion:(void (^)(NSArray * openOrders, NSError * error))fetchedOpenOrders;
- (void) fetchClosedOrderItems:(PFUser *) restaurant  withCompletion:(void (^)(NSArray * closedOrders, NSError * error))fetchedClosedOrders;
- (void) addToOrderArray: (OpenOrder *) order withDish: (Dish *) dish andAmount: (NSNumber*) amount;
- (void) moveOpenOrderToClosed : (OpenOrder *) order  withCompletion:(void (^)(NSError * error))removedOrder;
@end

NS_ASSUME_NONNULL_END
