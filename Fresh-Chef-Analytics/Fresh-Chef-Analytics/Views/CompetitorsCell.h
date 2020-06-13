//
//  CompetitorsCell.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/23/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Link.h"
NS_ASSUME_NONNULL_BEGIN

@interface CompetitorsCell : UITableViewCell
//@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *competitorName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet Link *yelpLink;

@property (weak, nonatomic) IBOutlet UIImageView *competitorImage;
@property (strong, nonatomic) IBOutlet UIImageView *yelpRating;
@property (strong, nonatomic) IBOutlet UILabel *reviewCount;


@end

NS_ASSUME_NONNULL_END
