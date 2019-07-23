
#import "YelpAPIManager.h"

@implementation YelpAPIManager

+ (instancetype)shared {
    static YelpAPIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

-(void)locationTopRatings:(NSString*)location withCategory:(nullable NSString *)category withPrice:(nullable NSString *)price{
    NSDictionary *headers = @{
                              @"Authorization": @"Bearer Z505A_B9SNUBRJYRkioQ9NX8ZD9AnREWx3MqrxHSny1dop_ox6v0Ptx2-qbqX6fktt79CfqzXYdCcc6j3iE6BMTK6QHsDThNMbPYSf1mWXec1p7zsC6MupJVmkU2XXYx",
                              @"User-Agent": @"PostmanRuntime/7.15.0",
                              @"Accept": @"*/*",
                              @"Cache-Control": @"no-cache",
                              @"Postman-Token": @"cdd4afd3-9488-46d1-84eb-b49577689432,71be9541-3f52-4e44-8bcc-098ad7950623",
                              @"Host": @"api.yelp.com",
                              @"cookie": @"__cfduid=d6047e6fa93475a54ffb5335f93cd9fbb1563860170",
                              @"accept-encoding": @"gzip, deflate",
                              @"Connection": @"keep-alive",
                              @"cache-control": @"no-cache" };
    NSString *baseString = @"https://api.yelp.com/v3/businesses/search?term=restaurants,%20food&type=food,%20restaurants&sort_by=rating&limit=3";
    if (location){
        NSString* locationQuery = [NSString stringWithFormat:@"&location=%@", location];
        baseString = [baseString stringByAppendingString:locationQuery];
    }
    if (category){
        NSString* categoryQuery = [NSString stringWithFormat:@"&categories=%@", category];
        baseString = [baseString stringByAppendingString:categoryQuery];
    }
    if (price){
        NSString* priceQuery = [NSString stringWithFormat:@"&price=%@", price];
        baseString = [baseString stringByAppendingString:priceQuery];
    }
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:baseString]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                                        
                                                        //NSLog(@"%@", dataDictionary);
                                                        NSLog(@"%@", dataDictionary);
                                                    }
                                                }];
    [dataTask resume];
}
@end
