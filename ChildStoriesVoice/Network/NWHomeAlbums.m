//
//  NWHomeAlbums.m
//  ChildStoriesVoice
//
//  Created by jackyshan on 12/18/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "NWHomeAlbums.h"
#import "AlbumVoiceModel.h"

@implementation NWHomeAlbums

- (void)startRequestWithParams:(NSDictionary *)params {
    _params = params;
    [self startGet];
}

- (void)dealComplete:(id)result succ:(BOOL)succ {
    if (succ) {
        NSArray *arr = [AlbumVoiceModel arrayOfModelsFromDictionaries:result[@"list"]];
        self.completion(arr, YES);
    }
    else {
        self.completion(result, NO);
    }
}

@end
