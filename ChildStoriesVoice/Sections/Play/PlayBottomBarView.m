//
//  PlayBottomBarView.m
//  ChildStoriesVoice
//
//  Created by jackyshan on 12/23/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "PlayBottomBarView.h"
#import "JackyBusiness.pch"
#import "STKAudioPlayer.h"
#import "DataBaseServer.h"
#import "BlockAlertView.h"
#import "PlayVoiceListVC.h"

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

- (void)playWithModel:(VoiceDetailModel *)model andModels:(NSArray *)models {
    if (!model || !model.playUrl64) {
        return;
    }
    
    _model = model;
    [self.audioPlayer playURL:model.playUrl64 withQueueItemID:model];
    
    //database
    [DataBaseServer deletePlayVoiceList];
    [DataBaseServer insertPlayVoice:model];
    
    if (!models) {
        return;
    }
    
    _models = models;
    NSUInteger endIndex = models.count;
    NSUInteger startIndex = [models indexOfObject:model]+1;
    NSIndexSet *indexSet =  [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(startIndex, endIndex - startIndex)];
    NSArray *objecs = [models objectsAtIndexes:indexSet];
    [objecs enumerateObjectsUsingBlock:^(VoiceDetailModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.audioPlayer queueURL:obj.playUrl64 withQueueItemId:obj];
        [DataBaseServer insertPlayVoice:obj];
    }];
}

- (void)appStartPlayModel {
    NSArray *models = [DataBaseServer selectPlayVoiceList];
    
    if (models.count < 1) {
        return;
    }
    
    NSArray *lastedList = [DataBaseServer selectPlayVoiceLastedList];
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
    _models = objecs;
    [DataBaseServer deletePlayVoiceList];
    [objecs enumerateObjectsUsingBlock:^(VoiceDetailModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.audioPlayer queueURL:obj.playUrl64 withQueueItemId:obj];
        [DataBaseServer insertPlayVoice:obj];
    }];
    
    [self.audioPlayer seekToTime:_model.progress.doubleValue];
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
}
/// Raised when an item has finished buffering (may or may not be the currently playing item)
/// This event may be raised multiple times for the same item if seek is invoked on the player
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId {
    NSLog(@"didFinishBufferingSourceWithQueueItemId");
}
/// Raised when the state of the player has changed
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState {
    NSLog(@"stateChanged");
    
    self.playBtn.selected = state == STKAudioPlayerStatePlaying ? YES : NO;
    VoiceDetailModel *model = (VoiceDetailModel *)audioPlayer.currentlyPlayingQueueItemId;
    model.progress = @(audioPlayer.progress).stringValue;
    [DataBaseServer insertPlayVoice:model];
}
/// Raised when an item has finished playing
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(VoiceDetailModel *)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration {
    NSLog(@"didFinishPlayingQueueItemId");
    queueItemId.playing = NO;
}
/// Raised when an unexpected and possibly unrecoverable error has occured (usually best to recreate the STKAudioPlauyer)
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode {
    NSLog(@"unexpectedError");
}

@end
