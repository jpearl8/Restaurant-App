//
//  OpenOrder.m
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/24/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "OpenOrder.h"

@implementation OpenOrder
@dynamic dish;
@dynamic amount;
@dynamic table;
@dynamic waiter;
@dynamic restaurant;
@dynamic restaurantId;
+ (nonnull NSString *)parseClassName {
    return @"OpenOrder";
}
+ (void)postNewOrder:(id)order withCompletion:(PFBooleanResultBlock)completion
{
    [order saveInBackgroundWithBlock:completion];
}

// function takes in an openOrder and dish, queries for dish amount, returns index in order
// if there is no dish, returns index -1
//+ (NSNumber *)searchOrderforDish:(OpenOrder *)openOrder withDish:(Dish *)dish giveIndex:(BOOL)index{
//    NSArray *dishes = openOrder.dishes;
//    for (int i = 0; i < dishes.count; i++){
//        if ([dish.name isEqualToString:((Dish *)dishes[i]).name]){
//            if (index){
//                return [NSNumber numberWithInt:i];
//            }
//            else {
//                return openOrder.amounts[i];
//            }
//        }
//    }
//    return [NSNumber numberWithInt:-1];
//}


@end
