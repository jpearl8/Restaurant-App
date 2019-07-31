//
//  BarChartViewController.m
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/29/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "BarChartViewController.h"

@interface BarChartViewController ()
@property (weak, nonatomic) IBOutlet UIView *dataView;
@property (weak, nonatomic) IBOutlet UIPickerView *categoryPicker;
@property (strong, nonatomic) NSMutableDictionary *categoriesOfDishes;
@property (strong, nonatomic) NSMutableArray *pickerData;
@property (strong, nonatomic) PNBarChart * barChart;
@property (strong, nonatomic) NSMutableArray *legend;
@property (strong, nonatomic) NSArray *colorsFromUI;
@end

@implementation BarChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pickerData = [[NSMutableArray alloc] init];
    self.pickerData = [NSMutableArray arrayWithArray:[[[MenuManager shared] categoriesOfDishes] allKeys]];
    self.categoryPicker.delegate = self;
    self.categoryPicker.dataSource = self;
    [self.pickerData insertObject:@"All Categories" atIndex:0];
    self.colorsFromUI = @[@"#6b48ff", @"#ff6337", @"#b31e6f", @"#00bdaa", @"#58b368", @"#ff487e", @"#226b80", @"52437b"];    self.legend = [NSMutableArray arrayWithArray:[[[MenuManager shared] categoriesOfDishes] allKeys]];
    [self.legend insertObject:@"All Categories" atIndex:0];

    self.categoriesOfDishes = [[MenuManager shared] categoriesOfDishes];
    if ([[[MenuManager shared] dishes] count] > 0)
    {
        [self setUpChartForCategory:@"All Categories"];
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot render chart" message:@"Add more dishes to render chart."
                                                             preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle response here.
                                                         }];
        // add the OK action to the alert controller
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{
        }];
    }

}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.legend count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.legend[row];
}- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSArray *viewsToRemove = [self.dataView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    [self setUpChartForCategory:[self.legend objectAtIndex:[self.categoryPicker selectedRowInComponent:0]]];
}
- (void) setUpChartForCategory : (NSString *) category
{
    self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, self.dataView.bounds.size.width, self.dataView.bounds.size.height) ];
    self.barChart.yChartLabelWidth = 20.0;
    self.barChart.chartMarginLeft = 30.0;
    self.barChart.chartMarginRight = 10.0;
    self.barChart.chartMarginTop = 5.0;
    self.barChart.chartMarginBottom = 10.0;
    self.barChart.labelMarginTop = 5.0;
    self.barChart.showChartBorder = YES;
    NSMutableArray *xValues = [[NSMutableArray alloc] init];
    NSMutableArray *yValues = [[NSMutableArray alloc] init];
    NSMutableArray *barRatings = [[NSMutableArray alloc] init];
    if ([[[MenuManager shared] dishes] count] > 0)
    {
        CGFloat dishRating = 0;

        if ([category isEqualToString:@"All Categories"])
        {
            NSString *categoryIterating;
            NSMutableArray *colorValues =[[NSMutableArray alloc] init];
            for (int i = 1; i < self.legend.count; i++)
            {
                categoryIterating = self.legend[i];
                CGFloat categoryFreq = 0;
                CGFloat categoryRating = 0;
                for (Dish *dish in self.categoriesOfDishes[categoryIterating])
                {
                    if (dish.rating != nil)
                    {
                        dishRating = [dish.rating floatValue];
                    }
                    else
                    {
                        dishRating = 0;
                    }
            
                    categoryRating += dishRating;
                    categoryFreq += [dish.orderFrequency floatValue];
                }
                if (categoryFreq != 0)
                {
                    categoryRating /= categoryFreq;
                }
                else
                {
                    categoryRating = 0;
                }
                [barRatings addObject:[NSNumber numberWithFloat:categoryRating]];
                [xValues addObject:categoryIterating];
                [yValues addObject:[NSNumber numberWithFloat:categoryFreq]];
                [colorValues addObject:[[Helpful_funs shared] colorFromHexString:self.colorsFromUI[i]]];
            }
            [self.barChart setStrokeColors:colorValues];
        }
        else
        {
            for (Dish *dish in self.categoriesOfDishes[category])
            {
                if (dish.rating != nil && dish.orderFrequency > 0)
                {
                    dishRating = [dish.rating floatValue] / [dish.orderFrequency floatValue];
                    
                }
                else
                {
                    dishRating = 0;
                }
                [barRatings addObject:[NSNumber numberWithFloat:dishRating]];
                [xValues addObject:dish.name];
                [yValues addObject:dish.orderFrequency];
            }
            NSUInteger indexOfCat = [self.legend indexOfObject:category];
            [self.barChart setStrokeColor:[[Helpful_funs shared] colorFromHexString:self.colorsFromUI[indexOfCat]]];
        }
        [self.barChart setXLabels:xValues];
        [self.barChart setYValues:yValues];
        [self.barChart setRatingValues:barRatings];
        self.barChart.isGradientShow = NO;
        self.barChart.isShowNumbers = YES;
        
        [self.barChart strokeChart];
        
        self.barChart.delegate = self;
        
        [self.view addSubview:self.barChart];
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot render chart" message:@"Add more dishes to render chart."
                                                                preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle response here.
                                                         }];
        // add the OK action to the alert controller
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{
        }];
    }

    //[self.barChart setXLabels:@[@"2", @"3", @"4", @"5", @"2", @"3", @"4", @"5"]];
    //       self.barChart.yLabels = @[@-10,@0,@10];
    //        [self.barChart setYValues:@[@10000.0,@30000.0,@10000.0,@100000.0,@500000.0,@1000000.0,@1150000.0,@2150000.0]];
    
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
