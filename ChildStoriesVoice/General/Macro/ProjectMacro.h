//
//  ProjectMacro.h
//  DBMeiziFuli
//
//  Created by jackyshan on 9/14/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#ifndef ProjectMacro_h
#define ProjectMacro_h

//domain
#define ProjectDomain @"ProjectDomain"

#define DevelopmentDomain @"192.168.0.135:5000"
#define TestDomain @"192.168.1.108:5000"
#define ProductionDomain @"app.9nali.com"

//#define PackageDomain DevelopmentDomain
//#define PackageDomain TestDomain
#define PackageDomain ProductionDomain

#undef bLogSwitch
#undef kSendLog
#undef bCatchCrash
#ifdef DEBUG
#define bCatchCrash NO
#define bLogSwitch YES
#define kSendLog REALTIME
#else
#define bCatchCrash YES
#define bLogSwitch NO
#define kSendLog SEND_ON_EXIT
#define NSLog(...) {}
#endif

#define kAppTitle @"儿童故事音汇"

//google ads
#define ADUNITID @"ca-app-pub-1989497899333594/2012216265"

//app store api
#define kAppStoreUrl @"https://itunes.apple.com/app/er-tong-gu-shi-yin-hui/id1071658144"

//umeng && share_wechat..
#define sUMAppKey @"568f5f5b67e58e0843000f2c"
#define sChannelId @"appStore"

//palybottombar height
#define kPlayBottomBarHeight 44

// IAP Identifier
#define IAPIdentifier @"com.jackyshan.ChildStoriesVoice.iap.vip"
#define VIP_MESSAGE @"升级VIP后\n\n可享受终身vip\n\n体验搜索功能\n\n以后还会有更多VIP功能"

//menu models
#define kSelectMenuModel @"selectMenuModel"

#endif /* ProjectMacro_h */
