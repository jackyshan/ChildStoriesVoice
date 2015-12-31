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

#define windowView [UIApplication sharedApplication].keyWindow

@interface ProjectHelper()<MFMailComposeViewControllerDelegate>

@end

@implementation ProjectHelper

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
    NSArray *music = @[@{@"img":@"", @"title":@"播放列表", @"detailTitle":@"", @"type":@"0"},
                       @{@"img":@"", @"title":@"最近播放", @"detailTitle":@"", @"type":@"1"},
                       @{@"img":@"", @"title":@"下载音乐", @"detailTitle":@"", @"type":@"2"},
                       @{@"img":@"", @"title":@"喜欢的音乐", @"detailTitle":@"", @"type":@"3"},
                       @{@"img":@"", @"title":@"收藏专辑", @"detailTitle":@"", @"type":@"4"}];
    NSArray *vip = @[@{@"img":@"", @"title":@"升级VIP", @"detailTitle":@"", @"type":@"5"},
                     @{@"img":@"", @"title":@"恢复VIP", @"detailTitle":@"", @"type":@"6"}];
    NSArray *setting = @[@{@"img":@"", @"title":@"评价", @"detailTitle":@"", @"type":@"7"},
                         @{@"img":@"", @"title":@"清除缓存", @"detailTitle":@"", @"type":@"8"},
                         @{@"img":@"", @"title":@"反馈", @"detailTitle":@"邮件", @"type":@"9"},
                         @{@"img":@"", @"title":@"版本", @"detailTitle":XcodeAppVersion, @"type":@"10"}];
    
    NSArray *arr = @[@{@"name":@"音乐", @"list":music},
                     @{@"name":@"vip", @"list":vip},
                     @{@"name":@"设置", @"list":setting}];
    
    return [SettingModel arrayOfModelsFromDictionaries:arr];
}

//IAP
+ (void)buyIapProduct {
    if ([ProjectHelper getIAPVIP]) {
        [CommonHelper showMessage:@"已是VIP"];
        return;
    }
    
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
+ (void)reportBugForEmail {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    picker.view.tintColor = COLOR_FFFFFF;
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

@end
