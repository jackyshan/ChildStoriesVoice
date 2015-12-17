//
//  ShareServer.h
//  DBMeiziFuli
//
//  Created by jackyshan on 9/25/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocialSnsPlatformManager.h"

@interface ShareServer : NSObject

+ (void)startServer;

+ (void)shareWithImg:(UIImage *)image content:(NSString *)content shareType:(UMSocialSnsType)type block:(void (^)(id, BOOL))block;

@end
