//
//  MenuListViewController.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKDropdownMenu.h"
NS_ASSUME_NONNULL_BEGIN

@interface MenuListViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, MKDropdownMenuDelegate, MKDropdownMenuDataSource>

@end

NS_ASSUME_NONNULL_END
