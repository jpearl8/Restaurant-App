//
//  CustomerTrack.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 8/6/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "CustomerTrack.h"

@implementation CustomerTrack

@dynamic restaurantID;
@dynamic email;
@dynamic frequency;

+ (nonnull NSString *)parseClassName {
    return @"CustomerTrack";
}

+ (instancetype)shared {
    static CustomerTrack *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

- (CustomerTrack *) postNewCustomer:( NSString * _Nullable )email withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    CustomerTrack *newCustomer = [CustomerTrack new];
    newCustomer.restaurantID = [PFUser currentUser].objectId;
    newCustomer.email = email;
    newCustomer.frequency = @(1);
    [newCustomer saveInBackgroundWithBlock:completion];
    return newCustomer;
}

//searches for customer, changes frequency, updates or creates
- (void) changeCustomer : (NSString *) email withCompletion:(void (^)(int level, NSError * _Nullable error)) completion
{
    __block int level = 0;
    PFQuery *customerQuery;
    customerQuery = [CustomerTrack query];
    [customerQuery whereKey:@"email" equalTo:email];
    [customerQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable customers, NSError * _Nullable error) {
        NSLog(@"finished querying for waiters");
        if (!error)
        {
            if(customers && customers.count != 0){
                float updatedFreq = [((CustomerTrack *)customers[0]).frequency floatValue] + 1;
                ((CustomerTrack *)customers[0]).frequency = [NSNumber numberWithFloat:updatedFreq];
                [((CustomerTrack *)customers[0]) saveInBackground];
                if (updatedFreq  >= 15){
                    level = 3;
                }
                else if (updatedFreq >= 10){
                    level = 2;
                }
                else if (updatedFreq  >= 5){
                    level = 1;
                }
                completion(level, nil);
            }
            else {
                [self postNewCustomer:email withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                    if (!error)
                    {
                        completion(level, nil);
                    }
                    else{
                        NSLog(@"%@", error.localizedDescription);
                        completion(-1, error);
                    }
                }];
                
                
            }
        }
        else
        {
            NSLog(@"Error: %@", error.localizedDescription);
            completion(-1, error);
            
        }
    }];
    
}


@end
