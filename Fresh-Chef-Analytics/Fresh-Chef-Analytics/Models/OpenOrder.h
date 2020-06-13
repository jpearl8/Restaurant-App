//
//  OpenOrders=.h
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/24/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "Waiter.h"
#import "Dish.h"

NS_ASSUME_NONNULL_BEGIN

@interface OpenOrder : PFObject<PFSubclassing>
@property (nonatomic, strong) Dish *dish;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) Waiter *waiter;
@property (nonatomic, strong) PFUser *restaurant;
@property (nonatomic, strong) NSNumber *table;
@property (nonatomic, strong) NSString *restaurantId;
@property (nonatomic, strong) NSNumber *customerNum;
@property (nonatomic, strong) NSNumber *customerLevel;
@property (nonatomic, strong) NSString *customerEmail;

+ (void) postNewOrder : (OpenOrder *) order withCompletion : (PFBooleanResultBlock  _Nullable)completion;


@end
NS_ASSUME_NONNULL_END

