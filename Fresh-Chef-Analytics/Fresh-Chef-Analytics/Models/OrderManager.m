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

- (void) fetchOpenOrderItems:(PFUser *) restaurant  withCompletion:(void (^)(NSArray * openOrders, NSError * error))fetchedOpenOrders
{
    PFQuery *openOrderQuery;
    openOrderQuery = [OpenOrder query];
    [openOrderQuery whereKey:@"restaurantId" equalTo:restaurant.objectId];
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
    [closedOrderQuery whereKey:@"restaurantId" equalTo:restaurant.objectId];
    [closedOrderQuery findObjectsInBackgroundWithBlock:^(NSArray * closedOrders, NSError * error) {
        if (!error)
        {
            self.closedOrders = closedOrders;
            fetchedClosedOrders(self.closedOrders, nil);
        }
    }];
}
- (void) makingClosedOrder : (PFUser * ) restaurant withTable : (NSNumber *) table forWaiter : (Waiter *) waiter withCustomerNum : (NSNumber *) customerNum withCompletion : (void (^)(NSError * error))completion
{
    NSMutableArray *ordersToClose;
    ClosedOrder *newAddition = [ClosedOrder new];
    newAddition.restaurant = restaurant;
    newAddition.table = table;
    newAddition.numCustomers = customerNum;
    __block NSString *dishName;
    __block NSNumber *dishAmount;
    __block int doneWithArray = 0;
    PFQuery *orderQuery;
    orderQuery = [OpenOrder query];
    [orderQuery whereKey:@"restaurantId" equalTo:restaurant.objectId];
//    [orderQuery whereKey:@"table" equalTo:table];
    [orderQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable orders, NSError * _Nullable error) {
        if (orders)
        {
            
            for (int i = 0; i < orders.count; i++)
            {
                OpenOrder *temp = orders[i];
                Dish *tempDish = temp.dish;
                dishName = tempDish.name;
                dishAmount = temp.amount;
                [orders[i] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded)
                    {
                        NSLog(@"Order removed");
                        [newAddition addObject:dishName forKey:@"dishes"];
                        [newAddition addObject:dishAmount forKey:@"amounts"];
                        doneWithArray++;
                    }
                    else
                    {
                        NSLog(@"Error: %@", error.localizedDescription);
                    }
                }];
            }
            if (doneWithArray == orders.count)
            {
                [newAddition saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded)
                    {
                        NSLog(@"Closed order saved");
                        [self fetchOpenOrderItems:restaurant withCompletion:^(NSArray * _Nonnull openOrders, NSError * _Nonnull error) {
                            if (succeeded)
                            {
                                NSLog(@"Updated open orders");
                                [self fetchClosedOrderItems:PFUser.currentUser withCompletion:^(NSArray *closedOrders, NSError *error) {
                                    if (!error)
                                    {
                                        self.closedOrders = closedOrders;
                                        NSLog(@"Updated closed orders");
                                    }
                                    else
                                    {
                                        completion(error);
                                    }
                                }];
                            }
                            else
                            {
                                completion(error);
                            }
                        }];
                    }
                    else
                    {
                        completion(error);
                    }
                }];
            }
        }
        else
        {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
    completion(nil);
    
}

@end
