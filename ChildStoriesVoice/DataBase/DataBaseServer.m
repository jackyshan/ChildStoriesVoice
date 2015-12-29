//
//  DataBaseServer.m
//  DBMeiziFuli
//
//  Created by jackyshan on 9/23/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "DataBaseServer.h"
#import "DatabaseEngine.h"
#import "CreateTableWorker.h"

/**
 *  数据库上级目录
 */
static NSString *databaseDir = @"db";
/**
 *  数据库名称
 */
static NSString *databaseName = @"db.sqlite3";

@implementation DataBaseServer

+ (NSDictionary *)_addToEngine:(DatabaseWorker *)worker {
	return [[DatabaseEngine shareInstanceWithDir:databaseDir name:databaseName] addDbWorker:worker];
}

+ (void)createTable {
	CreateTableWorker *worker = [[CreateTableWorker alloc] init];
	[self _addToEngine:worker];
}

//播放列表,插入,查询，删除
+ (void)deletePlayVoiceList {
    UpdateVoiceWorker *worker = [[UpdateVoiceWorker alloc] initDeletePlayVoiceList];
    [self _addToEngine:worker];
}
+ (void)insertPlayVoice:(VoiceDetailModel *)model {
    UpdateVoiceWorker *worker = [[UpdateVoiceWorker alloc] initInsertPlayVoice:model];
    [self _addToEngine:worker];
}
+ (NSArray *)selectPlayVoiceList {
    UpdateVoiceWorker *worker = [[UpdateVoiceWorker alloc] initSelectPlayVoiceList];
    [self _addToEngine:worker];
    
    return [worker onResult][@"result"];
}

//最近播放列表,插入,查询
+ (void)insertPlayVoiceLasted:(VoiceDetailModel *)model {
    UpdateVoiceWorker *worker = [[UpdateVoiceWorker alloc] initInsertPlayVoiceLasted:model];
    [self _addToEngine:worker];
}
+ (NSArray *)selectPlayVoiceLastedList {
    UpdateVoiceWorker *worker = [[UpdateVoiceWorker alloc] initSelectPlayVoiceLastedList];
    [self _addToEngine:worker];
    
    return [worker onResult][@"result"];
}
+ (void)deletePlayVoiceLastedList {
    UpdateVoiceWorker *worker = [[UpdateVoiceWorker alloc] initDeletePlayVoiceLastedList];
    [self _addToEngine:worker];
}
+ (void)deletePlayVoiceLasted:(VoiceDetailModel *)model {
    UpdateVoiceWorker *worker = [[UpdateVoiceWorker alloc] initDeletePlayVoiceLasted:model];
    [self _addToEngine:worker];
}

//下载音乐
+ (BOOL)insertDownload:(VoiceDetailModel *)model {
    UpdateVoiceWorker *worker = [[UpdateVoiceWorker alloc] initInsertDownload:model];
    [self _addToEngine:worker];
    
    NSNumber *numberValue = [worker onResult][@"result"];
    return numberValue.boolValue;
}
+ (void)updateDownload:(VoiceDetailModel *)model {
    UpdateVoiceWorker *worker = [[UpdateVoiceWorker alloc] initUpdateDownload:model];
    [self _addToEngine:worker];
}
+ (NSArray *)selectDownloadList:(BOOL)finished; {
    UpdateVoiceWorker *worker = [[UpdateVoiceWorker alloc] initSelectDownloadList:finished];
    [self _addToEngine:worker];
    
    return [worker onResult][@"result"];
}
+ (void)deleteDownload:(VoiceDetailModel *)model {
    UpdateVoiceWorker *worker = [[UpdateVoiceWorker alloc] initDeleteDownload:model];
    [self _addToEngine:worker];
}

//喜欢音乐
+ (void)insertLovedVoice:(VoiceDetailModel *)model {
    UpdateVoiceWorker *worker = [[UpdateVoiceWorker alloc] initInsertLovedVoice:model];
    [self _addToEngine:worker];
}
+ (NSArray *)selectLovedVoiceList {
    UpdateVoiceWorker *worker = [[UpdateVoiceWorker alloc] initSelectLovedVoiceList];
    [self _addToEngine:worker];
    
    return [worker onResult][@"result"];
}
+ (BOOL)checkLovedVoice:(VoiceDetailModel *)model {
    UpdateVoiceWorker *worker = [[UpdateVoiceWorker alloc] initCheckLovedVoice:model];
    [self _addToEngine:worker];
    
    NSNumber *numberValue = [worker onResult][@"result"];
    return numberValue.boolValue;
}
+ (void)deleteLovedVoice:(VoiceDetailModel *)model {
    UpdateVoiceWorker *worker = [[UpdateVoiceWorker alloc] initDeleteLovedVoice:model];
    [self _addToEngine:worker];
}
+ (void)deleteLovedVoiceList {
    UpdateVoiceWorker *worker = [[UpdateVoiceWorker alloc] initDeleteLovedVoiceList];
    [self _addToEngine:worker];
}

//收藏专辑
+ (void)insertCollectAlbum:(AlbumVoiceModel *)model {
    UpdateVoiceWorker *worker = [[UpdateVoiceWorker alloc] initInsertCollectAlbum:model];
    [self _addToEngine:worker];
}
+ (NSArray *)selectCollectAlbumList {
    UpdateVoiceWorker *worker = [[UpdateVoiceWorker alloc] initSelectCollectAlbumList];
    [self _addToEngine:worker];
    
    return [worker onResult][@"result"];
}
+ (BOOL)checkCollectAlbum:(AlbumVoiceModel *)model {
    UpdateVoiceWorker *worker = [[UpdateVoiceWorker alloc] initCheckCollectAlbum:model];
    [self _addToEngine:worker];
    
    NSNumber *numberValue = [worker onResult][@"result"];
    return numberValue.boolValue;
}

+ (void)deleteCollectAlbum:(AlbumVoiceModel *)model {
    UpdateVoiceWorker *worker = [[UpdateVoiceWorker alloc] initDeleteCollectAlbum:model];
    [self _addToEngine:worker];
}

@end
