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

@interface PlayBottomBarView()

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
        
        [[_playBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
            x.selected = !x.selected;
        }];
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
    }
    
    return _audioPlayer;
}

- (void)playWithModel:(VoiceDetailModel *)model {
    [self.audioPlayer play:model.playUrl64];
}

@end
