//
//  MenuManager.m
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/17/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "MenuManager.h"
#import "Dish.h"

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

- (void) fetchMenuItems : (PFUser *) restaurant {
    // construct PFQuery
    PFQuery *dishQuery;
    dishQuery = [Dish query];
    [dishQuery whereKey:@"restaurantID" equalTo:restaurant.objectId];
    dishQuery.limit = 20;
    
    // fetch data asynchronously
    [dishQuery findObjectsInBackgroundWithBlock:^(NSArray<Dish *> * _Nullable dishes, NSError * _Nullable error) {
        self.dishes = dishes;
        [self categorizeDishes];
    }];
}
- (void) categorizeDishes
{
    self.categoriesOfDishes = [[NSMutableDictionary alloc] init];
    NSArray * dishesOfType;

    for (Dish *dish in self.dishes)
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
}
@end
