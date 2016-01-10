//
//  NWDownLoad.m
//  ChildStoriesVoice
//
//  Created by jackyshan on 12/29/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "NWDownLoad.h"
#import "VoiceDetailModel.h"
#import "MKNetworkEngine.h"
#import "DownloadSingleton.h"
#import "DataBaseServer.h"

@interface NWDownLoad() {
    NSTimer *_timer; //定时器每隔1秒保存当前进度
}

@property (nonatomic, strong) VoiceDetailModel *model;

@end

@implementation NWDownLoad

- (instancetype)initWithModel:(VoiceDetailModel *)model {
    if (self = [super init]) {
        _model = model;
        _fileSavePath = model.savePath;
        _path = model.playUrl64.absoluteString;
        _flag = NWFlagNone;
        _fileDownload = YES;
        _breakResume = YES;
    }
    
    return self;
}

- (void)startRequest {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    
    _model.downIng = YES;
    
    [self startGet];
}

- (void)dealComplete:(NSNumber *)result succ:(BOOL)succ {
    if ([result isKindOfClass:[NSNumber class]]) {
        _model.downloadProgress = result.floatValue;
        if (self.completion) {
            self.completion(result, succ);
        }
    }
    
    if (succ) {
        [_timer invalidate];//完成之后计时器停止,progress直接设置为1
        _timer = nil;
        _model.downloadProgress = 1.f;
        [DataBaseServer updateDownload:_model];
        [[DownloadSingleton shareInstance] remove:self];
    }
}

- (void)updateProgress {
    [DataBaseServer updateDownload:_model];
}

- (BOOL)downing {
    return _model.downIng;
}

- (void)cancel
{
    [_timer invalidate];
    _timer = nil;
    _model.downIng = NO;
    [MKNetworkEngine cancelOperationsContainingURLString:_path];
}

@end
