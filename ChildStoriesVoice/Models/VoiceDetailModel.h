//
//  VoiceDetailModel.h
//  ChildStoriesVoice
//
//  Created by jackyshan on 12/18/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "BaseModel.h"

@interface VoiceDetailModel : BaseModel

@property (nonatomic, strong) NSString *trackId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *coverSmall;
@property (nonatomic, strong) NSString *coverLarge;
@property (nonatomic, strong) NSString *playtimes;
@property (nonatomic, strong) NSString *playUrl32;
@property (nonatomic, strong) NSString *playUrl64;
@property (nonatomic, strong) NSString *mp3size_32;
@property (nonatomic, strong) NSString *mp3size_64;
@property (nonatomic, strong) NSString *albumId;
@property (nonatomic, strong) NSString *albumUid;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *updatedAt;

@end
