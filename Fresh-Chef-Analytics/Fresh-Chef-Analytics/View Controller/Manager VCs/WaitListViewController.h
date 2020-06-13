//
//  WaitListViewController.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKDropdownMenu.h"
#import "WaiterManager.h"
#import "WaiterListTableViewCell.h"
#import "WaitDetailsViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WaitListViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, MKDropdownMenuDataSource, MKDropdownMenuDelegate>

@property (assign, nonatomic) NSInteger selectedIndex;

@end

NS_ASSUME_NONNULL_END
