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

//debug && release
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

//google ads
#define ADUNITID @"ca-app-pub-1989497899333594/9510635863"

#define kAppTitle @"儿童故事音汇"

//app store api
#define kAppStoreUrl @"https://itunes.apple.com/app/mei-zi-fu-li-tu/id1063741604"

//umeng && share_wechat..
#define sUMAppKey @"56050580e0f55a64ba0011a7"
#define sChannelId @"appStore"

//palybottombar height
#define kPlayBottomBarHeight 44

// IAP Identifier
#define IAPIdentifier @"com.jackyshan.meizifuli.iap"
#define VIP_MESSAGE @"升级VIP后\n\n可观看成人、热点项目\n\n下载图片到手机上\n分享图片给微信朋友\n\n以后还会有更多VIP功能"

// 免责声明
#define DISCLAIMER_MESSAGE @"本应用所有图片均为本站从互联网上搜集、整理、加工而来，除特别注明的内容之外，本应用不申明以上全部内容的著作权与所有权。我们对上载文件的内容不承担任何责任，也不表示与这些图像有任何的从属关系。\n\n如果您认为您的作品被复制而构成版权侵权，或您的知识产权被侵犯，请第一时间通知我们，并提供一下信息，我们将撤下侵权内容。\n\n1、您的姓名，地址，联系电话和电子邮件地址。\n2、足够详细的鉴定材料以证明，您的版权受到侵犯。\n3、您的签名。\n\n提交此报告即声明，您有充分的理由证明，图片的使用未经版权拥有者，其代理人或法律的授权。您还声明，（一）上述报告中的信息是真实准确的，以及（二）您是版权利益的所有者，或者您已获得授权代表该拥有人，否则即作为伪证罪处理。"

//menu offset
#define kPortraitSlideOffset 160.f

//menu models
#define kSelectMenuModel @"selectMenuModel"

//menu open
#define kLeftMenuOpen @"leftMenuOpen"

// 字体
#define ZT_DFSHAONV @"DFShaoNvW5"
#define ZT_FANGYUAN @"DFFangYuanW7"

#endif /* ProjectMacro_h */
