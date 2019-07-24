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
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray* params;


@end

@implementation CompetitorListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.competitorList.dataSource = self;
    self.competitorList.delegate = self;
    
    PFUser *currentUser = [PFUser currentUser];
    NSString *location = currentUser[@"address"];
    self.params = [[NSMutableArray alloc] initWithObjects:location, @"0", @"0", nil];
    [self refetchCompetitors];
    
    [self.refreshControl endRefreshing];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refetchCompetitors) forControlEvents:UIControlEventValueChanged];
    [self.competitorList insertSubview:self.refreshControl atIndex:0];
    
    [self.competitorList reloadData];
    [self.refreshControl endRefreshing];
    // Do any additional setup after loading the view.
}




- (IBAction)segmentChange:(UISegmentedControl *)sender {
    PFUser *currentUser = [PFUser currentUser];
    //NSString *location = currentUser[@"address"];
    [self.params replaceObjectAtIndex:1 withObject:@"0"];
    [self.params replaceObjectAtIndex:2 withObject:@"0"];
    if (sender.selectedSegmentIndex == 1){
        NSString *category = currentUser[@"category"];
        [self.params replaceObjectAtIndex:1 withObject:category];
    }
    if (sender.selectedSegmentIndex == 2){
        NSString *price = currentUser[@"Price"];
        [self.params replaceObjectAtIndex:2 withObject:price];
    }
    self.businesses = [YelpAPIManager shared].competitorArray;
    [self.competitorList reloadData];

}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompetitorsCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Competitors"];
    NSDictionary *business = self.businesses[indexPath.row];
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

-(void)refetchCompetitors{
    NSLog(@"%@", self.params);
    NSDictionary *headers = @{
                              @"Authorization": @"Bearer Z505A_B9SNUBRJYRkioQ9NX8ZD9AnREWx3MqrxHSny1dop_ox6v0Ptx2-qbqX6fktt79CfqzXYdCcc6j3iE6BMTK6QHsDThNMbPYSf1mWXec1p7zsC6MupJVmkU2XXYx",
                              @"User-Agent": @"PostmanRuntime/7.15.0",
                              @"Accept": @"*/*",
                              @"Cache-Control": @"no-cache",
                              @"Postman-Token": @"cdd4afd3-9488-46d1-84eb-b49577689432,71be9541-3f52-4e44-8bcc-098ad7950623",
                              @"Host": @"api.yelp.com",
                              @"cookie": @"__cfduid=d6047e6fa93475a54ffb5335f93cd9fbb1563860170",
                              @"accept-encoding": @"gzip, deflate"};
    //                              @"Connection": @"keep-alive",
    //                              @"cache-control": @"no-cache" };
    NSString *baseString = @"https://api.yelp.com/v3/businesses/search?term=restaurants,%20food&type=food,%20restaurants&sort_by=rating&limit=3";
    if (self.params[0]){
        NSString* locationQuery = [NSString stringWithFormat:@"&location=%@", self.params[0]];
        baseString = [baseString stringByAppendingString:locationQuery];
    }
    if (!([self.params[1] isEqualToString:@"0"])){
        NSString* categoryQuery = [NSString stringWithFormat:@"&categories=%@", self.params[1]];
        baseString = [baseString stringByAppendingString:categoryQuery];
    }
    if (!([self.params[2] isEqualToString:@"0"])){
        NSString* priceQuery = [NSString stringWithFormat:@"&price=%@", self.params[2]];
        baseString = [baseString stringByAppendingString:priceQuery];
    }
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:baseString]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
  //  NSMutableURLRequest *request = [NSURLRequest requestWithURL:baseString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    //    //NSDictionary *dataDict = [[NSDictionary alloc] init];
    //    __block NSDictionary *dataDict = nil;
//    NSURLSession *session = [NSURLSession sharedSession];
   
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                NSString *er = [error localizedDescription];
                NSLog(@"%@", er);
               
                
            } else {
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                //
                //
                
                self.businesses = dataDictionary[@"businesses"];
                [self.competitorList reloadData];
            }
            
            [self.refreshControl endRefreshing];
            
        }];
    
    [dataTask resume];

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
