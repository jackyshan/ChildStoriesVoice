//
//  PlayBottomBarView.m
//  ChildStoriesVoice
//
//  Created by jackyshan on 12/23/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "PlayBottomBarView.h"
#import "JackyBusiness.pch"
#import "DataBaseServer.h"
#import "BlockAlertView.h"
#import "PlayVoiceListVC.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PlayBottomBarView()<STKAudioPlayerDelegate> {
    VoiceDetailModel *_model;
    NSArray *_models;
}

@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIButton *moreActionBtn;

@property (nonatomic, strong) STKAudioPlayer *audioPlayer;

@property (nonatomic, strong) BlockAlertView *alertView;

@end

@implementation PlayBottomBarView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_211A15;
        
        [self addSubview:self.titleLb];
        [self addSubview:self.playBtn];
        [self addSubview:self.moreActionBtn];
        
        [self defineLayout];
        
        //后台播放音频设置
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
    
    return self;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [[UIButton alloc] init];
        _playBtn.backgroundColor = COLOR_CLEAR;
        [_playBtn setImage:[UIImage imageNamed:@"bottom_play_bar"]];
        [_playBtn setImage:[UIImage imageNamed:@"bottom_play_bar_selected"] forState:UIControlStateSelected];
        [_playBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        
        @weakify(self)
        [[_playBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
            x.selected = !x.selected;
            
            @strongify(self)
            if (x.selected) {
                [self.audioPlayer resume];
                
                if (self.audioPlayer.state == STKAudioPlayerStateStopped) {
                    [self playWithModel:self->_model andModels:_models];
                }
            }
            else {
                [self.audioPlayer pause];
            }
        }];
        
//        [RACObserve(self.audioPlayer, state) subscribeNext:^(NSNumber *state) {
//            @strongify(self)
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.playBtn.selected = state.integerValue == 3?YES:NO;
//            });
//            
//            self.titleLb.text = self->_model.title;
//        }];
    }
    
    return _playBtn;
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.backgroundColor = COLOR_CLEAR;
        _titleLb.textColor = COLOR_FFFFFF;
        _titleLb.font = [UIFont boldSystemFontOfSize:13.f];
        _titleLb.textAlignment = NSTextAlignmentCenter;
    }
    
    return _titleLb;
}

- (UIButton *)moreActionBtn {
    if (!_moreActionBtn) {
        _moreActionBtn = [[UIButton alloc] init];
        _moreActionBtn.backgroundColor = COLOR_CLEAR;
        [_moreActionBtn setTitleColor:COLOR_FFFFFF];
        [_moreActionBtn setTitle:@"..."];
        [_moreActionBtn addTarget:self action:@selector(alertView)];
    }
    
    return _moreActionBtn;
}

- (BlockAlertView *)alertView {
    VoiceDetailModel *model = (VoiceDetailModel *)self.audioPlayer.currentlyPlayingQueueItemId;
    if (model) {
        _alertView = [[BlockAlertView alloc] initWithTitle:model.title style:AlertStyleSheet];
        @weakify(self)
        [_alertView addTitle:@"播放列表" block:^(id result) {
            @strongify(self);
            PlayVoiceListVC *vc = [[PlayVoiceListVC alloc] init];
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
            
            [((UINavigationController *)self.window.rootViewController) presentViewController:navi animated:YES completion:nil];
        }];
        
        [_alertView addTitle:@"下载" block:^(id result) {
            //        @strongify(self);
            NSLog(@"download %@", model.title);
        }];
        
        if ([DataBaseServer checkLovedVoice:model]) {
            [_alertView addTitle:@"取消喜欢" block:^(id result) {
                [DataBaseServer deleteLovedVoice:model];
            }];
        }
        else {
            [_alertView addTitle:@"喜欢" block:^(id result) {
                [DataBaseServer insertLovedVoice:model];
            }];
        }
        
        [_alertView show];
    }
    
    return _alertView;
}

