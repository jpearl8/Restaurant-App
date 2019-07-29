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
@property (strong, nonatomic) NSMutableDictionary *top3Bottom3Freq;
@property (strong, nonatomic) NSMutableDictionary *top3Bottom3Rating;

@property (assign, nonatomic) int bottomThreshRating;
@property (assign, nonatomic) CGFloat upperThreshRating;
@property (assign, nonatomic) CGFloat bottomThreshFreq;
@property (assign, nonatomic) CGFloat upperThreshFreq;
@property (assign, nonatomic) CGFloat bottomThreshProfit;
@property (assign, nonatomic) CGFloat upperThreshProfit;

@property (strong, nonatomic) NSArray *rankedDishesByRating;
@property (strong, nonatomic) NSArray *rankedDishesByFreq;
@property (strong, nonatomic) NSArray *rankedDishesByProfit;

@property (strong, nonatomic) NSArray *sortByArray;
+ (instancetype) shared;
- (void) fetchMenuItems : (PFUser *) restaurant withCompletion:(void (^)(NSMutableDictionary *categoriesOfDishes, NSError * _Nullable error))fetchedDishes;
- (void) addDishToDict : (Dish *) dish toArray: (NSArray *) dishesOfType;
- (void) removeDishFromTable : (Dish *) delDish withCompletion:(void (^)(NSMutableDictionary *categoriesOfDishes, NSError * _Nullable error))removedDish;
- (void)setOrderedDicts;
- (void)setTop3Bottom3Dict;
//- (void)setDishRankings;
- (NSString *)getRankOfType:(NSString *)rankType ForDish:(Dish *)dish;

@end

NS_ASSUME_NONNULL_END
