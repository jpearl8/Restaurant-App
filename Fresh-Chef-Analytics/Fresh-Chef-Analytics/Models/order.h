//
//  order.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/17/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dish.h"

NS_ASSUME_NONNULL_BEGIN

@interface order : NSObject
@property (nonatomic, strong) Dish *dish;
@property (nonatomic, assign) float amount;
+(order *)makeOrderItem: (Dish*)dish withAmount: (float)amount;
@end
 
NS_ASSUME_NONNULL_END
