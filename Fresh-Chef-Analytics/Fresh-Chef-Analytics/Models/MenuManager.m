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
        
        [self setProfitForDishes]; // set profit for each dish locally
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

- (void)setProfitForDishes
{
    for (Dish *dish in self.dishes) {
        dish.profit = [NSNumber numberWithInt: ([dish.orderFrequency intValue] * [dish.price intValue])];
        NSLog(@"Dish profit: %@", dish.profit);
    }
    
    
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
    if (self.dishes.count >= 3)
    {
        Dish *checkDish = [self.dishes objectAtIndex:0];
        if (![checkDish.name isEqualToString:@"test"]){
            // make sorted array of every menu item
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
            [self setDishRankings];
            for (Dish *dish in top3Freq) {
                [self setBasicSuggestions:dish];
            }
            for (Dish *dish in bottom3Freq) {
                [self setBasicSuggestions:dish];
            }
            for (Dish *dish in top3Rating) {
                [self setBasicSuggestions:dish];
            }
            for (Dish *dish in bottom3Rating) {
                [self setBasicSuggestions:dish];
            }
        }
    }
}

// get overal ranked arrays of data and set threshold indices
//- (void)setThresholdIndices
//{
////    self.thresholdsRating = @[@0.33f, @0.66f]; // will use later if user can change values
//    float bottomThreshRating = 0.33f;
//    float upperThresh = 0.66f;
//
//    //RATING
//    // get length of menu and find indices closest to bottom threshold percentile and upper
//    NSUInteger menuLength = [self.dishes count];
//    NSUInteger lowerIndex = lroundf(bottomThresh * menuLength);
//    NSUInteger upperIndex = lroundf(upperThresh * menuLength);
//    //rank all dishes into an array
//    NSArray *rankedDishesByRating = [[Helpful_funs shared] orderArray:self.dishes byType:@"rating"];
//    for (int i = 0; i < [rankedDishesByRating count]; i++) {
//        Dish *dish = rankedDishesByRating[i];
//        if (i <= lowerIndex) {
//            dish.ratingCategory = @"low";
//        } else if (i > lowerIndex && i < upperIndex) {
//            dish.ratingCategory = @"medium";
//        } else {
//            dish.ratingCategory = @"high";
//        }
//    }
//    NSLog(@"dishes ranked by rating: %@", rankedDishesByRating);
//}

- (void)setDishRankings
{
    //rank all dishes into an array
    float bottomThreshRating = 0.33f;
    float upperThreshRating = 0.66f;
    float bottomThreshFreq = 0.33f;
    float upperThreshFreq = 0.66f;
    float bottomThreshProfit = 0.33f;
    float upperThreshProfit = 0.66f;
    // get length of menu and find indices closest to lower and upper threshold percentile
    NSUInteger menuLength = [self.dishes count];
    NSUInteger lowerIndexRating = lroundf(bottomThreshRating * menuLength);
    NSUInteger upperIndexRating = lroundf(upperThreshRating * menuLength);
    NSUInteger lowerIndexFreq = lroundf(bottomThreshFreq * menuLength);
    NSUInteger upperIndexFreq = lroundf(upperThreshFreq * menuLength);
    NSUInteger lowerIndexProfit = lroundf(bottomThreshProfit * menuLength);
    NSUInteger upperIndexProfit = lroundf(upperThreshProfit * menuLength);
    // rank all dishes into an array
    NSArray *rankedDishesByRating = [[Helpful_funs shared] orderArray:self.dishes byType:@"rating"];
    NSArray *rankedDishesByFreq = [[Helpful_funs shared] orderArray:self.dishes byType:@"orderFrequency"];
    NSArray *rankedDishesByProfit = [[Helpful_funs shared] orderArray:self.dishes byType:@"profit"];
    for (int i = 0; i < menuLength; i++) {
        Dish *dish = rankedDishesByRating[i];
        // Check Rating
        if (i <= lowerIndexRating) {
            dish.ratingCategory = @"high"; // if dish is early in array then it has high rating
        } else if (i > lowerIndexRating && i < upperIndexRating) {
            dish.ratingCategory = @"medium";
        } else {
            dish.ratingCategory = @"low"; // if dish is later in array then it has a low rating
        }
    }
    // Check Frequency
    for (int i = 0; i < menuLength; i++) {
        Dish *dish = rankedDishesByFreq[i];
        if (i <= lowerIndexFreq) {
            dish.freqCategory = @"high"; // if dish is early in array then it has high freq
        } else if (i > lowerIndexFreq && i < upperIndexFreq) {
            dish.freqCategory = @"medium";
        } else {
            dish.freqCategory = @"low"; // if dish is later in array then it has a low freq
        }
    }
    // Check Profit
    for (int i = 0; i < menuLength; i++) {
        Dish *dish = rankedDishesByProfit[i];
        if (i <= lowerIndexProfit) {
            dish.profitCategory = @"high"; // if dish is early in array then it has high profit
        } else if (i > lowerIndexProfit && i < upperIndexProfit) {
            dish.profitCategory = @"medium";
        } else {
            dish.profitCategory = @"low"; // if dish is later in array then it has a low profit
        }
    }
}

