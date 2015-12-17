//
//  AnalyticsServer.h
//  DBMeiziFuli
//
//  Created by jackyshan on 9/25/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnalyticsServer : NSObject

/**
 *  启动统计服务
 */
+ (void)startServer;
/**
 *  统计进入了什么页面
 *
 *  @param name 页面名称
 */
+ (void)inController:(NSString *)name;
/**
 *  统计跳出了什么页面
 *
 *  @param name 页面名称
 */
+ (void)outController:(NSString *)name;

+ (void)event:(NSString *)event;

@end
