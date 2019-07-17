//
//  DishDetailsViewController.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dish.h"

NS_ASSUME_NONNULL_BEGIN

@interface DishDetailsViewController : UIViewController
@property (strong, nonatomic) Dish *dish;
@end

NS_ASSUME_NONNULL_END
