//
//  EditOrderViewCell.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/31/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol EditOrderDelegate <NSObject>
-(void)deleteRowAtIndex:(int)index;
@end

@interface EditOrderViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *dishName;
@property (nonatomic, weak) id <EditOrderDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *amount;
@property (assign, nonatomic) int index;

@end

NS_ASSUME_NONNULL_END
