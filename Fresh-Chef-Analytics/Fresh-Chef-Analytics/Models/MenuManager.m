//
//  MenuManager.m
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/17/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "MenuManager.h"

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
@end