- (void) findDish : (NSString *) objectId withCompletion:(void (^)(NSArray * dishes, NSError * _Nullable error)) completion
{
    PFQuery *dishQuery;
    dishQuery = [Dish query];
    [dishQuery whereKey:@"objectId" equalTo:objectId];
    [dishQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable dishes, NSError * _Nullable error) {
        NSLog(@"finished querying for waiters");
        if (!error)
        {
            NSLog(@"found waiters %@", dishes);
            completion(dishes, nil);
        }
        else
        {
            NSLog(@"Error: %@", error.localizedDescription);
            completion(nil, error);
        }
    }];
    
}
- (void)setBasicSuggestions:(Dish *)dish
{
    
    if ([dish.ratingCategory isEqualToString:@"high"]) {
        //compare freq and profit and make suggestion on that
        // only give suggestion if freq or profit is low
        dish.suggestions = @"This dish has a good rating.";
    } else if ([dish.ratingCategory isEqualToString:@"medium"]) {
        // compare freq and profit
        dish.suggestions = @"This dish has a medium rating.";
    } //else if ([dish.ratingCategory isEqualToString:@"low"]) {
    else {
        dish.suggestions = @"This dish has a low rating: consider improving the way it's prepared.";

    }
    //Sugestions for low freq
    if ([dish.freqCategory isEqualToString:@"high"]) {
        //consider moving position on menu
        //consider improving description
        dish.suggestions = [dish.suggestions stringByAppendingString:@" This dish has a high frequency."];
    } else if ([dish.freqCategory isEqualToString:@"medium"]) {
        dish.suggestions = [dish.suggestions stringByAppendingString:@"This dish has a medium frequency."];
    } else {
        dish.suggestions = [dish.suggestions stringByAppendingString:@" This dish has a low frequency: Consider changing its position on the menu and/or improving its description."];
    }
}



//- (NSString *)setSuggestionForDish:(Dish *)dish
//{
//    NSString *suggestion;
//    //If HIGH rating
//    if ([dish.ratingCategory isEqualToString:@"high"]) {
//        //compare freq and profit and make suggestion on that
//        // only give suggestion if freq or profit is low
//        if([dish.freqCategory isEqualToString:@"low"]) {
//            if([dish.profitCategory isEqualToString:@"low"]) {
//                // should improve description or place differently in menu
//            } else {
//                //dish isn't ordered often but its making enough money
//            }
//        } else if ([dish.freqCategory isEqualToString:@"high"]) {
//            if([dish.profitCategory isEqualToString:@"low"]) {
//                //could consider raising price
//            } else {
//                //dish is doing very good
//            }
//        } else { // medium frequency
//            if ([dish.profitCategory isEqualToString:@"low"]) {
//                // could consider raising price
//            } else {
//                // dish is doing pretty well
//            }
//        }
//    } else if ([dish.ratingCategory isEqualToString:@"medium"]) {
//        // compare freq and profit
//        if([dish.freqCategory isEqualToString:@"low"]) {
//            if([dish.profitCategory isEqualToString:@"low"]) {
//                // should improve description or place differently in menu
//            } else {
//                //dish isn't ordered often but its making enough money
//            }
//        } else if ([dish.freqCategory isEqualToString:@"high"]) {
//            if([dish.profitCategory isEqualToString:@"low"]) {
//                //could consider raising price
//            } else {
//                //dish is doing very good
//            }
//        } else { // medium frequency
//            if ([dish.profitCategory isEqualToString:@"low"]) {
//                // could consider raising price
//            } else {
//                // dish is doing pretty well
//            }
//        }
//    } else if ([dish.ratingCategory isEqualToString:@"low"]) {
//        if([dish.freqCategory isEqualToString:@"low"]){
//
//        }
//
//    }
//    return suggestion;
//}

@end
