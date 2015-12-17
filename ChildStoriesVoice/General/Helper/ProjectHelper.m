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

@end
