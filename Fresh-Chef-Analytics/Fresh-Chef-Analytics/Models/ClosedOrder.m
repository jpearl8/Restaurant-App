//
//  ClosedOrder.m
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/24/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "ClosedOrder.h"

@implementation ClosedOrder

@dynamic dishes;
@dynamic amounts;
@dynamic waiter;
@dynamic restaurant;

+ (nonnull NSString *)parseClassName {
    return @"ClosedOrder";
}
+ (void) postOldOrderWithOpenOrder:(OpenOrder *)openOrder withCompletion:(PFBooleanResultBlock)completion{
    ClosedOrder *oldOrder = [ClosedOrder new];
    oldOrder.restaurant = openOrder.restaurant;
    oldOrder.dishes = openOrder.dishes;
    oldOrder.amounts = openOrder.amounts;
    oldOrder.waiter = openOrder.waiter;
    [oldOrder.waiter saveInBackground];
    [oldOrder saveInBackgroundWithBlock:completion];
    [openOrder deleteInBackground];
    
}

+ (void) postNewOrderWithDishes:(NSArray *)dishes withAmount:(NSArray *)amounts withRestaurant:(PFUser *)restaurant withWaiter:(Waiter *)waiter withCompletion:(PFBooleanResultBlock)completion
{
    ClosedOrder *newOrder = [ClosedOrder new];
    newOrder.restaurant = restaurant;
    newOrder.dishes = dishes;
    newOrder.amounts = amounts;
    newOrder.waiter = waiter;
    [newOrder saveInBackgroundWithBlock:completion];
}
@end
