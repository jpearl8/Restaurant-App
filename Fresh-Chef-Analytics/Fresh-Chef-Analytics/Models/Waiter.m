//
//  Waiter.m
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "Waiter.h"

@implementation Waiter
@dynamic restaurantID;
@dynamic restaurant;
@dynamic name;
@dynamic rating;
@dynamic tableTops;
@dynamic image;
@dynamic numOfCustomers;
@dynamic yearsWorked;
@dynamic tipsMade;
@dynamic comments;

+ (nonnull NSString *)parseClassName {
    return @"Waiter";
}
+ (void) addNewWaiter: ( NSString * _Nullable )name withYears: ( NSNumber * _Nullable )years withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    Waiter *newWaiter = [Waiter new];
    
    // Uncomment when sign up/log in works //
    //newWaiter.restaurant = [PFUser currentUser];
    //newWaiter.restaurantID = newWaiter.restaurant.objectId;
    
    newWaiter.name = name;
    newWaiter.yearsWorked = years;
    newWaiter.rating = nil;
    newWaiter.tableTops = @(0);
    newWaiter.numOfCustomers = @(0);
    newWaiter.tipsMade = @(0);
    newWaiter.comments = [[NSArray alloc] init];
    [newWaiter saveInBackgroundWithBlock:completion];
}
+ (void) addNewWaiter: ( NSString * _Nullable )name withYears: ( NSNumber * _Nullable )years withImage: ( UIImage * _Nullable )image withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    Waiter *newWaiter = [Waiter new];
    
    // Uncomment when sign up/log in works //
    //newWaiter.restaurant = [PFUser currentUser];
    //newWaiter.restaurantID = newWaiter.restaurant.objectId;
    newWaiter.image = [self getPFFileFromImage:image];
    newWaiter.name = name;
    newWaiter.yearsWorked = years;
    newWaiter.rating = nil;
    newWaiter.tableTops = @(0);
    newWaiter.numOfCustomers = @(0);
    newWaiter.tipsMade = @(0);
    newWaiter.comments = [[NSArray alloc] init];
    [newWaiter saveInBackgroundWithBlock:completion];
}
+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithData:imageData];
    
}
@end
