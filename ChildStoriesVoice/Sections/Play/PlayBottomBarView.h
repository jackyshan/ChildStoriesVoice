//
//  PlayBottomBarView.h
//  ChildStoriesVoice
//
//  Created by jackyshan on 12/23/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceDetailModel.h"

@interface PlayBottomBarView : UIView

//播放
- (void)playWithModel:(VoiceDetailModel *)model andModels:(NSArray *)models;

//开机启动播放
- (void)appStartPlayModel;

@end
