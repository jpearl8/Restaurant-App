//
//  WaiterManager.h
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/18/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "Waiter.h"

NS_ASSUME_NONNULL_BEGIN

@interface WaiterManager : NSObject
@property (strong, nonatomic) NSArray *roster;
@property (strong, nonatomic) NSArray *rosterByRating;
@property (strong, nonatomic) NSArray *rosterByTables;
@property (strong, nonatomic) NSArray *rosterByCustomers;
@property (strong, nonatomic) NSArray *rosterByTipsCustomers;
@property (strong, nonatomic) NSArray *rosterByTipsTables;

@property (strong, nonatomic) NSArray *rosterByYears;

+ (instancetype) shared;
- (void) fetchWaiters : (PFUser *) restaurant withCompletion:(void (^)(NSError * _Nullable error))fetchedWaiters;
- (void) addWaiter : (Waiter *) waiter;
- (void) removeWaiterFromTable : (Waiter *) delWaiter withCompletion:(void (^)(NSError * _Nullable error))removeWaiter;
- (void)setOrderedWaiterArrays;
- (void) findWaiter : (NSString *) objectId withCompletion:(void (^)(NSArray * waiter, NSError * _Nullable error)) completion;
- (NSNumber *) averageRating : (Waiter *) waiter;
- (NSNumber *) averageTipsByTable : (Waiter *) waiter;
- (NSNumber *) averageTipByCustomer : (Waiter *) waiter;


@end

NS_ASSUME_NONNULL_END
