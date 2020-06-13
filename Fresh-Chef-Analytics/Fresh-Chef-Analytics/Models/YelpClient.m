//
//  YelpClient.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/22/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "YelpClient.h"


@implementation YelpClient

static NSString * const baseURLString = @"https://api.yelp.com/v3/";
static NSString * const client_id = @"UX35-zIZrBpT6aiRccruAg";
static NSString * const APIKey = @"Bearer Z505A_B9SNUBRJYRkioQ9NX8ZD9AnREWx3MqrxHSny1dop_ox6v0Ptx2-qbqX6fktt79CfqzXYdCcc6j3iE6BMTK6QHsDThNMbPYSf1mWXec1p7zsC6MupJVmkU2XXYx";

+ (instancetype)shared {
    static YelpClient *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

//- (instancetype)init {
//
//    NSURL *baseURL = [NSURL URLWithString:baseURLString];
//    NSString *client_id = client_id;
//    NSString *APIKey = APIKey;
//    // Check for launch arguments override
////    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"client_id"]) {
////        key = [[NSUserDefaults standardUserDefaults] stringForKey:@"client_id"];
////    }
////    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"]) {
////        secret = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"];
////    }
//
//    self = [super initWithBaseURL:baseURL consumerKey:client_id consumerSecret:APIKey];
//    if (self) {
//
//    }
//    return self;
//}
//-(void)locationTopRatings{
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setHTTPMethod:@"GET"];
//    [request setHTTP]
//    
//}
//NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//[request setHTTPMethod:@"GET"];
//[request setHTTPBody:body];
//[request setValue:[NSString stringWithFormat:@"%d", [body length]] forHTTPHeaderField:@"Content-Length"];
//[request setURL:[NSURL URLWithString:url]];
//
//// making a GET request to /init
//NSString *targetUrl = [NSString stringWithFormat:@"%@/init", baseUrl];
//NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//[request setHTTPMethod:@"GET"];
//[request setURL:[NSURL URLWithString:targetUrl]];
//
//[[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
//  ^(NSData * _Nullable data,
//    NSURLResponse * _Nullable response,
//    NSError * _Nullable error) {
//
//      NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//      NSLog(@"Data received: %@", myString);
//  }] resume];

//-(void)locationTopRatings:
//NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/320288/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US"];
//NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
//NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
//NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//    // lines inside block called once network call finished
//    if (error != nil) {
//        NSLog(@"%@", [error localizedDescription]);
//    }
//    else {
//        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//
//        //NSLog(@"%@", dataDictionary);
//        self.movies = dataDictionary[@"results"];
//
//        [self.movieGrid reloadData];
//
//        [SVProgressHUD dismiss];
//
//
//        // TODO: Get the array of movies
//        // TODO: Store the movies in a property to use elsewhere
//        // TODO: Reload your table view data
//    }


@end
