//
//  BarChartViewController.m
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/29/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "BarChartViewController.h"
#import "MenuManager.h"

@interface BarChartViewController ()
@property (weak, nonatomic) IBOutlet UIView *dataView;
@property (weak, nonatomic) IBOutlet UIPickerView *categoryPicker;
@property (strong, nonatomic) NSMutableArray *pickerData;
@end

@implementation BarChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pickerData = [[NSMutableArray alloc] init];
    self.pickerData = [NSMutableArray arrayWithArray:[[[MenuManager shared] categoriesOfDishes] allKeys]];
    [self.pickerData insertObject:@"All categories" atIndex:0];
//    self.categoryPicker.delegate = self;
//    self.categoryPicker.dataSource = self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
