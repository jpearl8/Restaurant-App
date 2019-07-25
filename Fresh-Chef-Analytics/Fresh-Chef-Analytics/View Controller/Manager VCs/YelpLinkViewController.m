//
//  YelpLinkViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/25/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "YelpLinkViewController.h"
#import <WebKit/WebKit.h>

@interface YelpLinkViewController ()
@property (weak, nonatomic) IBOutlet WKWebView *webView;

@end

@implementation YelpLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *myURL = [NSURL URLWithString:self.yelpLink];
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
    [self.webView loadRequest:myRequest];
    // Do any additional setup after loading the view.
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
