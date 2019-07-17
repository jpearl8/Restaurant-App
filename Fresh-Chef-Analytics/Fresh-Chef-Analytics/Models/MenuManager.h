//
//  MenuManager.h
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/17/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface MenuManager : NSObject
@property (strong, nonatomic) NSArray * dishes;
+ (instancetype) shared;
- (void) fetchMenuItems : (PFUser *) restaurant;

@end

NS_ASSUME_NONNULL_END
