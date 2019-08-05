//
//  WaiterManager.m
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/18/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "WaiterManager.h"
#import "Helpful_funs.h"

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
- (void)fetchWaiters:(PFUser *)restaurant withCompletion:(void (^)(NSError * _Nullable))fetchedWaiters
{
    // construct PFQuery
    PFQuery *waiterQuery;
    waiterQuery = [Waiter query];
    [waiterQuery whereKey:@"restaurantID" equalTo:restaurant.objectId];
    [waiterQuery includeKey:@"updatedAt"];
    waiterQuery.limit = 20;
    
    // fetch data asynchronously
    [waiterQuery findObjectsInBackgroundWithBlock:^(NSArray<Waiter *> * _Nullable roster, NSError * _Nullable error) {
        self.roster = roster;
        fetchedWaiters(error);
    }];
    
}
- (NSNumber *) averageTipByCustomer : (Waiter *) waiter
{
    if (![waiter.numOfCustomers isEqualToNumber:@(0)])
    {
        return [NSNumber numberWithFloat:(round([waiter.tipsMade floatValue] / [waiter.numOfCustomers floatValue]* 100) / 100)];
    }
    return @(0);
}
- (NSNumber *) averageTipsByTable : (Waiter *) waiter
{
    if (![waiter.tableTops isEqualToNumber:@(0)])
    {
        return [NSNumber numberWithFloat:(round([waiter.tipsMade floatValue] / [waiter.tableTops floatValue]* 100) / 100)];
    }
    return @(0);
}
- (void)setOrderedWaiterArrays {
    self.rosterByRating = [[Helpful_funs shared] orderArray:self.roster byType:@"rating"];
    self.rosterByTables = [[Helpful_funs shared] orderArray:self.roster byType:@"tableTops"];
    self.rosterByCustomers = [[Helpful_funs shared] orderArray:self.roster byType:@"numOfCustomers"];
    self.rosterByTipsCustomers = [[Helpful_funs shared] orderArray:self.roster byType:@"tipsByCustomers"];
    self.rosterByTipsTables = [[Helpful_funs shared] orderArray:self.roster byType:@"tipsByTable"];
    self.rosterByYears = [[Helpful_funs shared] orderArray:self.roster byType:@"yearsWorked"];
}
- (NSNumber *) averageRating : (Waiter *) waiter
{
    if (waiter.rating != nil && ![waiter.tableTops isEqualToNumber:@(0)])
    {
        return [NSNumber numberWithFloat:floorf(([waiter.rating floatValue] / [waiter.tableTops floatValue]*100)/100)];
    }
    return @(0);
}

- (void) addWaiter:(Waiter *)waiter
{
    self.roster = [self.roster arrayByAddingObject:waiter];
}
- (void)removeWaiterFromTable:(Waiter *)delWaiter withCompletion:(void (^)(NSError * _Nullable))removedWaiter

{
    // construct PFQuery
    PFQuery *waiterQuery;
    waiterQuery = [Waiter query];
    [waiterQuery whereKey:@"objectId" equalTo:delWaiter.objectId];
    [waiterQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable waiters, NSError * _Nullable error) {
        for (Waiter *waiter in waiters)
        {
            [waiter deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded)
                {
                    NSLog(@"Object removed");
                    [self fetchWaiters:PFUser.currentUser withCompletion:^(NSError * _Nullable error) {
                        if (error==nil)
                        {
                            removedWaiter(nil);
                        }
                        else
                        {
                            removedWaiter(error);
                        }
                    }];
                }
            }];
        }
    }];
}
- (void) findWaiter : (NSString *) objectId withCompletion:(void (^)(NSArray * waiter, NSError * _Nullable error)) completion
{
    PFQuery *waiterQuery;
    waiterQuery = [Waiter query];
    [waiterQuery whereKey:@"objectId" equalTo:objectId];
    [waiterQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable waiters, NSError * _Nullable error) {
        NSLog(@"finished querying for waiters");
        if (!error)
        {
            NSLog(@"found waiters %@", waiters);
            completion(waiters, nil);
        }
        else
        {
            NSLog(@"Error: %@", error.localizedDescription);
            completion(nil, error);
        }
    }];

}
- (Waiter *) findWaiterwithRoster : (NSString *) objectId
{
    for (int i = 0; i < self.roster.count; i++){
        if ([((Waiter *)self.roster[0]).objectId isEqual:objectId]){
            return self.roster[i];
        }
    }
    return nil;
}

    

@end
