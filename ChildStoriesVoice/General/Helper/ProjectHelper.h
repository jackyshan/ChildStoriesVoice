//
//  ProjectHelper.h
//  DBMeiziFuli
//
//  Created by jackyshan on 9/17/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VersionAdsModel.h"
#import "VersionUpdateModel.h"

@interface ProjectHelper : NSObject

+ (instancetype)shareInstance;

//vip设置
+ (void)setIAPVIP;
+ (BOOL)getIAPVIP;

//更新&广告
+ (void)updateVersion:(VersionUpdateModel *)model;
+ (void)adsVersion:(VersionAdsModel *)model;

//设置列表
+ (NSArray *)getSettingMenuModels;

//IAP
+ (void)buyIapProduct;
+ (void)restoreIapProduct;

//goto appstore url
+ (void)gotoAppStore;

//clear disk cache
+ (void)clearDiskCache;

//report
- (void)reportBugForEmail;

//推荐搜索
+ (NSArray *)getSearchRecommend;

@end
