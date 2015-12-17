//
//  AnalyticsServer.m
//  DBMeiziFuli
//
//  Created by jackyshan on 9/25/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "AnalyticsServer.h"
#import "MobClick.h"
#import "ProjectMacro.h"

@implementation AnalyticsServer

+ (void)startServer
{
    // 如果不需要捕捉异常，注释掉此行
    [MobClick setCrashReportEnabled:bCatchCrash];
    // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    //    [MobClick setLogEnabled:bLogSwitch];
    //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick setAppVersion:XcodeAppVersion];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    [MobClick startWithAppkey:sUMAppKey reportPolicy:kSendLog channelId:sChannelId];
}

+ (void)inController:(NSString *)name
{
    [MobClick beginLogPageView:name];
}

+ (void)outController:(NSString *)name
{
    [MobClick endLogPageView:name];
}

+ (void)event:(NSString *)event
{
    [MobClick event:event];
}

@end
