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
+ (instancetype) shared;
- (void) fetchWaiters : (PFUser *) restaurant;
- (void) addWaiter : (Waiter *) waiter;
@end

NS_ASSUME_NONNULL_END