- (void)updateConstraints {
    [self defineLayout];
    [super updateConstraints];
}

- (void)defineLayout {
    [_playBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self);
        make.width.mas_equalTo(68);
        make.top.mas_equalTo(0);
    }];
    
    [_titleLb mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.top.mas_equalTo(0);
    }];
    
    [_moreActionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(0);
        make.width.mas_equalTo(23);
        make.height.equalTo(self);
    }];
}

- (STKAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        _audioPlayer = [[STKAudioPlayer alloc] initWithOptions:(STKAudioPlayerOptions){ .flushQueueOnSeek = YES, .enableVolumeMixer = NO, .equalizerBandFrequencies = {50, 100, 200, 400, 800, 1600, 2600, 16000} }];
        _audioPlayer.delegate = self;
    }
    
    return _audioPlayer;
}

#pragma mark - 播放
- (void)playWithModel:(VoiceDetailModel *)model andModels:(NSArray *)models {
    if (!model || !model.playUrl64 || model == _model) {
        return;
    }
    
    _model = model;
    [self.audioPlayer playURL:model.playUrl64 withQueueItemID:model];
    
    if (!models) {
        [DataBaseServer deletePlayVoiceList];
        [DataBaseServer insertPlayVoice:model];
        return;
    }
    
    if (_models != models) {//插入播放列表数据库
        [DataBaseServer deletePlayVoiceList];
        [models enumerateObjectsUsingBlock:^(VoiceDetailModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [DataBaseServer insertPlayVoice:obj];
        }];
        
        _models = models;
    }
    
    NSUInteger endIndex = models.count;
    NSUInteger startIndex = [models indexOfObject:model]+1;
    NSIndexSet *indexSet =  [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(startIndex, endIndex - startIndex)];
    NSArray *objecs = [models objectsAtIndexes:indexSet];
    [objecs enumerateObjectsUsingBlock:^(VoiceDetailModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.audioPlayer queueURL:obj.playUrl64 withQueueItemId:obj];
    }];
}

//开机启动播放
- (void)appStartPlayModel {
    NSArray *models = [DataBaseServer selectPlayVoiceList];
    if (models.count < 1) {
        return;
    }
    
    NSArray *lastedList = [DataBaseServer selectPlayVoiceLastedList];
    if (lastedList.count < 1) {
        return;
    }
    
    _models = models;
    
    VoiceDetailModel *model = lastedList[0];
    NSUInteger endIndex = models.count;
    __block NSUInteger startIndex;
    [models enumerateObjectsUsingBlock:^(VoiceDetailModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.trackId isEqualToString:model.trackId]) {
            startIndex = idx;
            *stop = YES;
        }
    }];
    
    if (endIndex < startIndex) {
        return;
    }
    
    NSIndexSet *indexSet =  [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(startIndex, endIndex - startIndex)];
    NSArray *objecs = [models objectsAtIndexes:indexSet];
    
    _model = objecs[0];
    //开机启动不操作数据库
//    [DataBaseServer deletePlayVoiceList];
    [objecs enumerateObjectsUsingBlock:^(VoiceDetailModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.audioPlayer queueURL:obj.playUrl64 withQueueItemId:obj];
//        [DataBaseServer insertPlayVoice:obj];
    }];
    
    [self.audioPlayer seekToTime:_model.progress.doubleValue];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self configNowPlayingInfoCenter];
}

