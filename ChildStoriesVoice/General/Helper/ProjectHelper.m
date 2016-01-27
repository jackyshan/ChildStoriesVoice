//
//  ProjectHelper.m
//  DBMeiziFuli
//
//  Created by jackyshan on 9/17/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "ProjectHelper.h"
#import "ProjectMacro.h"
#import "CommonHelper.h"
#import "BlockAlertView.h"
#import "JackyBusiness.pch"
#import "SettingModel.h"
#import "MBProgressHUD.h"
#import "IAPHelper.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
#import "SearchModel.h"

#define windowView [UIApplication sharedApplication].keyWindow

@interface ProjectHelper()<MFMailComposeViewControllerDelegate>

@end

@implementation ProjectHelper

+ (instancetype)shareInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

+ (BOOL)getIAPVIP {
    NSNumber *VIP = [[NSUserDefaults standardUserDefaults] objectForKey:IAPIdentifier];
    
    return VIP.boolValue;
}

+ (void)setIAPVIP {
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:IAPIdentifier];
    
    [CommonHelper showMessage:@"升级VIP成功"];
}

static BlockAlertView *update = nil;
+ (void)updateVersion:(VersionUpdateModel *)model {
    if (!model.active) {
        return;
    }
    
    if ([model.newestVersion compare:XcodeAppVersion] == NSOrderedDescending) {
        BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:model.title];
        alert.alertMessage = model.message;
        if (!model.mustUpdate) {
            [alert addTitle:@"取消" block:nil];
        }
        
        [alert addTitle:@"好的" block:^(id result) {
            [[UIApplication sharedApplication] openURL:model.url];
        }];
        
        [alert show];
        update = alert;
    }
}

static BlockAlertView *ads = nil;
+ (void)adsVersion:(VersionAdsModel *)model {
    if (model.active) {
        BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:model.title];
        alert.alertMessage = model.message;
        [alert addTitle:@"取消" block:nil];
        [alert addTitle:@"好的" block:^(id result) {
            [[UIApplication sharedApplication] openURL:model.url];
        }];
        [alert show];
        ads = alert;
    }
}

+ (NSArray *)getSettingMenuModels {
    NSString *cacheSize = [CommonHelper getFileSizeString:@([[SDImageCache sharedImageCache] getSize]).stringValue];
    NSArray *music = @[@{@"img":@"", @"title":@"播放列表", @"detailTitle":@"", @"type":@"0"},
                       @{@"img":@"", @"title":@"最近播放", @"detailTitle":@"", @"type":@"1"},
//                       @{@"img":@"", @"title":@"下载音乐", @"detailTitle":@"", @"type":@"2"},
                       @{@"img":@"", @"title":@"喜欢的音乐", @"detailTitle":@"", @"type":@"3"},
                       @{@"img":@"", @"title":@"收藏专辑", @"detailTitle":@"", @"type":@"4"}];
    NSArray *vip = @[@{@"img":@"", @"title":@"升级VIP", @"detailTitle":@"终身会员", @"type":@"5"},
                     @{@"img":@"", @"title":@"恢复VIP", @"detailTitle":@"", @"type":@"6"}];
    NSArray *setting = @[@{@"img":@"", @"title":@"评价", @"detailTitle":@"", @"type":@"7"},
                         @{@"img":@"", @"title":@"清除缓存", @"detailTitle":cacheSize, @"type":@"8"},
                         @{@"img":@"", @"title":@"反馈", @"detailTitle":@"邮件", @"type":@"9"},
//                         @{@"img":@"", @"title":@"版本", @"detailTitle":XcodeAppVersion, @"type":@"10"}
                         ];
    
    NSArray *arr = @[@{@"name":@"音乐", @"list":music},
                     @{@"name":@"vip", @"list":vip},
                     @{@"name":@"设置", @"list":setting}];
    
    return [SettingModel arrayOfModelsFromDictionaries:arr];
}

//IAP
static BlockAlertView *iapAlert = nil;
+ (void)buyIapProduct {
    if ([ProjectHelper getIAPVIP]) {
        [CommonHelper showMessage:@"已是VIP"];
        return;
    }
    
    BlockAlertView *_alertView = [[BlockAlertView alloc] initWithTitle:@"升级VIP"];
    _alertView.alertMessage = VIP_MESSAGE;
    [_alertView addTitle:@"取消" block:nil];
    [_alertView addTitle:@"确定" block:^(id result) {
        [MBProgressHUD showHUDAddedTo:windowView animated:YES];
        [[IAPHelper sharedHelper] buyIapProduct:IAPIdentifier iapBlock:^(id result, BOOL succ) {
            [MBProgressHUD hideAllHUDsForView:windowView animated:YES];
            if (succ) {
                [ProjectHelper setIAPVIP];
            }
            else {
                [CommonHelper showMessage:nil message:result];
            }
        }];
    }];
    
    [_alertView show];
    iapAlert = _alertView;
}
+ (void)restoreIapProduct {
    if ([ProjectHelper getIAPVIP]) {
        [CommonHelper showMessage:@"已是VIP"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:windowView animated:YES];
    [[IAPHelper sharedHelper] restoreProductIdentifier:IAPIdentifier iapBlock:^(id result, BOOL succ) {
        [MBProgressHUD hideAllHUDsForView:windowView animated:YES];
        if (succ) {
            [ProjectHelper setIAPVIP];
        }
        else {
            [CommonHelper showMessage:nil message:result];
        }
    }];
}

//goto appstore url
+ (void)gotoAppStore {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreUrl]];
}

//clear disk cache
+ (void)clearDiskCache {
    [MBProgressHUD showHUDAddedTo:windowView animated:YES];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        [MBProgressHUD hideAllHUDsForView:windowView animated:YES];
        [CommonHelper showMessage:@"清理完成"];
    }];
}

//report
- (void)reportBugForEmail {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    picker.view.tintColor = COLOR_B1;
    [picker setSubject:[NSString stringWithFormat:@"%@App的bug反馈", kAppTitle]];
    
    [picker setMessageBody:[NSString stringWithFormat:@"\n\n\n\n\n\n版本:%@\niPhone:%@", XcodeAppVersion, kiOSVersion] isHTML:NO];
    [picker setToRecipients:@[[NSString stringWithFormat:@"%@App邮箱 <bugsformyapps@163.com>", kAppTitle]]];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [(UINavigationController *)delegate.window.rootViewController presentViewController:picker animated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error {
    if (error) {
        NSLog(@"邮件分享错误：%@", error.localizedDescription);
    }
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [(UINavigationController *)delegate.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

//推荐搜索
+ (NSArray *)getSearchRecommend {
    NSArray *arr = @[@{@"title":@"全部"},
                     @{@"title":@"儿歌大全"},
                     @{@"title":@"睡前故事"},
                     @{@"title":@"胎教母婴"},
                     @{@"title":@"童话故事"},
                     @{@"title":@"儿童读物"},
                     @{@"title":@"儿童学习"},
                     @{@"title":@"儿童英语"},
                     @{@"title":@"儿童科普"},
                     @{@"title":@"儿童教育"},
                     @{@"title":@"影视动漫"},
                     @{@"title":@"绘本故事"},
                     @{@"title":@"宝贝SHOW"},
                     @{@"title":@"中小学教材"}];
    
    return [SearchModel arrayOfModelsFromDictionaries:arr];
}

@end
