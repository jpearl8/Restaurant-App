//
//  NSDate+DayMethods.h
//  Fresh-Chef-Analytics
//
//  Created by rgallardo on 7/30/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (DayMethods)
- (NSString *)dateFromNSDate;
- (NSDate *)dateFromString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
