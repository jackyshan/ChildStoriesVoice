//
//  ShareServer.m
//  DBMeiziFuli
//
//  Created by jackyshan on 9/25/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "ShareServer.h"
#import "ProjectMacro.h"
#import "UMSocialData.h"
#import "UMSocialWechatHandler.h"

@implementation ShareServer

+ (void)startServer {
    [UMSocialData setAppKey:sUMAppKey];
    [UMSocialWechatHandler setWXAppId:@"wxf232068f4c549ebd" appSecret:@"e64abe1090a14e4c1f2f57af7226993f" url:@"http://jackyshan.gitcafe.io"];
}

+ (void)shareWithImg:(UIImage *)image content:(NSString *)content  shareType:(UMSocialSnsType)type block:(void (^)(id, BOOL))block {
    switch (type) {
        case UMSocialSnsTypeWechatSession:
        {
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
            [UMSocialData defaultData].extConfig.wechatSessionData.title = content;
            
            [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession] content:content image:image location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response) {
                if (response.responseCode == UMSResponseCodeSuccess) {
                    block(response, YES);
                }
                else {
                    block(response, NO);
                }
            }];
        }
            break;
            
        default:
            break;
    }
}

@end
