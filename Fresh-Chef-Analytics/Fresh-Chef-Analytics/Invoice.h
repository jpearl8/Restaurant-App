//
//  Invoice.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 8/12/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Invoice : NSObject
@property (nonatomic, copy) NSString *paymentTerms;
@property (nonatomic, copy) NSString *discountPercentage;
@property (nonatomic, copy) NSString *currencyCode;
@property (nonatomic, copy) NSString *uniqueID;
@property (nonatomic, copy) NSString *merchantEmail;
@property (nonatomic, copy) NSString *payerEmail; // payerEmail is optional, PayPal Here app will fill the value
@property (nonatomic, copy) NSMutableArray *itemList;

- (NSInteger) countOfList;
- (Invoice *)objectInListAtIndex:(NSInteger)theIndex;
- (void)addItemWithName:(NSString *)itemName description:(NSString *)description taxRate:(NSString *)taxRate unitPrice:(NSString *)unitPrice taxName:(NSString *)taxName quantity:(NSString *)quantity;
- (NSDictionary *)toDictionary;
@end

NS_ASSUME_NONNULL_END
