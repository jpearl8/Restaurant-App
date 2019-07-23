//
//  ScatterViewController.h
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/22/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChart.h"
#import "MenuManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScatterViewController : UIViewController<PNChartDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *chooseDishButton;
@property (weak, nonatomic) IBOutlet UITableView *dishesTableView;
@end

NS_ASSUME_NONNULL_END
