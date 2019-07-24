//
//  OpenOrder.m
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/24/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "OpenOrder.h"

@implementation OpenOrder
@dynamic orders;
@dynamic waiter;

+ (nonnull NSString *)parseClassName {
    return @"OpenOrder";
}
+ (void) postNewOrder: (NSArray *) order withWaiter : (Waiter *) waiter withCompletion : (PFBooleanResultBlock  _Nullable)completion
{
    OpenOrder *newOrder = [OpenOrder new];
    newOrder.orders = order;
    newOrder.waiter = waiter;
    [newOrder saveInBackgroundWithBlock:completion];
}
@end
