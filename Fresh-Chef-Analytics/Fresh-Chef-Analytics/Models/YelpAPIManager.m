
#import "YelpAPIManager.h"
#import "Parse/Parse.h"
@import CoreLocation;
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation YelpAPIManager

+ (instancetype)shared {
    static YelpAPIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });

    return sharedManager;
}

-(void)fetchCompetitors{
    [self setCoordinates];

}
- (void) setCoordinates
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        [self.locationManager startUpdatingLocation];
        
    }
    else
    {
        NSLog(@"System version must be 8.0 or higher");
    }
}
// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.restaurantCoordinates = [[Coordinate shared] setCoordinateValuesWithLatitude:[[manager location] coordinate].latitude andLongitude: [[manager location] coordinate].longitude];
    
    NSMutableArray *placeholder = [[NSMutableArray alloc] init];
    NSString *placeholder2 = @"no item here";
    if (!self.competitorArray){
        self.competitorArray = [[NSMutableArray alloc] initWithObjects:placeholder, placeholder, placeholder, nil];
        
        
        PFUser *currentUser = [PFUser currentUser];
        self.userParameters = [[NSMutableArray alloc] initWithObjects:placeholder2, placeholder2, placeholder2, nil];
        if (currentUser[@"address"] != nil){
            [self.userParameters replaceObjectAtIndex:0 withObject:currentUser[@"address"]];
        }
        if (currentUser[@"category"] != nil){
            [self.userParameters replaceObjectAtIndex:1 withObject:currentUser[@"category"]];
        }
        if (currentUser[@"Price"] != nil){
            [self.userParameters replaceObjectAtIndex:2 withObject:currentUser[@"Price"]];
        }
        
        [self locationTopRatings:self.userParameters[1] withPrice:self.userParameters[2] withIndex:0];
    }
    
}
-(void)locationTopRatings:(nullable NSString *)categoryRes withPrice:(nullable NSString *)priceRes withIndex:(NSUInteger)index{
    
        NSDictionary *headers = @{
                                  @"Authorization": @"Bearer Z505A_B9SNUBRJYRkioQ9NX8ZD9AnREWx3MqrxHSny1dop_ox6v0Ptx2-qbqX6fktt79CfqzXYdCcc6j3iE6BMTK6QHsDThNMbPYSf1mWXec1p7zsC6MupJVmkU2XXYx",
                                  @"User-Agent": @"PostmanRuntime/7.15.0",
                                @"Accept": @"*/*",
                                @"Cache-Control": @"no-cache",
                                @"Postman-Token": @"cdd4afd3-9488-46d1-84eb-b49577689432,71be9541-3f52-4e44-8bcc-098ad7950623",
                                @"Host": @"api.yelp.com",
                                @"cookie": @"__cfduid=d6047e6fa93475a54ffb5335f93cd9fbb1563860170",
                                  @"accept-encoding": @"gzip, deflate",
                                  @"Connection": @"keep-alive"};
        NSString *baseString = @"https://api.yelp.com/v3/businesses/search?term=restaurants,%20food&type=food,%20restaurants&sort_by=rating&limit=5";
        if (self.restaurantCoordinates.latitude && self.restaurantCoordinates.longitude){
            NSString* locationQuery = [NSString stringWithFormat:@"&latitude=%f&longitude=%f", self.restaurantCoordinates.latitude, self.restaurantCoordinates.longitude];
            baseString = [baseString stringByAppendingString:locationQuery];
        
            if (index == 1 && categoryRes && !([categoryRes isEqualToString:@"no item here"])){
                NSString* categoryQuery = [NSString stringWithFormat:@"&categories=%@", categoryRes];
                baseString = [baseString stringByAppendingString:categoryQuery];
            }
            if (index == 2 && priceRes && !([priceRes isEqualToString:@"no item here"])){
                NSString* priceQuery = [NSString stringWithFormat:@"&price=%@", priceRes];
                baseString = [baseString stringByAppendingString:priceQuery];
            }
            
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:baseString]
                                                                   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                               timeoutInterval:10.0];
            [request setHTTPMethod:@"GET"];
            [request setAllHTTPHeaderFields:headers];
            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if (error) {
                        NSString *er = [error localizedDescription];
                        NSLog(@"%@", er);
                    } else {
                        
                        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

                        [self.competitorArray replaceObjectAtIndex:index withObject:dataDictionary[@"businesses"]];
                        if (index < 2){
                            NSUInteger newIndex = index + 1;
                            [self locationTopRatings:self.userParameters[1] withPrice:self.userParameters[2] withIndex:newIndex];
                            
                        }
                    }
                    
                }];
        
        [dataTask resume];
        }
}



@end
