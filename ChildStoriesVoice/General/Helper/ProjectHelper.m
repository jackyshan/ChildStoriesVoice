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
#import "Macro.h"
#import "SettingModel.h"

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
                       @{@"img":@"", @"title":@"收藏专辑", @"detailTitle":@"", @"type":@"3"},
                       @{@"img":@"", @"title":@"喜欢的音乐", @"detailTitle":@"", @"type":@"4"}];
    NSArray *vip = @[@{@"img":@"", @"title":@"升级VIP", @"detailTitle":@"", @"type":@"0"},
                     @{@"img":@"", @"title":@"恢复VIP", @"detailTitle":@"", @"type":@"1"}];
    NSArray *setting = @[@{@"img":@"", @"title":@"评价", @"detailTitle":@"", @"type":@"0"},
                         @{@"img":@"", @"title":@"清除缓存", @"detailTitle":@"", @"type":@"1"},
                         @{@"img":@"", @"title":@"反馈", @"detailTitle":@"邮件", @"type":@"2"},
                         @{@"img":@"", @"title":@"版本", @"detailTitle":XcodeAppVersion, @"type":@"3"}];
    
    NSArray *arr = @[@{@"name":@"音乐", @"list":music},
                     @{@"name":@"vip", @"list":vip},
                     @{@"name":@"设置", @"list":setting}];
    
    return [SettingModel arrayOfModelsFromDictionaries:arr];
}

@end
