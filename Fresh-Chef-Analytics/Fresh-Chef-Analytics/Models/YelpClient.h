//
//  YelpClient.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/22/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

//#import <BDBOAuth1Manager/BDBOAuth1Manager.h>
#import "BDBOAuth1SessionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface YelpClient : BDBOAuth1SessionManager

+ (instancetype)shared;


@end

NS_ASSUME_NONNULL_END
