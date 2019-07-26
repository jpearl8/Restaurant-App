//
//  YelpAPIManager.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/22/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YelpAPIManager : NSObject
+ (instancetype) shared;
-(void)fetchCompetitors;
@property (strong, nonatomic) NSMutableArray* userParameters;
@property (strong, nonatomic) NSMutableArray* competitorArray; // item one location array, item two category array, item three price array
-(void)locationTopRatings:(NSString*)locationRes withCategory:(nullable NSString *)categoryRes withPrice:(nullable NSString *)priceRes withIndex:(NSUInteger)index;
@end

NS_ASSUME_NONNULL_END
