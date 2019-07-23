//
//  ScatterViewController.m
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/22/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "ScatterViewController.h"

@interface ScatterViewController ()
@property (weak, nonatomic) IBOutlet UIView *dataView;
@property (strong, nonatomic) NSMutableDictionary *categoriesOfDishes;
@property (strong, nonatomic) PNScatterChart *scatterChart;
@property (strong, nonatomic) NSArray *legend;
@end

@implementation ScatterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.categoriesOfDishes = [[MenuManager shared] categoriesOfDishes];
    self.legend = [[[MenuManager shared] categoriesOfDishes] allKeys];
    NSArray * dataArray = [self populateDataByRatingAndFreq];
    //For Scatter Chart
    self.scatterChart = [[PNScatterChart alloc] initWithFrame:CGRectMake(0, 0, self.dataView.bounds.size.width, self.dataView.bounds.size.height)];
    [self.scatterChart setAxisXWithMinimumValue:0 andMaxValue:10 toTicks:20];
    [self.scatterChart setAxisYWithMinimumValue:0 andMaxValue:50 toTicks:12];
    NSMutableArray <PNScatterChartData*> *categoryScatter = [[NSMutableArray alloc] init];
    NSArray *colorsFromPN = [NSArray arrayWithObjects:PNLightBlue, PNLightGreen, PNBlack, PNRed, PNYellow, PNDarkYellow, PNDarkBlue, PNDeepGrey, PNDeepGreen, PNTwitterColor, nil];
    NSLog(@"%lu", (unsigned long)self.legend.count);
    for (int i = 0; i < self.legend.count; i ++)
    {
        categoryScatter[i] = [PNScatterChartData new];
        categoryScatter[i].fillColor = colorsFromPN[i];
        categoryScatter[i].size = 5;
        categoryScatter[i].itemCount = [[dataArray[i] objectAtIndex:0] count];
        categoryScatter[i].inflexionPointStyle = PNScatterChartPointStyleCircle;
        __block NSMutableArray *XAr1 = [NSMutableArray arrayWithArray:[dataArray[i] objectAtIndex:1]];
        __block NSMutableArray *YAr1 = [NSMutableArray arrayWithArray:[dataArray[i]
                                                                       objectAtIndex:2]];
        categoryScatter[i].getData = ^(NSUInteger index) {
            CGFloat xValue = [[XAr1 objectAtIndex:index] floatValue];
            CGFloat yValue = [[YAr1 objectAtIndex:index] floatValue];
            return [PNScatterChartDataItem dataItemWithX:xValue AndWithY:yValue];

        };
        [self.scatterChart setup];
        
        self.scatterChart.chartData = @[categoryScatter[i]];
        
    }

    self.scatterChart.delegate = self;
    
    [self.dataView addSubview:self.scatterChart];
    
}

- (NSArray *)populateDataByRatingAndFreq
{
    NSMutableArray *theData = [NSMutableArray array];
    for (NSString *category in self.legend)
    {
        NSMutableArray *categoryData = [NSMutableArray array];
        NSArray *temp = self.categoriesOfDishes[category];
        NSMutableArray *theseRatings = [NSMutableArray array];
        NSMutableArray *theseFreqs = [NSMutableArray array];
        NSMutableArray *theseNames = [NSMutableArray array];
        for (Dish *dish in temp)
        {
            NSNumber *rating;
            if (dish.rating==nil)
            {
                rating = @(0);
            }
            else
            {
                rating = [NSNumber numberWithFloat:[dish.rating floatValue]/[dish.orderFrequency floatValue]];
            }
            [theseRatings addObject:rating];
            [theseFreqs addObject:dish.orderFrequency];
            [theseNames addObject:dish.name];
        }
        [categoryData addObject:theseNames];
        [categoryData addObject:theseRatings];
        [categoryData addObject:theseFreqs];
        [theData addObject:categoryData];
    }
    
    return theData;
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
