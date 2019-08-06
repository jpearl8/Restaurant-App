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

@property (assign, nonatomic) float bottomThreshRating;
@property (assign, nonatomic) float upperThreshRating;
@property (assign, nonatomic) float bottomThreshFreq;
@property (assign, nonatomic) float upperThreshFreq;
@property (assign, nonatomic) float bottomThreshProfit;
@property (assign, nonatomic) float upperThreshProfit;

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
- (void) findDish : (NSString *) objectId withCompletion:(void (^)(NSArray * dishes, NSError * _Nullable error)) completion;
- (NSNumber *) averageRating : (Dish *) dish;
- (NSNumber *) averageRatingWithoutFloor : (Dish *) dish;
@end

NS_ASSUME_NONNULL_END
