//
//  Invoice.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 8/12/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "Invoice.h"
#import "Item.h"

@implementation Invoice

@synthesize itemList = _itemList, paymentTerms = _paymentTerms, discountPercentage = _discountPercentage, currencyCode = _currencyCode, uniqueID = _uniqueID, merchantEmail = _merchantEmail, payerEmail = _payerEmail;


-(void)initializeDefaultDataList {
    NSMutableArray *itemeList = [[NSMutableArray alloc] init];
    self.itemList = itemeList;
    [self addItemWithName:@"T-Shirt" description:@"I Love APIs shirt" taxRate:@"8.50" unitPrice:@"9.99" taxName:@"Sales Tax" quantity:@"1"];
}
- (void)setItemList:(NSMutableArray *)newList {
    if(_itemList != newList) {
        _itemList = [newList mutableCopy];
    }
}
-(id)init {
    if(self = [super init]) {
        [self initializeDefaultDataList];
        return self;
    }
    return nil;
}

- (NSInteger)countOfList {
    return [self.itemList count];
}

-(Item *)objectInListAtIndex:(NSInteger)theIndex {
    return [self.itemList objectAtIndex:theIndex];
}

- (void)addItemWithName:(NSString *)itemName description:(NSString *)description taxRate:(NSString *)taxRate unitPrice:(NSString *)unitPrice taxName:(NSString *)taxName quantity:(NSString *)quantity {
    Item *item;
    NSDate *today = [NSDate date];
    item = [[Item alloc] initWithName:itemName description:description taxRate:taxRate unitPrice:unitPrice taxName:taxName quantity:quantity date:today];
    [self.itemList addObject:item];
}


- (NSDictionary *)toDictionary
{
    NSMutableDictionary *invoice = [NSMutableDictionary dictionary];
    NSMutableDictionary *itemListDictionary = [NSMutableDictionary dictionary];
    NSMutableArray *itemListArray = [NSMutableArray arrayWithCapacity:[_itemList count]];
    NSEnumerator *e = [self.itemList objectEnumerator];
    Item *item; int count = 0;
    while (item = [e nextObject]){
        [itemListArray addObject:item.toDictionary];
        count++;
    }
    [itemListDictionary setObject:itemListArray forKey:@"item"];
    if(itemListDictionary.count > 0)
        [invoice setObject:itemListDictionary forKey:@"itemList"];
    if(_payerEmail.length > 0)
        [invoice setObject:_payerEmail forKey:@"payerEmail"];
    [invoice setObject:_paymentTerms forKey:@"paymentTerms"];
    if(_discountPercentage.length > 0 )
        [invoice setObject:_discountPercentage forKey:@"discountPercent"];
    if(_merchantEmail.length > 0)
        [invoice setObject:_merchantEmail forKey:@"merchantEmail"];
    [invoice setObject:_currencyCode forKey:@"currencyCode"];
    if(_uniqueID.length > 0 )
        [invoice setObject:_uniqueID forKey:@"number"];
    return invoice;
}
@end


