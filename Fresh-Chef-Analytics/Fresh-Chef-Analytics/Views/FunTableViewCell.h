//
//  FunTableViewCell.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/17/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dish.h"

NS_ASSUME_NONNULL_BEGIN

@interface FunTableViewCell : UITableViewCell
@property (strong, nonatomic) Dish *dish;
@property (weak, nonatomic) IBOutlet UILabel *dishName;
@property (weak, nonatomic) IBOutlet UILabel *dishType;
@property (weak, nonatomic) IBOutlet UILabel *dishDescription;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *amount;

@end

NS_ASSUME_NONNULL_END
