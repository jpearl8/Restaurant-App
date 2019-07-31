//
//  Helpful_funs.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/19/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "Helpful_funs.h"
#import "MenuManager.h"

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

- (void) updateWithOrder: ( NSMutableArray <order*> *)orderList withNumberString:(NSString *)customerNumber{
    for (int i = 0; i < orderList.count; i++){
        float totalRating = [orderList[i].dish.rating floatValue];
        if (!totalRating){
            totalRating = 0;
        }
        orderList[i].dish.rating = [NSNumber numberWithFloat: ((orderList[i].customerRating * orderList[i].amount)  + totalRating)];
        if (!([orderList[i].customerComments isEqualToString:@""])){
            orderList[i].dish.comments=[orderList[i].dish.comments arrayByAddingObject:orderList[i].customerComments];
        }
        float totalFrequency = [orderList[i].dish.orderFrequency floatValue];
        orderList[i].dish.orderFrequency = [NSNumber numberWithFloat: (orderList[i].amount + totalFrequency)];
        [orderList[i].dish saveInBackground];
    }
    float totalRating = [orderList[0].waiter.rating floatValue];
    if (!totalRating){
        totalRating = 0;
    }
    orderList[0].waiter.rating = [NSNumber numberWithFloat: (orderList[0].waiterRating + totalRating)];

    if (!([orderList[0].waiterReview isEqualToString:@""])){
        orderList[0].waiter.comments=[orderList[0].waiter.comments arrayByAddingObject:orderList[0].waiterReview];
    }
    float numOfCustomers = [orderList[0].waiter.numOfCustomers floatValue];
    orderList[0].waiter.numOfCustomers = [NSNumber numberWithFloat: ([customerNumber floatValue] + numOfCustomers)];
    orderList[0].waiter.tableTops = [NSNumber numberWithFloat: ([orderList[0].waiter.tableTops floatValue] + 1)];
    [orderList[0].waiter saveInBackground];
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
        //check for nil values
        if(first != nil && second != nil){
            return [second compare:first];
        } else if(first == nil){
            return 1;
        } else {
            return -1; // if second is nil or if both are nil assume second is smaller
        }
    }];
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
        if (array[i] == [NSNumber numberWithInt:0]){
            i++;
        } else {
            return NO;
        }
    }
    return YES;
}




@end
