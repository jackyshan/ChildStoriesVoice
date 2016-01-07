//
//  NWAlbumDetails.m
//  ChildStoriesVoice
//
//  Created by jackyshan on 12/18/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "NWAlbumDetails.h"
#import "VoiceDetailModel.h"

@implementation NWAlbumDetails

- (void)startRequestWithParams:(NSDictionary *)params {
    _params = params;
    [self startGet];
}

- (void)dealComplete:(id)result succ:(BOOL)succ {
    if (succ) {
        self.completion(result, YES);
    }
    else {
        self.completion(result, NO);
    }
}

@end
