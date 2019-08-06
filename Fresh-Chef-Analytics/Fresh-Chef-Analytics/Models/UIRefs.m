//
//  UIRefs.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 8/6/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "UIRefs.h"

@implementation UIRefs

+ (instancetype)shared {
    
    static UIRefs *uiRefs = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uiRefs = [[self alloc] init];
    });
    uiRefs.funHexString = @"#ffdfea";
    uiRefs.elegantHexString = @"#ffffff";
    uiRefs.comfortableHexString = @"#cdcdcd";
    uiRefs.purpleAccent = @"#392382";
    uiRefs.blueHighlight = @"#2c91fd";
    return uiRefs;
}


-(void)setImage:(nullable UIImageView *)background isCustomerForm:(BOOL)isCustomerForm{
    NSString *category = [NSString new];
    if (!isCustomerForm){
        category = [NSString stringWithFormat:@"%@_waiter", [PFUser currentUser][@"theme"]];
    } else {
        category = [PFUser currentUser][@"theme"];
    }
    if (background){
        [background setImage:[UIImage imageNamed:category]];
        //background.contentMode = UIViewContentMode.scaleToFill;
    }
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
@end
