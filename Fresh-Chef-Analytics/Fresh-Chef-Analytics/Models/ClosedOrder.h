//  ClosedOrder.h
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/24/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "Waiter.h"
#import "Dish.h"
#import "OpenOrder.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClosedOrder : PFObject<PFSubclassing>
@property (nonatomic, strong) NSArray *dishes;
@property (nonatomic, strong) NSArray *amounts;
@property (nonatomic, strong) Waiter *waiter;
@property (nonatomic, strong) PFUser *restaurant;
@property (nonatomic, strong) NSString *restaurantId;
@property (nonatomic, strong) NSNumber *table;
@property (nonatomic, strong) NSNumber *numCustomers;
@property (nonatomic, strong) NSNumber *customerLevel;

+ (void) postOldOrder: (ClosedOrder *) order withCompletion : (PFBooleanResultBlock  _Nullable)completion;
@end
NS_ASSUME_NONNULL_END
