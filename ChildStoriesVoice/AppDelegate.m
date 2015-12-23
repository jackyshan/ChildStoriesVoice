//
//  AppDelegate.m
//  ChildStoriesVoice
//
//  Created by jackyshan on 12/17/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "JackyBusiness.pch"
#import "ProjectColor.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //window init
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = COLOR_FFFFFF;
    
    //home vc
    HomeViewController *vc= [[HomeViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
    
    //init bottomBar
    [self.window addSubview:self.playBottomBar];
    
    return YES;
}

- (UIView *)playBottomBar {
    if (!_playBottomBar) {
        _playBottomBar = [[PlayBottomBarView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kPlayBottomBarHeight, kScreenWidth, kPlayBottomBarHeight)];
    }
    
    return _playBottomBar;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
