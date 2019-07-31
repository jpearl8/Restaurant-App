//
//  BarChartViewController.h
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/29/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChart.h"
#import "MenuManager.h"
#import "Helpful_funs.h"
NS_ASSUME_NONNULL_BEGIN

@interface BarChartViewController : UIViewController <PNChartDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@end

NS_ASSUME_NONNULL_END
