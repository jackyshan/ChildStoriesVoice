//
//  NWSuggestSearch.m
//  ChildStoriesVoice
//
//  Created by jackyshan on 1/6/16.
//  Copyright © 2016 jackyshan. All rights reserved.
//

#import "NWSuggestSearch.h"
#import "AlbumVoiceModel.h"
#import "SearchModel.h"

@implementation NWSuggestSearch

- (void)startRequestWithParams:(NSDictionary *)params {
    _params = params;
    self.path = @"search/948/album_suggest";
    
    [self startGet];
}

- (void)dealComplete:(id)result succ:(BOOL)succ {
    if (succ) {
        NSArray *arr = [SearchModel arrayOfModelsFromDictionaries:result[@"list"]];
        self.completion(arr, YES);
    }
    else {
        self.completion(result, NO);
    }
}

@end
