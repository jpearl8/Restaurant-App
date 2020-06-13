//
//  HistogramViewController.h
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/22/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChart.h"
#import "MenuManager.h"
#import "Helpful_funs.h"

NS_ASSUME_NONNULL_BEGIN

@interface HistogramViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> 
@property (weak, nonatomic) IBOutlet UITableView *categoriesTableView;
@property (weak, nonatomic) IBOutlet UIButton *chooseCategoryButton;

@end

NS_ASSUME_NONNULL_END
