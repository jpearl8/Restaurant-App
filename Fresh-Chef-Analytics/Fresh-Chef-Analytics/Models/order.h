//
//  order.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/17/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dish.h"
#import "Waiter.h"

NS_ASSUME_NONNULL_BEGIN

@interface order : NSObject
@property (nonatomic, strong) Dish *dish;
@property (nonatomic, assign) float amount;
@property (nonatomic, assign) float customerRating;
@property (nonatomic, strong) NSString *customerComments;
@property (nonatomic, strong, nullable) Waiter *waiter;
@property (nonatomic, assign) float waiterRating;
@property (nonatomic, strong) NSString *waiterReview;

+(order *)makeOrderItem: (Dish*)dish withAmount: (float)amount;
@end
 
NS_ASSUME_NONNULL_END
