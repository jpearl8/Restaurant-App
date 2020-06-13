//
//  CustomerTrack.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 8/6/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomerTrack : PFObject<PFSubclassing>
@property (nonatomic, strong) NSString *restaurantID;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSNumber *frequency;
+ (instancetype) shared;
- (CustomerTrack *) postNewCustomer:( NSString * _Nullable )email withCompletion: (PFBooleanResultBlock  _Nullable)completion;
- (void) changeCustomer : (NSString *) email withCompletion:(void (^)(int level, NSError * _Nullable error)) completion;
@end

NS_ASSUME_NONNULL_END
