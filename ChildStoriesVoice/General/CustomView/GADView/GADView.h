//
//  GADView.h
//  JackyBusiness
//
//  Created by jackyshan on 9/24/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface GADView : UIView<GADBannerViewDelegate>

@property (nonatomic, copy) void(^loadedAd)();

- (instancetype)init:(CGSize)size adUnitID:(NSString *)adUnitID root:(UIViewController *)root;

@end
