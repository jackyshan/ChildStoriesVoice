//
//  NWVersionAds.m
//  DBMeiziFuli
//
//  Created by jackyshan on 9/25/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "NWVersionAds.h"

@implementation NWVersionAds

- (void)startRequestWithParams:(NSDictionary *)params {
    _params = params;
    _path = @"childstoriesvoice/app/version/ads";
    _serverType = ServerTypeTest;
    [self startPost];
}

- (void)dealComplete:(id)result succ:(BOOL)succ {
    if (succ) {
        VersionAdsModel *model = [[VersionAdsModel alloc] initWithDictionary:result error:nil];
        self.completion(model, YES);
    }
    else {
        self.completion(result, NO);
    }
}

@end
