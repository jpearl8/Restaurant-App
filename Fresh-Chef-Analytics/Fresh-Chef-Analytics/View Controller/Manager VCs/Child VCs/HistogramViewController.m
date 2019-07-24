//
//  HistogramViewController.m
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/22/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "HistogramViewController.h"

@interface HistogramViewController ()
@property (weak, nonatomic) IBOutlet UIView *dataView;
@property (strong, nonatomic) NSMutableDictionary *categoriesOfDishes;
@property (strong, nonatomic) PNRadarChart *radarChart;
@property (strong, nonatomic) NSMutableArray *legend;
@property (strong, nonatomic) NSArray *ratingsForDishes;
@property (strong, nonatomic) NSArray *frequencyForDishes;
@property (strong, nonatomic) NSArray *profitForDishes;
@property (strong, nonatomic) NSArray *colorsFromUI;
@property (strong, nonatomic) NSArray *chartColors;
@property (strong, nonatomic) CAShapeLayer *ratingPlot;
@property (strong, nonatomic) CAShapeLayer *frequencyPlot;
@property (strong, nonatomic) CAShapeLayer *profitPlot;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *profitLabel;
@property (weak, nonatomic) IBOutlet UILabel *popularityLabel;
@property (strong, nonatomic) NSArray *ratingItems;
@property (strong, nonatomic) NSArray *frequencyItems;
@property (strong, nonatomic) NSArray *profitItems;

@end

