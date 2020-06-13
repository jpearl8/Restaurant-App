//
//  Helpful_funs.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/19/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "Helpful_funs.h"
#import "MenuManager.h"
#import "WaiterManager.h"
@import CoreLocation;
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation Helpful_funs

+ (instancetype)shared {

    static Helpful_funs *helpful_funs = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helpful_funs = [[self alloc] init];
    });

    return helpful_funs;
}
// Assumes input like "#00FF00" (#RRGGBB).
- (UIColor *)colorFromHexString:(NSString *)hexString {

    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


-(void)defineSelect:(UIButton *)button withSelect:(BOOL)select {
    if (select){
        button.selected = "YES";
        button.backgroundColor = [self colorFromHexString:@"#4EF84E"];
    } else {
        button.selected = "NO";
        button.backgroundColor = [UIColor clearColor];
    }
}
- (NSArray *)orderArray:(NSArray *)array byType:(NSString *)orderType
{
    NSArray *sortedArray;
    if([orderType isEqualToString:@"alphabet"]){
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        sortedArray=[array sortedArrayUsingDescriptors:@[sort]];

    }
    else {
        sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSNumber *first = a[orderType];
            NSNumber *second = b[orderType];
            
            if ([orderType isEqualToString:@"rating"]) {
                // calculate actual rating based on frequency
                float x = [a[@"rating"] floatValue] / [a[@"orderFrequency"] floatValue];
                float y = [b[@"rating"] floatValue] / [b[@"orderFrequency"] floatValue];
                first = [NSNumber numberWithFloat:x];
                second = [NSNumber numberWithFloat:y];
            }
            if([orderType isEqualToString:@"waiterRating"]) {
                // calculate actual rating based on frequency
                float x = [a[@"rating"] floatValue] / [a[@"tableTops"] floatValue];
                float y = [b[@"rating"] floatValue] / [b[@"tableTops"] floatValue];
                first = [NSNumber numberWithFloat:x];
                second = [NSNumber numberWithFloat:y];
            }
            if ([orderType isEqualToString:@"tipsByCustomers"])
            {
                float x = [[[WaiterManager shared] averageTipByCustomer:(Waiter*)a] floatValue];
                float y = [[[WaiterManager shared] averageTipByCustomer:(Waiter*)b] floatValue];
                first = [NSNumber numberWithFloat:x];
                second = [NSNumber numberWithFloat:y];
            }
            if ([orderType isEqualToString:@"tipsByTable"])
            {
                float x = [[[WaiterManager shared] averageTipsByTable:(Waiter*)a] floatValue];
                float y = [[[WaiterManager shared] averageTipsByTable:(Waiter*)b] floatValue];
                first = [NSNumber numberWithFloat:x];
                second = [NSNumber numberWithFloat:y];
            }
            
            //check for nil values
            if(first != nil && second != nil){
                return [second compare:first];
            } else if(first == nil){
                return 1;
            } else {
                return -1; // if second is nil or if both are nil assume second is smaller
            }
        }];
    }
    return sortedArray;
}

- (bool) scaleArrayByMax:(NSMutableArray *)array
{
   NSNumber * max = [array valueForKeyPath:@"@max.floatValue"];
    for (int i = 0; i < array.count; i++)
    {
        array[i] = [NSNumber numberWithFloat:[array[i] floatValue] / [max floatValue]];
    }
    if ([max floatValue] < 1)
    {
        return true;
    }
    else
    {
        return false;
    }
}
-(int) findAmountIndexwithDishArray:(NSArray <Dish *>*)dishes withDish:(Dish *)dish{
    for (int i = 0; i < dishes.count; i++){
        if ([dishes[i].name isEqualToString:dish.name]){
            return i;
        }
    }
    return -1;
}
-(BOOL)arrayOfZeros:(NSArray<NSNumber *>*)array{
    int i = 0;
    while (i < array.count){
        if ([array[i] isEqual:[NSNumber numberWithInt:0]]){
            i++;
        } else {
            return NO;
        }
    }
    return YES;
}

-(int)findDishItem:(int)index withDishArray:(NSMutableArray <Dish *>*)dishesArray withOpenOrders:(NSArray<OpenOrder *>*)openOrders{
    for (int i = 0; i < dishesArray.count; i++){
        if (openOrders[index]){
            if ([((Dish *)dishesArray[i]).objectId isEqualToString:((Dish*)openOrders[index].dish).objectId]){
                return i;
            }
        }
    }
    return -1;
}

@end
