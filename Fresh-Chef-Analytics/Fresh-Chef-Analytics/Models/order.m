//
//  order.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/17/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "order.h"


@implementation order
+(order *)makeOrderItem: (Dish*)dish withAmount: (float)amount{
    order *myOrder = [[order alloc] init];
    myOrder.dish = dish;
    myOrder.amount = amount;
    myOrder.customerRating = -1.0;
    myOrder.customerComments = @"";
    myOrder.waiter = nil;
    myOrder.waiterRating = -1.0;
    myOrder.waiterReview = @"";
    return myOrder;
}
@end
