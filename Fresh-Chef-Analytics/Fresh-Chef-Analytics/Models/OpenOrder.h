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
@property NSArray *dishes;
@property NSArray *amounts;
@property Waiter *waiter;
@property PFUser *restaurant;


+ (void) postNewOrder : (OpenOrder *) order withCompletion : (PFBooleanResultBlock  _Nullable)completion;

+ (NSNumber *)searchOrderforDish:(OpenOrder *)openOrder withDish:(Dish *)dish giveIndex:(BOOL)index;
@end
NS_ASSUME_NONNULL_END
