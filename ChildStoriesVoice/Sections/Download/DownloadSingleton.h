//
//  DownloadSingleton.h
//  ChildStoriesVoice
//
//  Created by jackyshan on 12/29/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VoiceDetailModel;
@interface DownloadSingleton : NSObject

@property (nonatomic, readonly) NSMutableArray *downloadQueue;

+ (instancetype)shareInstance;
+ (void)insertDownloadModel:(VoiceDetailModel *)model;
+ (void)startDownloadModel:(VoiceDetailModel *)model;

- (void)remove:(id)object;
- (void)clearQueue;

@end
