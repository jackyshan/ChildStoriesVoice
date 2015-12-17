//
//  GADView.m
//  JackyBusiness
//
//  Created by jackyshan on 9/24/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "GADView.h"

@implementation GADView

- (instancetype)init:(CGSize)size adUnitID:(NSString *)adUnitID root:(UIViewController *)root{
    if (self = [super init]) {
        NSLog(@"Google Mobile Ads SDK version: %@", [GADRequest sdkVersion]);
        GADBannerView *bannerView = [[GADBannerView alloc] initWithAdSize:GADAdSizeFromCGSize(size)];
        bannerView.adUnitID = adUnitID;
        bannerView.delegate = self;
        bannerView.backgroundColor = [UIColor whiteColor];
        bannerView.rootViewController = root;
        [bannerView loadRequest:[GADRequest request]];
        [self addSubview:bannerView];
    }
    
    return self;
}


NSInteger loadCount = 0;
#pragma mark - GADBannerViewDelegate
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    if (!self.loadedAd || loadCount) {
        return;
    }
    
    self.loadedAd();
    
    loadCount = 1;
}

@end
