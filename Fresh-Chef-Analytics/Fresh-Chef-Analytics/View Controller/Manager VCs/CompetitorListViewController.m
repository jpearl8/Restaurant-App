//
//  CompetitorListViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "CompetitorListViewController.h"
#import "CompetitorsCell.h"
#import "YelpAPIManager.h"
#import "Parse/Parse.h"
#import "YelpLinkViewController.h"
#import "MKDropdownMenu.h"


@interface CompetitorListViewController () <UITableViewDelegate, UITableViewDataSource, MKDropdownMenuDelegate, MKDropdownMenuDataSource>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl; // location, category, price
@property (weak, nonatomic) IBOutlet UITableView *competitorList;
@property (strong, nonatomic) NSMutableArray* businesses;
@property (weak, nonatomic) IBOutlet MKDropdownMenu *dropDown;
@property (strong, nonatomic) NSArray *dropDownCats;
@property (weak, nonatomic) IBOutlet UILabel *dropDownLabel;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) NSMutableArray* params;


@end

@implementation CompetitorListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.dropDown.delegate = self;
    self.dropDown.dataSource = self;
    self.competitorList.dataSource = self;
    self.competitorList.delegate = self;
    self.businesses = [YelpAPIManager shared].competitorArray;
    PFUser *currentUser = [PFUser currentUser];
    NSString *location = currentUser[@"address"];
    self.params = [[NSMutableArray alloc] initWithObjects:location, @"0", @"0", nil];
    self.dropDownCats = @[@"General Competitors", @"Cagegory Competitors", @"Price Point Competitors"];
    self.selectedIndex = 0;
    self.dropDownLabel.text = @"General Competitors";

   // [self.competitorList reloadData];
   
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu
{
    return 1;
}
- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component
{
    return [self.dropDownCats count];
}
- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    UIFont * font = [UIFont systemFontOfSize:13
                     ];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    
    NSAttributedString *titleForComponent = [[NSAttributedString alloc] initWithString:self.dropDownCats[row] attributes:attributes];
    return titleForComponent;
}
- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedIndex = row;
//    if(self.selectedIndex == 0){
//        self.orderedDishesDict = [[MenuManager shared] dishesByFreq];
//    } else if (self.selectedIndex == 1) {
//        self.orderedDishesDict = [[MenuManager shared] dishesByRating];
//    } else if (self.selectedIndex == 2) {
//        self.orderedDishesDict = [[MenuManager shared] dishesByPrice];
//    } else {
//        NSLog(@"no buttons pressed");
//    }
    self.dropDownLabel.text = self.dropDownCats[row];

    [self.competitorList reloadData];
}


- (IBAction)segmentChange:(UISegmentedControl *)sender {
    [self.competitorList reloadData];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompetitorsCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Competitors"];
    if (((NSArray*)self.businesses[self.selectedIndex]).count != 0){
        cell.yelpLink.layer.shadowRadius  = 1.f;
        cell.yelpLink.layer.shadowColor   = [UIColor colorWithRed:176.f/255.f green:199.f/255.f blue:226.f/255.f alpha:1.f].CGColor;
        cell.yelpLink.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
        cell.yelpLink.layer.shadowOpacity = 0.9f;
        cell.yelpLink.layer.masksToBounds = NO;
        
        UIEdgeInsets shadowInsets     = UIEdgeInsetsMake(0, 0, -1.5f, 0);
        UIBezierPath *shadowPath      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(cell.yelpLink.bounds, shadowInsets)];
        cell.yelpLink.layer.shadowPath    = shadowPath.CGPath;
        NSDictionary *business = ((NSArray*)self.businesses[self.selectedIndex])[indexPath.row];
        
        cell.competitorName.text = business[@"name"];
        cell.address.text = [NSString stringWithFormat:@"%@, %@",business[@"location"][@"display_address"][0], business[@"location"][@"display_address"][1]];
        
      //  NSString *rating = [NSString stringWithFormat:@"%@", business[@"rating"]];
        cell.price.text = business[@"price"];
       // NSMutableAttributedString * link = [[NSMutableAttributedString alloc] initWithString:@"Yelp Link"];
       // [link addAttribute: NSLinkAttributeName value:business[@"url"] range: NSMakeRange(0, link.length)];
        //to get lat long: business[@"coordinates"][@latitude"] / business[@"coordinates"][@latitude"][@"longitude"]

       cell.yelpLink.link = business[@"url"];
        NSString *imageUrl = business[@"image_url"];
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            cell.competitorImage.image = [UIImage imageWithData:data];
        }];
        cell.reviewCount.text = [NSString stringWithFormat:@"%@", business[@"review_count"] ];
        NSString *yelpStars = [self floatToYelpStars:[business[@"rating"] floatValue]];
       [cell.yelpRating setImage:[UIImage imageNamed:yelpStars]];
    }

    return cell;

}
-(NSString *)floatToYelpStars:(float)rating{
    NSString *yelpStars = [NSString stringWithFormat:@"small_%0.f", floorf(rating)];
    if(rating != floorf(rating)){
        yelpStars = [NSString stringWithFormat:@"%@_half", yelpStars];
    }
    return yelpStars;
}

- (IBAction)clickLink:(Link *)sender {
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:Link.class]){
        YelpLinkViewController *yelpTab = [segue destinationViewController];
        yelpTab.yelpLink = ((Link *)sender).link;
    }// Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
