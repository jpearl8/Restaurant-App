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


@interface CompetitorListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl; // location, category, price
@property (weak, nonatomic) IBOutlet UITableView *competitorList;
@property (strong, nonatomic) NSMutableArray* businesses;

@property (strong, nonatomic) NSMutableArray* params;


@end

@implementation CompetitorListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.competitorList.dataSource = self;
    self.competitorList.delegate = self;
    self.businesses = [YelpAPIManager shared].competitorArray;
    PFUser *currentUser = [PFUser currentUser];
    NSString *location = currentUser[@"address"];
    self.params = [[NSMutableArray alloc] initWithObjects:location, @"0", @"0", nil];
    [self.competitorList reloadData];
   
    // Do any additional setup after loading the view.
}




- (IBAction)segmentChange:(UISegmentedControl *)sender {
    [self.competitorList reloadData];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompetitorsCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Competitors"];
    if (((NSArray*)self.businesses[self.segmentControl.selectedSegmentIndex]).count != 0){
        
        NSDictionary *business = ((NSArray*)self.businesses[self.segmentControl.selectedSegmentIndex])[indexPath.row];
        
        cell.competitorName.text = business[@"name"];
        cell.address.text = [NSString stringWithFormat:@"%@, %@",business[@"location"][@"display_address"][0], business[@"location"][@"display_address"][1]];
        cell.rating.text = [NSString stringWithFormat:@"%@", business[@"rating"]];
        cell.price.text = business[@"price"];
       // NSMutableAttributedString * link = [[NSMutableAttributedString alloc] initWithString:@"Yelp Link"];
       // [link addAttribute: NSLinkAttributeName value:business[@"url"] range: NSMakeRange(0, link.length)];
        //to get lat long: business[@"coordinates"][@latitude"] / business[@"coordinates"][@latitude"][@"longitude"]

       cell.yelpLink.link = business[@"url"];
        NSString *imageUrl = business[@"image_url"];
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            cell.competitorImage.image = [UIImage imageWithData:data];
        }];
    }

    return cell;

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
