//
//  NWVersionUpdate.m
//  DBMeiziFuli
//
//  Created by jackyshan on 9/25/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "NWVersionUpdate.h"

@implementation NWVersionUpdate

- (void)startRequestWithParams:(NSDictionary *)params {
    _params = params;
    _path = @"childstoriesvoice/app/version/update";
    _serverType = ServerTypeTest;
    [self startPost];
}

- (void)dealComplete:(id)result succ:(BOOL)succ {
    if (succ) {
        VersionUpdateModel *model = [[VersionUpdateModel alloc] initWithDictionary:result error:nil];
        self.completion(model, YES);
    }
    else {
        self.completion(result, NO);
    }
}

@end
