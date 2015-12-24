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

@interface PlayBottomBarView()<STKAudioPlayerDelegate> {
    VoiceDetailModel *_model;
    NSArray *_models;
}

@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UILabel *titleLb;

@property (nonatomic, strong) STKAudioPlayer *audioPlayer;

@end

@implementation PlayBottomBarView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_211A15;
        
        [self addSubview:self.titleLb];
        [self addSubview:self.playBtn];
        
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
}

- (STKAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        _audioPlayer = [[STKAudioPlayer alloc] initWithOptions:(STKAudioPlayerOptions){ .flushQueueOnSeek = YES, .enableVolumeMixer = NO, .equalizerBandFrequencies = {50, 100, 200, 400, 800, 1600, 2600, 16000} }];
        _audioPlayer.delegate = self;
    }
    
    return _audioPlayer;
}

- (void)playWithModel:(VoiceDetailModel *)model andModels:(NSArray *)models {
    _model = model;
    
    //播放
    [self.audioPlayer playURL:model.playUrl64 withQueueItemID:model];
    
    //队列
    _models = models;
    [self.audioPlayer clearQueue];
    NSUInteger endIndex = models.count;
    NSUInteger startIndex = [models indexOfObject:model];
    NSIndexSet *indexSet =  [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(startIndex, endIndex - startIndex)];
    [models enumerateObjectsAtIndexes:indexSet options:NSEnumerationConcurrent usingBlock:^(VoiceDetailModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.audioPlayer queueURL:obj.playUrl64 withQueueItemId:obj];
    }];
}

#pragma mark - STKAudioPlayerDelegate
/// Raised when an item has started playing
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didStartPlayingQueueItemId:(VoiceDetailModel *)queueItemId {
    NSLog(@"didStartPlayingQueueItemId");
    
    self.titleLb.text = queueItemId.title;
    
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
