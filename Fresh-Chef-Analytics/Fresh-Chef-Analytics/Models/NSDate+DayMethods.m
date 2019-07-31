//
//  NSDate+DayMethods.m
//  Fresh-Chef-Analytics
//
//  Created by rgallardo on 7/30/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "NSDate+DayMethods.h"

@implementation NSDate (DayMethods)

- (NSString *)dayFromDate
{
    //return a string in year/month/day form so it can be sorted easily by date
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:self];

    NSString *dayString = [NSString stringWithFormat:@"%ld/%ld/%ld", (long)[comp1 year], (long)[comp1 month], (long)[comp1 day]];
    return dayString;
}

@end
