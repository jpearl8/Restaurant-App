//
//  specialStepper.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/17/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dish.h"

NS_ASSUME_NONNULL_BEGIN

@interface specialStepper : UIStepper
@property (nonatomic, strong) Dish* dish;
@end

NS_ASSUME_NONNULL_END