#pragma mark - STKAudioPlayerDelegate
/// Raised when an item has started playing
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didStartPlayingQueueItemId:(VoiceDetailModel *)queueItemId {
    NSLog(@"didStartPlayingQueueItemId");
    
    self.titleLb.text = queueItemId.title;
    
    [DataBaseServer insertPlayVoiceLasted:queueItemId];//最近播放
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.audioPlayer seekToTime:self.audioPlayer.duration];
//    });
    
    queueItemId.playing = YES;
    _model = queueItemId;
}
/// Raised when an item has finished buffering (may or may not be the currently playing item)
/// This event may be raised multiple times for the same item if seek is invoked on the player
- (void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId {
    NSLog(@"didFinishBufferingSourceWithQueueItemId");
}
/// Raised when the state of the player has changed
- (void) audioPlayer:(STKAudioPlayer*)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState {
    NSLog(@"stateChanged");
    
    self.playBtn.selected = state == STKAudioPlayerStatePlaying ? YES : NO;
    VoiceDetailModel *model = (VoiceDetailModel *)audioPlayer.currentlyPlayingQueueItemId;
    model.progress = @(audioPlayer.progress).stringValue;
    [DataBaseServer insertPlayVoice:model];
}
/// Raised when an item has finished playing
- (void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(VoiceDetailModel *)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration {
    NSLog(@"didFinishPlayingQueueItemId");
    queueItemId.playing = NO;
}
/// Raised when an unexpected and possibly unrecoverable error has occured (usually best to recreate the STKAudioPlauyer)
- (void) audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode {
    NSLog(@"unexpectedError");
}

#pragma mark - 后台播放
//设置锁屏信息
- (void)configNowPlayingInfoCenter
{
    @autoreleasepool {
        VoiceDetailModel *info = _model;
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        //歌曲名称
        [dict setObject:info.title forKey:MPMediaItemPropertyTitle];
        
        //演唱者
        [dict setObject:@"儿童故事音汇" forKey:MPMediaItemPropertyArtist];
        
        //专辑名
        //[dict setObject:[info ObjectNullForKey:@"album"] forKey:MPMediaItemPropertyAlbumTitle];
        
        //音乐剩余时长
        [dict setObject:[NSNumber numberWithDouble:info.duration.doubleValue] forKey:MPMediaItemPropertyPlaybackDuration];
        
        //音乐当前播放时间 在计时器中修改
        [dict setObject:[NSNumber numberWithDouble:self.audioPlayer.progress] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        
        //专辑缩略图
        if (info.coverLarge != nil) {
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:info.coverLarge] options:SDWebImageDownloaderContinueInBackground progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                if (!image) {
                    NSLog(@"%@", error.localizedDescription);
                    return;
                }
                MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
                [dict setObject:artwork forKey:MPMediaItemPropertyArtwork];
                [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
            }];
            
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
        }
        else {
            //无图的时候，读取图...
            
            //设置锁屏状态下屏幕显示播放音乐信息
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
        }
        
    }
}

//响应远程音乐播放控制消息
- (void)handleRemoteControlEvent:(UIEvent *)receivedEvent {
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                //点击了播放
                [self.audioPlayer resume];
                break;
            case UIEventSubtypeRemoteControlPause:
                //点击了暂停
                [self.audioPlayer pause];
                break;
            case UIEventSubtypeRemoteControlStop:
                //点击了停止
                [self.audioPlayer stop];
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                //切换播放器app
                [self.audioPlayer pause];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                //点击了下一首
                [self playNextMusic];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                //点击了上一首
                [self playPreMusic];
                //此时需要更改歌曲信息
                break;
            default:
                break;
        }
        
        [self configNowPlayingInfoCenter];
    }
}

#pragma mark - 下一首上一首
- (void)playNextMusic {
    VoiceDetailModel *model = (VoiceDetailModel *)self.audioPlayer.currentlyPlayingQueueItemId;
    if (![_models containsObject:model] || [_models indexOfObject:model] >= _models.count-1) {
        return;
    }
    
    NSUInteger idx = [_models indexOfObject:model];
    [self playWithModel:_models[idx+1] andModels:_models];
}

- (void)playPreMusic {
    VoiceDetailModel *model = (VoiceDetailModel *)self.audioPlayer.currentlyPlayingQueueItemId;
    if (![_models containsObject:model] || [_models indexOfObject:model] <= 0) {
        return;
    }
    
    NSUInteger idx = [_models indexOfObject:model];
    [self playWithModel:_models[idx-1] andModels:_models];
}

@end
