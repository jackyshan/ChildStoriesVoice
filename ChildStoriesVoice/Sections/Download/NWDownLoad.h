//
//  NWDownLoad.h
//  ChildStoriesVoice
//
//  Created by jackyshan on 12/29/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "BaseNetwork.h"

@class VoiceDetailModel;
@interface NWDownLoad : BaseNetwork

@property (nonatomic, readonly) VoiceDetailModel *model;

- (instancetype)initWithModel:(VoiceDetailModel *)model;
- (BOOL)downing;

@end
