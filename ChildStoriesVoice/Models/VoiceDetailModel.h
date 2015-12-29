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
@property (nonatomic, strong) NSURL *playUrl32;
@property (nonatomic, strong) NSURL *playUrl64;
@property (nonatomic, strong) NSString *mp3size_32;
@property (nonatomic, strong) NSString *mp3size_64;
@property (nonatomic, strong) NSString *albumId;
@property (nonatomic, strong) NSString *albumUid;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *updatedAt;

//system
@property (nonatomic, assign) BOOL playing;

//database
@property (nonatomic, strong) NSString *savePath;
@property (nonatomic, strong) NSString *progress; //播放进度
@property (nonatomic, strong) NSString *playtime;
@property (nonatomic, assign) BOOL downIng;//正在下载
@property (nonatomic, assign) CGFloat downloadProgress; //下载进度
@property (nonatomic, assign) BOOL finished;

@end
