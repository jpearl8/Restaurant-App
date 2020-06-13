//
//  EditWaitViewController.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditWaiterCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditWaitViewController : UIViewController<EditWaiterCellDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *roster;

@end

NS_ASSUME_NONNULL_END
