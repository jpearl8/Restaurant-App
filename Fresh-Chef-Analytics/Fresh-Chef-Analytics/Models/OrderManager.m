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
    NSArray *orderObject = @[dish, amount];
    [order addObject:orderObject forKey:@"orders"];
}
- (void) moveOpenOrderToClosed : (OpenOrder *) order  withCompletion:(void (^)(OpenOrder * order, NSError * error))removedOrder
{
    [order deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded)
        {
            NSLog(@"Order removed");
            [ClosedOrder postNewOrder:order.orders withWaiter:order.waiter withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded)
                {
                    NSLog(@"Added to closed order table");
                }
                else
                {
                    NSLog(@"Error in adding to table: %@", error.localizedDescription);
                }
            }];
        }
    }];
}
@end
