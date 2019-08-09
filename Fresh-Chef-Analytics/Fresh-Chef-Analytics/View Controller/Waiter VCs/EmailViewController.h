//
//  EmailViewController.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 8/6/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol CustomerLevelDelegate <NSObject>
-(void)changeLevel:(NSNumber *)newLevel withEmail:(NSString*)email;
@end

@interface EmailViewController : UIViewController
@property (nonatomic, weak) id <CustomerLevelDelegate> customerLevelDelegate;
@property (strong, nonatomic) NSString *email;
@end

NS_ASSUME_NONNULL_END
