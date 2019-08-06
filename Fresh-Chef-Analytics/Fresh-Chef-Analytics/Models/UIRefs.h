//
//  UIRefs.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 8/6/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIRefs : NSObject
+ (instancetype) shared;
-(void)setImage:(nullable UIImageView *)background isCustomerForm:(BOOL)isCustomerForm;
@property (strong, nonatomic) NSString *funHexString;
@property (strong, nonatomic) NSString *comfortableHexString;
@property (strong, nonatomic) NSString *elegantHexString;
@property (strong, nonatomic) NSString *purpleAccent;
@property (strong, nonatomic) NSString *blueHighlight;
- (UIColor *)colorFromHexString:(NSString *)hexString;
@end

NS_ASSUME_NONNULL_END
