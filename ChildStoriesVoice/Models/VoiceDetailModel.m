//
//  VoiceDetailModel.m
//  ChildStoriesVoice
//
//  Created by jackyshan on 12/18/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "VoiceDetailModel.h"
#import "CommonHelper.h"

@implementation VoiceDetailModel

- (NSString *)playtime {
    return @([NSDate date].timeIntervalSince1970).stringValue;
}

- (NSString *)savePath {
    if (!_savePath) {
        _savePath = [CommonHelper getDownloadRelativePath:[NSString stringWithFormat:@"%@.mp3", self.title]];
    }
    
    return _savePath;
}

- (NSURL *)playRealUrl {
    if (self.finished) {
        return [NSURL fileURLWithPath:[CommonHelper getDownloadSavePath:self.savePath]];
    }
    else {
        return _playUrl64;
    }
}

@end
