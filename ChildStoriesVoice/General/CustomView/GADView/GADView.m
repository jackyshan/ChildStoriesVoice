//
//  GADView.m
//  JackyBusiness
//
//  Created by jackyshan on 9/24/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "GADView.h"

@interface GADView() {
    BOOL _loadCount;
}

@end

@implementation GADView

- (instancetype)init:(CGSize)size adUnitID:(NSString *)adUnitID root:(UIViewController *)root{
    if (self = [super init]) {
        NSLog(@"Google Mobile Ads SDK version: %@", [GADRequest sdkVersion]);
        GADBannerView *bannerView = [[GADBannerView alloc] initWithAdSize:GADAdSizeFromCGSize(size)];
        bannerView.adUnitID = adUnitID;
        bannerView.delegate = self;
        bannerView.backgroundColor = [UIColor whiteColor];
        bannerView.rootViewController = root;
//        GADRequest *request = [GADRequest request];
//        request.testDevices = @[@"7e74ee199610b2ef2766fbcfefd3929b"];
        [bannerView loadRequest:[GADRequest request]];
        [self addSubview:bannerView];
    }
    
    return self;
}


#pragma mark - GADBannerViewDelegate
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    if (!self.loadedAd || _loadCount) {
        return;
    }
    
    self.loadedAd();
    
    _loadCount = 1;
}

@end
