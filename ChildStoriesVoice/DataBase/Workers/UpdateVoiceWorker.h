//
//  UpdateVoiceWorker.h
//  ChildStoriesVoice
//
//  Created by apple on 12/26/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "DatabaseWorker.h"
#import "VoiceDetailModel.h"
#import "AlbumVoiceModel.h"

@interface UpdateVoiceWorker : DatabaseWorker

//播放列表,插入,查询
- (instancetype)initDeletePlayVoiceList;
- (instancetype)initInsertPlayVoice:(VoiceDetailModel *)model;
- (instancetype)initSelectPlayVoiceList;

//最近播放列表,插入,查询
- (instancetype)initInsertPlayVoiceLasted:(VoiceDetailModel *)model;
- (instancetype)initSelectPlayVoiceLastedList;
- (instancetype)initDeletePlayVoiceLastedList;
- (instancetype)initDeletePlayVoiceLasted:(VoiceDetailModel *)model;

//下载音乐
- (instancetype)initInsertDownload:(VoiceDetailModel *)model;
- (instancetype)initUpdateDownload:(VoiceDetailModel *)model;
- (instancetype)initSelectDownloadList:(BOOL)finished;

//喜欢音乐
- (instancetype)initInsertLovedVoice:(VoiceDetailModel *)model;
- (instancetype)initSelectLovedVoiceList;
- (instancetype)initCheckLovedVoice:(VoiceDetailModel *)model;
- (instancetype)initDeleteLovedVoice:(VoiceDetailModel *)model;
- (instancetype)initDeleteLovedVoiceList;

//收藏专辑
- (instancetype)initInsertCollectAlbum:(AlbumVoiceModel *)model;
- (instancetype)initSelectCollectAlbumList;
- (instancetype)initCheckCollectAlbum:(AlbumVoiceModel *)model;
- (instancetype)initDeleteCollectAlbum:(AlbumVoiceModel *)model;

@end
