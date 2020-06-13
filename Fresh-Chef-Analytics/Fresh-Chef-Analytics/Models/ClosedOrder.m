#import "ClosedOrder.h"

@implementation ClosedOrder

@dynamic dishes;
@dynamic amounts;
@dynamic waiter;
@dynamic restaurant;
@dynamic table;
@dynamic numCustomers;
@dynamic restaurantId;
@dynamic customerLevel;

+ (nonnull NSString *)parseClassName {
    return @"ClosedOrder";
}
+ (void)postOldOrder:(ClosedOrder *) order withCompletion:(PFBooleanResultBlock)completion
{
    [order saveInBackgroundWithBlock:completion];
    
}

@end
