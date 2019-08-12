//
//  Item.m
//  PPHSample
//
//  Created by palavilli on 7/25/12.
//  Copyright (c) 2012 X.commerce Developer Tools.
//  Please see license.txt
//

#import "Item.h"

@implementation Item

@synthesize name = _name, description = _description, unitPrice = _unitPrice, taxName = _taxName, taxRate = _taxRate, date = _date, quantity = _quantity;

-(id)initWithName:(NSString *)name description:(NSString *)description taxRate:(NSString *)taxRate unitPrice:(NSString *)unitPrice taxName:(NSString *)taxName quantity:(NSString *)quantity date:(NSDate *)date {
    self = [super init];
    if(self) {
        _name = name;
        _description = description;
        _date = date;
        _quantity = quantity;
        _taxRate = taxRate;
        _taxName = taxName;
        _unitPrice = unitPrice;
        return self;
    }
    return nil;
}


- (NSDictionary *)toDictionary
{
    NSMutableDictionary *eachItem = [NSMutableDictionary dictionary];
    // Create an item
    if(_taxRate.length > 0 )
        [eachItem setObject:_taxRate forKey:@"taxRate"];
    [eachItem setObject:_name forKey:@"name"];
    if(_description.length > 0 )
        [eachItem setObject:_description forKey:@"description"];
    [eachItem setObject:_unitPrice forKey:@"unitPrice"];
    if(_taxName.length > 0 )
        [eachItem setObject:_taxName forKey:@"taxName"];
    [eachItem setObject:_quantity forKey:@"quantity"];
    return eachItem;
}

@end
