//
//  ReceiptTableViewCell.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/19/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface ReceiptTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *calculatedPrice;
@property (weak, nonatomic) IBOutlet UILabel *dishAmount;
@property (weak, nonatomic) IBOutlet UILabel *dishName;
@end

NS_ASSUME_NONNULL_END
