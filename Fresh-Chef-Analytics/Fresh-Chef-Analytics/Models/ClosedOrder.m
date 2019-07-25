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
@dynamic table;
@dynamic numCustomers;
@dynamic restaurantId;

+ (nonnull NSString *)parseClassName {
    return @"ClosedOrder";
}

+ (void)postOldOrder:(ClosedOrder *) order withCompletion:(PFBooleanResultBlock)completion
{
    [order saveInBackgroundWithBlock:completion];
    
}

@end
