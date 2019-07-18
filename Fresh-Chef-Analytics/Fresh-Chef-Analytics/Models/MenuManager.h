//
//  MenuManager.h
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/17/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "Dish.h"
NS_ASSUME_NONNULL_BEGIN

@interface MenuManager : NSObject
@property (strong, nonatomic) NSArray * dishes;
@property (strong, nonatomic) NSMutableDictionary *categoriesOfDishes;
+ (instancetype) shared;
- (void) fetchMenuItems : (PFUser *) restaurant;
- (void) addDishToDict : (Dish *) dish toArray: (NSArray *) dishesOfType;
@end

NS_ASSUME_NONNULL_END
