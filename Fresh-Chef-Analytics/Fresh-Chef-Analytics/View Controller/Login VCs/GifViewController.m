//
//  GifViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 8/6/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "GifViewController.h"
#import "AnimatedGif.h"
#import "UIImageView+AnimatedGif.h"
#import "MenuManager.h"
#import "WaiterManager.h"
#import "OrderManager.h"
#import "YelpAPIManager.h"

@interface GifViewController ()
@property (strong, nonatomic) NSNumber *login;
@end

@implementation GifViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.restorationIdentifier isEqualToString:@"loading"]){
        self.login = [NSNumber numberWithInt:1];
    }
    AnimatedGif * gif = [AnimatedGif getAnimationForGifAtUrl:[NSURL URLWithString:@"https://d3jnkp3lrs2hd5.cloudfront.net/IDC/static/images/loading.gif"]];
    [self.gifIm setAnimatedGif:gif];
    [gif start];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animatedGifDidFinish:) name:AnimatedGifDidFinishLoadingingEvent object:nil];
//    [self setupForApp:^(NSError * _Nullable error) {
//        if (!error){
//        [self.view addSubview:self.gifIm];
//        [self performSegueWithIdentifier:@"toApp" sender:self];
//        }
//    }];
    
    
}

- (void)setupForApp:(void (^)( NSError * _Nullable error))completion
{
    NSLog(@"%d", self.login);
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser){
        [[YelpAPIManager shared] fetchCompetitors];
        __block int checks = 0;
        [[MenuManager shared] fetchMenuItems:currentUser withCompletion:^(NSMutableDictionary * _Nonnull categoriesOfDishes, NSError * _Nullable error) {
            
            if (!error)
            {
                checks = checks + 1;
                [[MenuManager shared] setOrderedDicts];
                [[MenuManager shared] setTop3Bottom3Dict];
                NSLog(@"fetched restaurant's menu");
                if (checks >= 3){
                    completion(nil);
                }
                
            } else {
                completion(error);
            }

        }];
        [[WaiterManager shared] fetchWaiters:currentUser withCompletion:^(NSError * _Nullable error) {
            
            if(!error)
            {
                [[WaiterManager shared] setOrderedWaiterArrays];
                NSLog(@"fetched restaurant's waiters");
                checks = checks + 1;
                if (checks >= 3){
                    completion(nil);
                }
                
            } else {
                completion(error);
            }
        }];
      
        [[OrderManager shared] fetchClosedOrderItems:currentUser withCompletion:^(NSArray * _Nonnull closedOrders, NSError * _Nonnull error) {
            if (!error)
            {
                NSLog(@"fetched restaurant's closed orders");
                checks = checks + 1;
                if (checks >= 3){
                    completion(nil);
                }
            } else {
                completion(error);
            }
        }];
    } else {
        completion(nil);
    }
}
-(void)animatedGifDidFinish:(NSNotification*) notify {
    AnimatedGif * object = notify.object;
    NSLog(@"Url is loaded: %@", object.url);
    [self setupForApp:^(NSError * _Nullable error) {
        if (!error){
            [self.view addSubview:self.gifIm];
            [self performSegueWithIdentifier:@"toApp" sender:self];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}


@end
