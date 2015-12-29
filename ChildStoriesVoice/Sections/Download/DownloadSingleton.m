//
//  DownloadSingleton.m
//  ChildStoriesVoice
//
//  Created by jackyshan on 12/29/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "DownloadSingleton.h"
#import "DataBaseServer.h"
#import "CommonHelper.h"
#import "NWDownLoad.h"

@interface DownloadSingleton()

@property (nonatomic, strong) NSMutableArray *downloadQueue;

@end

@implementation DownloadSingleton

+ (instancetype)shareInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (NSMutableArray *)downloadQueue {
    if (!_downloadQueue) {
        _downloadQueue = [NSMutableArray array];
    }
    
    return _downloadQueue;
}

- (void)queue:(id)object {
    [self.downloadQueue addObject:object];
    
    [self runQueue:object];
}

- (void)remove:(id)object {
    [(NWDownLoad *)object cancel];
    
    if ([self downloadQueue].count > 1) {
        [self runQueue:[self downloadQueue][1]];
    }
    
    [self.downloadQueue removeObject:object];
}

- (void)clearQueue {
    [self.downloadQueue removeAllObjects];
}

- (void)runQueue:(id)object {
    __block BOOL downIng = NO;
    [self.downloadQueue enumerateObjectsUsingBlock:^(NWDownLoad *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.model.downIng) {
            downIng = YES;
            *stop = YES;
        }
    }];
    
    if (!downIng) {//没有正在下载的项目，当前下载
        [(NWDownLoad *)object startRequest];
    }
}

+ (void)insertDownloadModel:(VoiceDetailModel *)model {
    if (!model || !model.playUrl64) {
        return;
    }
    
    if ([DataBaseServer insertDownload:model]) {
        [CommonHelper showMessage:@"已经下载"];
        return;
    }
    
    NWDownLoad *downLoad = [[NWDownLoad alloc] initWithModel:model];
    [[DownloadSingleton shareInstance] queue:downLoad];
}

+ (void)startDownloadModel:(VoiceDetailModel *)model {
    if (!model || !model.playUrl64 || [[[DownloadSingleton shareInstance] downloadQueue] containsObject:model]) {
        return;
    }
    
    NWDownLoad *downLoad = [[NWDownLoad alloc] initWithModel:model];
    [[DownloadSingleton shareInstance] queue:downLoad];
}

@end
