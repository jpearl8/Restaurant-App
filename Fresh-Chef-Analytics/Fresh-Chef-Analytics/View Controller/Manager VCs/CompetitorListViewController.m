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
#import "TTTAttributedLabel.h"
#import "Parse/Parse.h"


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
    NSDictionary *business = ((NSArray*)self.businesses[self.segmentControl.selectedSegmentIndex])[indexPath.row];
    
    cell.competitorName.text = business[@"name"];
    cell.address.text = [NSString stringWithFormat:@"%@, %@",business[@"location"][@"display_address"][0], business[@"location"][@"display_address"][1]];
    cell.rating.text = [NSString stringWithFormat:@"%@", business[@"rating"]];
    cell.price.text = business[@"price"];
   // NSMutableAttributedString * link = [[NSMutableAttributedString alloc] initWithString:@"Yelp Link"];
   // [link addAttribute: NSLinkAttributeName value:business[@"url"] range: NSMakeRange(0, link.length)];
   cell.yelpLink.enabledTextCheckingTypes = NSTextCheckingTypeLink; // Automatically detect links when the label text is subsequently changed
   cell.yelpLink.delegate = self; // Delegate methods are called when the user taps on a link (see `TTTAttributedLabelDelegate` protocol)
//
   //NSString *link = [NSString stringWithFormat:@"YelpLink! (%@)", business[@"url"]];
    NSRange link = [cell.yelpLink.text rangeOfString:@"Yelp Link"];
    [cell.yelpLink addLinkToURL:[NSURL URLWithString:business[@"url"]] withRange:link];
   //cell.yelpLink.text = link;
  
    //cell.yelpLink.text = business[@"url"];
    NSString *imageUrl = business[@"image_url"];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        cell.competitorImage.image = [UIImage imageWithData:data];
    }];
    return cell;

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
