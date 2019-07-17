//
//  Menu.m
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/17/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "Menu.h"
#import "Dish.h"

@implementation Menu
- (void) fetchMenuItems : (PFUser *) restaurant {
    // construct PFQuery
    PFQuery *dishQuery;
    dishQuery = [Dish query];
    [dishQuery whereKey:@"restaurantID" equalTo:restaurant.objectId];
    dishQuery.limit = 20;
    
    // fetch data asynchronously
    [dishQuery findObjectsInBackgroundWithBlock:^(NSArray<Dish *> * _Nullable dishes, NSError * _Nullable error) {
        if (dishes.count > 0) {
            self.dishes = dishes;
        }
        else {
            NSLog(@"no posts to show!");
        }
    }];
}
@end
