//
//  Top3Bottom3TableViewCell.h
//  Fresh-Chef-Analytics
//
//  Created by rgallardo on 7/22/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dish.h"

NS_ASSUME_NONNULL_BEGIN

@interface Top3Bottom3TableViewCell : UITableViewCell
@property (nonatomic, strong) Dish *dish;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UILabel *frequency;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (weak, nonatomic) IBOutlet UIView *dishInfoView;
@property (weak, nonatomic) IBOutlet UIView *dishSuggestionsView;
@property (assign, nonatomic) BOOL isExpanded;
@end

NS_ASSUME_NONNULL_END
