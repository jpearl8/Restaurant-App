//
//  Waiter.h
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface Waiter : PFObject<PFSubclassing>
@property (nonatomic, strong) NSString *restaurantID;
@property (nonatomic, strong) PFUser *restaurant;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, weak) NSNumber *rating;
@property (nonatomic, strong) NSNumber *tableTops;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSNumber *numOfCustomers;
@property (nonatomic, strong) NSNumber *yearsWorked;
@property (nonatomic, strong) NSNumber *tipsMade;
@property (nonatomic, strong) NSArray *comments;

@end

NS_ASSUME_NONNULL_END
