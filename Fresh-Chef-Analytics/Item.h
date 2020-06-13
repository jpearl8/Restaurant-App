//
//  Item.h
//  PPHSample
//
//  Created by palavilli on 7/25/12.
//  Copyright (c) 2012 X.commerce Developer Tools.
//  Please see license.txt
//

#import <Foundation/Foundation.h>

/*
 * Item object to store item specific information
 */
@interface Item : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *taxRate;
@property (nonatomic, copy) NSString *unitPrice;
@property (nonatomic, copy) NSString *taxName;
@property (nonatomic, copy) NSString *quantity;
@property (nonatomic, copy) NSDate *date;


-(id)initWithName:(NSString *)name description:(NSString *)description taxRate:(NSString *)taxRate unitPrice:(NSString *)unitPrice taxName:(NSString *)taxName quantity:(NSString *)quantity date:(NSDate *)date;
- (NSDictionary *)toDictionary;

@end
