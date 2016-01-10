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
#import "DataBaseServer.h"
#import "AnalyticsServer.h"
#import "NWVersionAds.h"
#import "NWVersionUpdate.h"
#import "ProjectHelper.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSLog(@"%@", NSHomeDirectory());
    
    //window init
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = COLOR_FFFFFF;
    
    //home vc
    HomeViewController *vc= [[HomeViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
    
    //init database
    [DataBaseServer createTable];
    
    //init bottomBar
    [self.window addSubview:self.playBottomBar];
    [self.playBottomBar appStartPlayModel];//开机播放
    
    //update
    [self updateVersion];
    
    //ads
    [self updateAds];
    
    //统计服务
    [AnalyticsServer startServer];
    
    return YES;
}

- (void)updateVersion {
    NWVersionUpdate *update = [[NWVersionUpdate alloc] init];
    [update setCompletion:^(VersionUpdateModel *model, BOOL succ) {
        if (succ) {
            [ProjectHelper updateVersion:model];
        }
    }];
    [update startRequestWithParams:nil];
}

- (void)updateAds {
    NWVersionAds *update = [[NWVersionAds alloc] init];
    [update setCompletion:^(VersionAdsModel *model, BOOL succ) {
        if (succ) {
            [ProjectHelper adsVersion:model];
        }
    }];
    [update startRequestWithParams:nil];
}

- (UIView *)playBottomBar {
    if (!_playBottomBar) {
        _playBottomBar = [[PlayBottomBarView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kPlayBottomBarHeight, kScreenWidth, kPlayBottomBarHeight)];
    }
    
    return _playBottomBar;
}

//重写父类方法，接受外部事件的处理
- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    [self.playBottomBar handleRemoteControlEvent:receivedEvent];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    //MBAudioPlayer是我为播放器写的单例，这段就是当音乐还在播放状态的时候，给后台权限，不在播放状态的时候，收回后台权限
    if (self.playBottomBar.audioPlayer.state == STKAudioPlayerStatePlaying||self.playBottomBar.audioPlayer.state == STKAudioPlayerStateBuffering||self.playBottomBar.audioPlayer.state == STKAudioPlayerStatePaused ||self.playBottomBar.audioPlayer.state == STKAudioPlayerStateStopped) {
        //有音乐播放时，才给后台权限，不做流氓应用。
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        [self becomeFirstResponder];
        //开启定时器
        [self.playBottomBar configNowPlayingInfoCenter];
    }
    else
    {
        [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
        [self resignFirstResponder];
    }
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
