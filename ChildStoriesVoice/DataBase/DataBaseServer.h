//
//  DataBaseServer.h
//  DBMeiziFuli
//
//  Created by jackyshan on 9/23/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UpdateVoiceWorker.h"

@interface DataBaseServer : NSObject

+ (void)createTable;

//播放列表,插入,查询,删除
+ (void)deletePlayVoiceList;
+ (void)insertPlayVoice:(VoiceDetailModel *)model;
+ (NSArray *)selectPlayVoiceList;

//最近播放列表,插入,查询
+ (void)insertPlayVoiceLasted:(VoiceDetailModel *)model;
+ (NSArray *)selectPlayVoiceLastedList;

//下载音乐
+ (BOOL)insertDownload:(VoiceDetailModel *)model;
+ (void)updateDownload:(VoiceDetailModel *)model;
+ (NSArray *)selectDownloadList;

//喜欢音乐
+ (void)insertLovedVoice:(VoiceDetailModel *)model;
+ (NSArray *)selectLovedVoiceList;
+ (BOOL)checkLovedVoice:(VoiceDetailModel *)model;
+ (void)deleteLovedVoice:(VoiceDetailModel *)model;

//收藏专辑
+ (void)insertCollectAlbum:(AlbumVoiceModel *)model;
+ (NSArray *)selectCollectAlbumList;
+ (BOOL)checkCollectAlbum:(AlbumVoiceModel *)model;
+ (void)deleteCollectAlbum:(AlbumVoiceModel *)model;

@end
