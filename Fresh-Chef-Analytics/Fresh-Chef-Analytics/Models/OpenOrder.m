//
//  OpenOrder.m
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/24/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "OpenOrder.h"

@implementation OpenOrder
@dynamic dishes;
@dynamic amounts;
@dynamic waiter;
@dynamic restaurant;
+ (nonnull NSString *)parseClassName {
    return @"OpenOrder";
}
+ (void)postNewOrder:(id)order withCompletion:(PFBooleanResultBlock)completion
{
    [order saveInBackgroundWithBlock:completion];
}

// function takes in an openOrder and dish, queries for dish amount, returns index in order
// if there is no dish, returns index -1


//- (NSUInteger) searchOrderforDish:(OpenOrder *)openOrder withDish:(Dish *)dish{
//    NSArray *orders = openOrder.orders;
//    for (NSUInteger i = 0; i < orders.count; i++){
//        if ([dish.name isEqualToString:((Dish *)orders[i][0]).name]){
//            return i;
//        }
//    }
//    return -1;
//}


@end
