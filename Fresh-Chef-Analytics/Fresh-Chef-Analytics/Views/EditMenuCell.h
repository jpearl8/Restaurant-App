//
//  EditMenuTableViewCell.h
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/17/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditMenuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *dishView;
@property (weak, nonatomic) IBOutlet UILabel *dishName;
@property (weak, nonatomic) IBOutlet UILabel *dishType;
@property (weak, nonatomic) IBOutlet UILabel *dishPrice;
@property (weak, nonatomic) IBOutlet UILabel *dishRating;
@property (weak, nonatomic) IBOutlet UILabel *dishFrequency;
@property (weak, nonatomic) IBOutlet UILabel *dishDescription;

@end

NS_ASSUME_NONNULL_END
