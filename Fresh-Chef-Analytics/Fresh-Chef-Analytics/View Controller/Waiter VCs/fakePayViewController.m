//
//  fakePayViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 8/12/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "fakePayViewController.h"
#import "YelpLinkViewController.h"
#import "Link.h"
#import "UIRefs.h"

@interface fakePayViewController ()
@property (strong, nonatomic) IBOutlet Link *toPayPall;

@property (strong, nonatomic) IBOutlet UIImageView *image;

@end

@implementation fakePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIRefs shared] setImage:self.image isCustomerForm:YES];
    self.toPayPall.link = @"https://www.paypal.com/us/signin";
    // Do any additional setup after loading the view.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:Link.class]){
        YelpLinkViewController *yelpTab = [segue destinationViewController];
        yelpTab.yelpLink = ((Link *)sender).link;
    }// Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
