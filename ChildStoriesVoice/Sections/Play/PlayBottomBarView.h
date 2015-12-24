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

- (void)playWithModel:(VoiceDetailModel *)model andModels:(NSArray *)models;

@end
