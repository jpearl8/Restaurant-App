//
//  NSDate+DayMethods.m
//  Fresh-Chef-Analytics
//
//  Created by rgallardo on 7/30/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "NSDate+DayMethods.h"

@implementation NSDate (DayMethods)

- (NSString *)dateFromNSDate
{
    //return a string in year/month/day form so it can be sorted easily by date
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:self];
    NSString *monthString = [NSString stringWithFormat:@"%ld", [comp1 month]];
    if ([monthString length] == 1) {
        monthString = [@"0" stringByAppendingString:monthString];
    }
    NSString *dayString = [NSString stringWithFormat:@"%ld", [comp1 day]];
    if ([dayString length] == 1) {
        dayString = [@"0" stringByAppendingString:dayString];
    }
    
    NSString *dateString = [NSString stringWithFormat:@"%ld-%@-%@", (long)[comp1 year], monthString, dayString];
    return dateString;
}

@end
