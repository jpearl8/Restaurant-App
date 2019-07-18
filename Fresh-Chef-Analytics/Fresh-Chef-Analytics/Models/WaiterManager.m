//
//  WaiterManager.m
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/18/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "WaiterManager.h"

@implementation WaiterManager
// singleton generates a single instance and initiates itself
+ (instancetype)shared {
    static WaiterManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}
- (void)fetchWaiters:(PFUser *)restaurant
{
    // construct PFQuery
    PFQuery *waiterQuery;
    waiterQuery = [Waiter query];
    [waiterQuery whereKey:@"restaurantID" equalTo:restaurant.objectId];
    waiterQuery.limit = 20;
    
    // fetch data asynchronously
    [waiterQuery findObjectsInBackgroundWithBlock:^(NSArray<Waiter *> * _Nullable roster, NSError * _Nullable error) {
        self.roster = roster;
    }];
}
- (void) addWaiter:(Waiter *)waiter
{
    self.roster = [self.roster arrayByAddingObject:waiter];
}
@end
