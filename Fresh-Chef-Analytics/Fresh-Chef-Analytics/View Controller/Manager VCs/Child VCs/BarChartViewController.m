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
    NSMutableArray *barPrices = [[NSMutableArray alloc] init];
    if ([[[MenuManager shared] dishes] count] > 0)
    {
        if ([category isEqualToString:@"All Categories"])
        {
            NSString *categoryIterating;
            NSMutableArray *colorValues =[[NSMutableArray alloc] init];
            for (int i = 1; i < self.legend.count; i++)
            {
                categoryIterating = self.legend[i];
                CGFloat categoryFreq = 0;
                CGFloat categoryPrice = 0;
                for (Dish *dish in self.categoriesOfDishes[categoryIterating])
                {
                    
                    categoryPrice += [dish.price floatValue];
                    categoryFreq += [dish.orderFrequency floatValue];
                }
                [barPrices addObject:[NSNumber numberWithFloat:categoryPrice]];
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
                [barPrices addObject:dish.price];
                [xValues addObject:dish.name];
                [yValues addObject:dish.orderFrequency];
            }
            NSUInteger indexOfCat = [self.legend indexOfObject:category];
            [self.barChart setStrokeColor:[[Helpful_funs shared] colorFromHexString:self.colorsFromUI[indexOfCat]]];
        }
        NSMutableArray *indexOrder = [self setOrderForDescendingArray:barPrices];
        
        [self.barChart setXLabels:[self reorderUsingGivenIndexOrder:indexOrder forArr:xValues]];
        [self.barChart setYValues:[self reorderUsingGivenIndexOrder:indexOrder forArr:yValues]];
        [self.barChart setPrices:[self reorderUsingGivenIndexOrder:indexOrder forArr:barPrices]];
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

    
}
- (NSMutableArray *) setOrderForDescendingArray : (NSMutableArray *) arr
{
    NSMutableArray *indexArr = [[NSMutableArray alloc] init];
    NSMutableArray *copyOfArr = [[NSMutableArray alloc] initWithArray:arr];
    for (int i = 0; i < [arr count]; i++)
    {
    
        NSUInteger maxIndex = [copyOfArr indexOfObject:[copyOfArr valueForKeyPath:@"@max.self"]];
        [copyOfArr replaceObjectAtIndex:maxIndex withObject:@(0)];
        [indexArr addObject:[NSNumber numberWithInteger:maxIndex]];
    }
    return indexArr;
}
- (NSMutableArray *) reorderUsingGivenIndexOrder : (NSMutableArray *) indexArr forArr : (NSMutableArray *) arrToOrder
{
    NSMutableArray *newVersionOfArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [indexArr count]; i++)
    {
        [newVersionOfArray addObject:[arrToOrder objectAtIndex:[indexArr[i] integerValue]]];
    }
    return newVersionOfArray;
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
