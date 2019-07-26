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
@dynamic customerNum;
+ (nonnull NSString *)parseClassName {
    return @"OpenOrder";
}
+ (void)postNewOrder:(id)order withCompletion:(PFBooleanResultBlock)completion
{
    [order saveInBackgroundWithBlock:completion];
}


@end
