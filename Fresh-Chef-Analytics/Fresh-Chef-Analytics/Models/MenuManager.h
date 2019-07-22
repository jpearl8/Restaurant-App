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
@property (strong, nonatomic) NSMutableDictionary *dishesByFreq;
@property (strong, nonatomic) NSMutableDictionary *dishesByRating;
@property (strong, nonatomic) NSMutableDictionary *dishesByPrice;
@property (strong, nonatomic) NSArray *sortByArray;
+ (instancetype) shared;
- (void) fetchMenuItems : (PFUser *) restaurant withCompletion:(void (^)(NSMutableDictionary *categoriesOfDishes, NSError * _Nullable error))fetchedDishes;
- (void) addDishToDict : (Dish *) dish toArray: (NSArray *) dishesOfType;
- (void) removeDishFromTable : (Dish *) delDish withCompletion:(void (^)(NSMutableDictionary *categoriesOfDishes, NSError * _Nullable error))removedDish;
- (void)setOrderedDicts;
@end

NS_ASSUME_NONNULL_END
