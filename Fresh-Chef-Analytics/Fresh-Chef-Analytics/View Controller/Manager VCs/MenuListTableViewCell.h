//
//  MenuListTableViewCell.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/17/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dish.h"
NS_ASSUME_NONNULL_BEGIN

@interface MenuListTableViewCell : UITableViewCell
@property (nonatomic, strong) Dish *dish;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UILabel *orderFrequency;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (weak, nonatomic) NSString *ratingCategory;
@property (weak, nonatomic) NSString *freqCategory;
@property (weak, nonatomic) NSString *profitCategory;
@end

NS_ASSUME_NONNULL_END
