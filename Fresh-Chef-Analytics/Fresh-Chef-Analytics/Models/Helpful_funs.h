//
//  Helpful_funs.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/19/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "order.h"
#import "Parse/Parse.h"
#import "Dish.h"
#import "OpenOrder.h"

NS_ASSUME_NONNULL_BEGIN

@interface Helpful_funs : NSObject

+ (instancetype) shared;
- (UIColor *)colorFromHexString:(NSString *)hexString;
- (void) updateWithOrder: ( NSMutableArray <order*> *)orderList withNumberString:(NSString *)customerNumber;
-(void)defineSelect:(UIButton *)button withSelect:(BOOL)select;
- (NSArray *)orderArray:(NSArray *)array byType:(NSString *)orderType;
- (bool)scaleArrayByMax:(NSMutableArray *)array;
-(int) findAmountIndexwithDishArray:(NSArray <Dish *>*)dishes withDish:(Dish *)dish;
-(BOOL)arrayOfZeros:(NSArray<NSNumber *>*)array;
-(NSMutableArray<NSString *>*)fillCellArrays:(NSArray<OpenOrder *>*)openOrders;
-(int)findDishItem:(int)index withDishArray:(NSMutableArray <Dish *>*)dishesArray withOpenOrders:(NSArray<OpenOrder *>*)openOrders;
@end

NS_ASSUME_NONNULL_END
