//
//  VoiceDetailModel.m
//  ChildStoriesVoice
//
//  Created by jackyshan on 12/18/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "VoiceDetailModel.h"

@implementation VoiceDetailModel

- (NSString *)playtime {
    return @([NSDate date].timeIntervalSince1970).stringValue;
}

@end
