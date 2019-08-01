//
//  FCADate.h
//  Fresh-Chef-Analytics
//
//  Created by rgallardo on 7/30/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCADate : NSObject

@property (assign, nonatomic) NSInteger *year;
@property (assign, nonatomic) NSInteger *month;
@property (assign, nonatomic) NSInteger *day;

typedef NS_ENUM(NSInteger, Day)
{
    Mon = 1,
    Tue,
    Wed,
    Thu,
    Fri,
    Sat,
    Sun
};

@end

NS_ASSUME_NONNULL_END
