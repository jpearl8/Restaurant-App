//
//  MenuManager.m
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/17/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "MenuManager.h"
#import "Helpful_funs.h"

@implementation MenuManager
// singleton generates a single instance and initiates itself
+ (instancetype)shared {
    static MenuManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}
- (void)fetchMenuItems:(PFUser *)restaurant withCompletion:(void (^)(NSMutableDictionary * _Nonnull, NSError * _Nullable))fetchedDishes
{
    // construct PFQuery
    PFQuery *dishQuery;
    dishQuery = [Dish query];
    [dishQuery whereKey:@"restaurantID" equalTo:restaurant.objectId];
    dishQuery.limit = 20;
    
    // fetch data asynchronously
    [dishQuery findObjectsInBackgroundWithBlock:^(NSArray<Dish *> * _Nullable dishes, NSError * _Nullable error) {
        self.dishes = dishes;
        [self categorizeDishes];
        NSLog(@"Step 3");
        
        fetchedDishes(self.categoriesOfDishes, nil);
    }];
}

- (void)setOrderedDicts {
    // set ordered dictionaries
    self.dishesByFreq = [self orderDictionary:self.categoriesOfDishes byType:@"orderFrequency"];
    self.dishesByRating =[self orderDictionary:self.categoriesOfDishes byType:@"rating"];
    self.dishesByPrice = [self orderDictionary:self.categoriesOfDishes byType:@"price"];
}

- (NSMutableDictionary *)orderDictionary:(NSMutableDictionary *)dict byType:(NSString *)orderType
{
    NSMutableDictionary *orderedDict = [[NSMutableDictionary alloc] init];
    for(NSString *key in dict){
        orderedDict[key] = [[Helpful_funs shared] orderArray:dict[key] byType:orderType];
    }
    return orderedDict;
}

- (void)removeDishFromTable:(Dish *)delDish withCompletion:(void (^)(NSMutableDictionary * _Nonnull, NSError * _Nullable))removedDish
{
    PFQuery *dishQuery;
    dishQuery = [Dish query];
    [dishQuery whereKey:@"objectId" equalTo:delDish.objectId];
    [dishQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable dishes, NSError *  error) {
        for (Dish *dish in dishes)
        {
            [dish deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded)
                {
                    NSLog(@"Object removed");
                    [self fetchMenuItems:PFUser.currentUser withCompletion:^(NSMutableDictionary * _Nonnull categoriesOfDishes, NSError * _Nullable error) {
                        if (error==nil)
                        {
                            self.categoriesOfDishes = categoriesOfDishes;
                            NSLog(@"New menu successfuly fetched");
                            NSLog(@"Step 4");

                            removedDish(self.categoriesOfDishes, nil);

                        }
                    }];
                }
                else
                {
                    NSLog(@"%@", error.localizedDescription);
                    
                }
            }];
        }
    }];


}

- (void) categorizeDishes
{
    self.categoriesOfDishes = [[NSMutableDictionary alloc] init];
    NSArray * dishesOfType;
    
    for (Dish *dish in self.dishes)
    {
        [self addDishToDict:dish toArray:dishesOfType];
    }
    NSLog(@"Step 2");
}

- (void) addDishToDict : (Dish *) dish toArray: (NSArray *) dishesOfType
{
    if (self.categoriesOfDishes[dish.type]!=nil)
    {
        dishesOfType = self.categoriesOfDishes[dish.type];
        dishesOfType = [dishesOfType arrayByAddingObject:dish];
        
    }
    else
    {
        dishesOfType = [NSArray arrayWithObject:dish];
    }
    [self.categoriesOfDishes setObject:dishesOfType forKey:dish.type];
}

- (void)setTop3Bottom3Dict
{
    // make sorted array of every menu item
    if ([self.dishes count] != nil){
        NSLog(@"dishes %@", self.dishes);
        NSArray *dishesByFreqArray = [[Helpful_funs shared] orderArray:self.dishes byType:@"orderFrequency"];
        NSArray *dishesByRatingArray = [[Helpful_funs shared] orderArray:self.dishes byType:@"rating"];
        // take top 3 and bottom 3 based on reviews/frequency
        NSRange first3Range = NSMakeRange(0, 3);
        NSRange last3Range = NSMakeRange(([dishesByFreqArray count] - 3), 3);
        NSArray *top3Freq = [dishesByFreqArray subarrayWithRange:first3Range];
        NSArray *bottom3Freq = [dishesByFreqArray subarrayWithRange:last3Range];
        NSArray *top3Rating = [dishesByRatingArray subarrayWithRange:first3Range];
        NSArray *bottom3Rating = [dishesByRatingArray subarrayWithRange:last3Range];
        self.top3Bottom3Freq = [[NSMutableDictionary alloc] initWithObjects:@[top3Freq, bottom3Freq] forKeys:@[@"top3", @"bottom3"]];
        self.top3Bottom3Rating = [[NSMutableDictionary alloc] initWithObjects:@[top3Rating, bottom3Rating] forKeys:@[@"top3", @"bottom3"]];
    }
}


@end
