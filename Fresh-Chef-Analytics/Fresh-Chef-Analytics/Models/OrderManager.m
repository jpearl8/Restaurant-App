//
//  OrderManager.m
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/24/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "OrderManager.h"

@implementation OrderManager
// singleton generates a single instance and initiates itself
+ (instancetype)shared {
    static OrderManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}
- (void) addToOrderArray: (OpenOrder *) order withDish: (Dish *) dish andAmount: (NSNumber*) amount
{
    [order addObject:dish forKey:@"dishes"];
    [order addObject:amount forKey:@"amounts"];
}
- (void) fetchOpenOrderItems:(PFUser *) restaurant  withCompletion:(void (^)(NSArray * openOrders, NSError * error))fetchedOpenOrders
{
    PFQuery *openOrderQuery;
    openOrderQuery = [OpenOrder query];
    [openOrderQuery whereKey:@"restaurant" equalTo:restaurant];
    [openOrderQuery findObjectsInBackgroundWithBlock:^(NSArray * openOrders, NSError * error) {
        if (!error)
        {
            self.openOrders = openOrders;
            fetchedOpenOrders(self.openOrders, nil);
        }
    }];
}
- (void) fetchClosedOrderItems:(PFUser *) restaurant  withCompletion:(void (^)(NSArray * closedOrders, NSError * error))fetchedClosedOrders
{
    PFQuery *closedOrderQuery;
    closedOrderQuery = [ClosedOrder query];
    [closedOrderQuery whereKey:@"restaurant" equalTo:restaurant];
    [closedOrderQuery findObjectsInBackgroundWithBlock:^(NSArray * closedOrders, NSError * error) {
        if (!error)
        {
            self.closedOrders = closedOrders;
            fetchedClosedOrders(self.closedOrders, nil);
        }
    }];
}
- (void) moveOpenOrderToClosed : (OpenOrder *) order  withCompletion:(void (^)(NSError * error))removedOrder
{
    [order deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded)
        {
            NSLog(@"Order removed");
            [ClosedOrder postOldOrder:order.dishes withAmount:order.amounts withRestaurant:order.restaurant withWaiter:order.waiter withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded)
                {
                    [self fetchOpenOrderItems:PFUser.currentUser withCompletion:^(NSArray *openOrders, NSError *error) {
                        if (!error)
                        {
                            self.openOrders = openOrders;
                            NSLog(@"Updated open orders");
                            [self fetchClosedOrderItems:PFUser.currentUser withCompletion:^(NSArray *closedOrders, NSError *error) {
                                if (!error)
                                {
                                    self.closedOrders = closedOrders;
                                    NSLog(@"Updated closed orders");
                                }
                                else
                                {
                                    removedOrder(error);
                                }
                            }];
                        }
                        else
                        {
                            removedOrder(error);
                        }
                    }];
                    
                }
                else
                {
                    NSLog(@"Error in adding to table: %@", error.localizedDescription);
                    removedOrder(error);
                }
            }];
        }
        else
        {
            removedOrder(error);
        }
    }];
    removedOrder(nil);
}

@end
