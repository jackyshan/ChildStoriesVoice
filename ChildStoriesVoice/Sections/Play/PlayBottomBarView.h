//
//  PlayBottomBarView.h
//  ChildStoriesVoice
//
//  Created by jackyshan on 12/23/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceDetailModel.h"
#import "STKAudioPlayer.h"

@interface PlayBottomBarView : UIView

@property (nonatomic, readonly) STKAudioPlayer *audioPlayer;

//播放
- (void)playWithModel:(VoiceDetailModel *)model andModels:(NSArray *)models;

//开机启动播放
- (void)appStartPlayModel;

//重写父类方法，接受外部事件的处理
- (void)handleRemoteControlEvent:(UIEvent *)receivedEvent;
//设置锁屏状态，显示的歌曲信息
- (void)configNowPlayingInfoCenter;

@end