@implementation HistogramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.categoriesTableView.delegate = self;
    self.categoriesTableView.dataSource = self;
    self.colorsFromUI = @[@"#FF0000", @"#00FF00", @"#00FFFF", @"#FF00FF", @"#FCAF0B", @"#800BFC", @"#0B30FC", @"0B30FC"];
    self.chartColors = @[@"#FE0EBC", @"#0E62FE", @"#FEDD0E"];
    self.ratingLabel.textColor = [[Helpful_funs shared] colorFromHexString:self.chartColors[0]];
    self.popularityLabel.textColor = [[Helpful_funs shared] colorFromHexString:self.chartColors[1]];
    self.profitLabel.textColor = [[Helpful_funs shared] colorFromHexString:self.chartColors[2]];

    self.categoriesOfDishes = [[MenuManager shared] categoriesOfDishes];
    self.legend = [NSMutableArray arrayWithArray:[[[MenuManager shared] categoriesOfDishes] allKeys]];
    
    [self.legend insertObject:@"All categories" atIndex:0];
    [self.legend arrayByAddingObjectsFromArray:[[[MenuManager shared] categoriesOfDishes] allKeys]];
    
    // contents are name, rating, frequency, profit //
    NSArray *dataArray = [self populateDataForAllCategories];
    [self makeItemsWithData:dataArray];
    [self setUpChartWithData];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.legend.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SimpleTableItem"];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SimpleTableItem"];
    }
    cell.textLabel.text = self.legend[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *viewsToRemove = [self.dataView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    UITableViewCell *cell = [self.categoriesTableView cellForRowAtIndexPath:indexPath];
    NSArray *dataArray;
    if ([cell.textLabel.text  isEqual: @"All categories"])
    {
        dataArray = [self populateDataForAllCategories];
    }
    else
    {
        dataArray = [self populateDataForCategory:cell.textLabel.text];
    }
    [self makeItemsWithData:dataArray];
    [self setUpChartWithData];
    
}
- (NSArray *) populateDataForCategory : (NSString *) category
{
    NSMutableArray *dataForRadar = [NSMutableArray array];
    NSMutableArray *ratingData = [NSMutableArray array];
    NSMutableArray *frequencyData = [NSMutableArray array];
    NSMutableArray *profitData = [NSMutableArray array];
    NSMutableArray *dishNames = [NSMutableArray array];
    CGFloat dishRating;
    CGFloat dishProfit;
    for (Dish *dish in self.categoriesOfDishes[category])
    {
        [dishNames addObject:dish.name];
        dishProfit = [dish.price floatValue] * [dish.orderFrequency floatValue];
        if (dish.rating == nil)
        {
            dishRating = 0;
            
        }
        else {
            dishRating = [dish.rating floatValue] / [dish.orderFrequency floatValue];
        }
        [ratingData addObject:[NSNumber numberWithFloat:dishRating]];
        [frequencyData addObject:dish.orderFrequency];
        [profitData addObject:[NSNumber numberWithFloat:dishProfit]];
    }
    [dataForRadar addObject:dishNames];
    [dataForRadar addObject:ratingData];
    [dataForRadar addObject:frequencyData];
    [dataForRadar addObject:profitData];
    return dataForRadar;
}
- (NSArray *) populateDataForAllCategories
{
    NSMutableArray *dataForRadar = [NSMutableArray array];
    NSMutableArray *ratingData = [NSMutableArray array];
    NSMutableArray *frequencyData = [NSMutableArray array];
    NSMutableArray *profitData = [NSMutableArray array];
    NSMutableArray *categoryNames = [NSMutableArray array];

    NSString *category;
    CGFloat categoryRating;
    CGFloat categoryFrequency;
    CGFloat categoryProfit;
    CGFloat dishProfit;
    CGFloat dishRating;
    for (int i = 1; i < self.legend.count; i++)
    {
        category = self.legend[i];
        [categoryNames addObject:category];
        categoryProfit = 0;
        categoryRating = 0;
        categoryFrequency = 0;
        for (Dish *dish in self.categoriesOfDishes[category])
        {
            dishProfit = [dish.price floatValue] * [dish.orderFrequency floatValue];
            if (dish.rating == nil)
            {
                dishRating = 0;

            }
            else {
                dishRating = [dish.rating floatValue] / [dish.orderFrequency floatValue];
            }
            categoryRating += dishRating;
            categoryFrequency += [dish.orderFrequency floatValue];
            categoryProfit += dishProfit;
        }
        [ratingData addObject:[NSNumber numberWithFloat:categoryRating]];
        [frequencyData addObject:[NSNumber numberWithFloat:categoryFrequency]];
        [profitData addObject:[NSNumber numberWithFloat:categoryProfit]];
    }
    [dataForRadar addObject:categoryNames];
    [dataForRadar addObject:ratingData];
    [dataForRadar addObject:frequencyData];
    [dataForRadar addObject:profitData];
    return dataForRadar;
}

- (NSArray *) populateDataItemsWithArray : (NSArray *) dataArray forDescriptions : (NSArray *) descriptionsArray
{
    NSMutableArray *dataItems = [NSMutableArray array];
    for (int i = 0; i < dataArray.count; i++)
    {
        [dataItems addObject:[PNRadarChartDataItem dataItemWithValue:[dataArray[i] floatValue] description:descriptionsArray[i]]];
    }
    return dataItems;
}
- (IBAction)chooseCategory:(id)sender {
    self.categoriesTableView.hidden = !(self.categoriesTableView.hidden);
}
- (void)makeItemsWithData : (NSArray *) dataArray
{
    [[Helpful_funs shared] scaleArrayByMax:dataArray[1]];
        self.ratingItems = [self populateDataItemsWithArray:dataArray[1] forDescriptions:dataArray[0]];
    [[Helpful_funs shared] scaleArrayByMax:dataArray[2]];

    self.frequencyItems = [self populateDataItemsWithArray:dataArray[2] forDescriptions:dataArray[0]];
    [[Helpful_funs shared] scaleArrayByMax:dataArray[3]];

    self.profitItems = [self populateDataItemsWithArray:dataArray[3] forDescriptions:dataArray[0]];
}
- (void)setUpChartWithData
{
    self.radarChart = [[PNRadarChart alloc] initWithFrameAndColor:CGRectMake(0, 0, self.dataView.bounds.size.width, self.dataView.bounds.size.height) items:self.ratingItems valueDivider:0.25 withColor:[[[Helpful_funs shared] colorFromHexString:self.chartColors[0]] colorWithAlphaComponent:0.4]];
    [self.radarChart addPlotWithData:self.frequencyItems withColor:[[[Helpful_funs shared] colorFromHexString:self.chartColors[1]] colorWithAlphaComponent:0.4]];
    [self.radarChart addPlotWithData:self.profitItems withColor:[[[Helpful_funs shared] colorFromHexString:self.chartColors[2]] colorWithAlphaComponent:0.4]];
    
    [self.dataView addSubview:self.radarChart];
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
