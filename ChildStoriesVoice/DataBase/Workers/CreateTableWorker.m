//
//  CreateTableWorker.m
//  DBMeiziFuli
//
//  Created by jackyshan on 9/23/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "CreateTableWorker.h"

@implementation CreateTableWorker

- (instancetype)init {
    if (self = [super init]) {
        self.execute = ^(FMDatabase *dbHelper) {
            /**
             创建播放列表,表play_voice_list结构如下:
             trackId                  dataid
             title                   title
             coverSmall              缩小图片链接
             coverLarge               高清图片链接
             playtimes                 播放次数
             playUrl32                 mp3链接
             playUrl64                 mp3链接高清
             mp3size_32                size大小
             mp3size_64
             albumId
             albumUid
             duration
             createdAt
             updatedAt
             
             progress              播放进度
             
             finished          下载完成
             **/
			NSString *commandText = @"CREATE TABLE IF NOT EXISTS play_voice_list(id INTEGER PRIMARY KEY, trackId TEXT, title TEXT, coverSmall TEXT, coverLarge TEXT, playtimes TEXT, playUrl32 TEXT, playUrl64 TEXT, mp3size_32 TEXT, mp3size_64 TEXT, albumId TEXT, albumUid TEXT, duration TEXT, createdAt TEXT, updatedAt TEXT, progress TEXT, finished TEXT, tag TEXT)";
			[dbHelper executeUpdate:commandText];
            
            /**
             创建最近列表,表play_voice_lasted结构如下:
             trackId                  dataid
             title                   title
             coverSmall              缩小图片链接
             coverLarge               高清图片链接
             playtimes                 播放次数
             playUrl32                 mp3链接
             playUrl64                 mp3链接高清
             mp3size_32                size大小
             mp3size_64
             albumId
             albumUid
             duration
             createdAt
             updatedAt
             
             playtime             最新播放时间//排序
             **/
            commandText = @"CREATE TABLE IF NOT EXISTS play_voice_lasted(id INTEGER PRIMARY KEY, trackId TEXT, title TEXT, coverSmall TEXT, coverLarge TEXT, playtimes TEXT, playUrl32 TEXT, playUrl64 TEXT, mp3size_32 TEXT, mp3size_64 TEXT, albumId TEXT, albumUid TEXT, duration TEXT, createdAt TEXT, updatedAt TEXT, playtime TEXT, tag TEXT)";
            [dbHelper executeUpdate:commandText];
            
            /**
             创建下载列表,表play_voice_download结构如下:
             trackId                  dataid
             title                   title
             coverSmall              缩小图片链接
             coverLarge               高清图片链接
             playtimes                 播放次数
             playUrl32                 mp3链接
             playUrl64                 mp3链接高清
             mp3size_32                size大小
             mp3size_64
             albumId
             albumUid
             duration
             createdAt
             updatedAt
             
             savePath              下载路径
             progress              播放进度
             downloadProgress                     下载进度
             finished                     下载完成
             **/
            commandText = @"CREATE TABLE IF NOT EXISTS play_voice_download(id INTEGER PRIMARY KEY, trackId TEXT, title TEXT, coverSmall TEXT, coverLarge TEXT, playtimes TEXT, playUrl32 TEXT, playUrl64 TEXT, mp3size_32 TEXT, mp3size_64 TEXT, albumId TEXT, albumUid TEXT, duration TEXT, createdAt TEXT, updatedAt TEXT, savePath TEXT, progress TEXT, downloadProgress TEXT, finished TEXT, tag TEXT)";
            [dbHelper executeUpdate:commandText];
            
            /**
             创建喜欢的音乐列表,表play_voice_loved结构如下:
             trackId                  dataid
             title                   title
             coverSmall              缩小图片链接
             coverLarge               高清图片链接
             playtimes                 播放次数
             playUrl32                 mp3链接
             playUrl64                 mp3链接高清
             mp3size_32                size大小
             mp3size_64
             albumId
             albumUid
             duration
             createdAt
             updatedAt
             **/
            commandText = @"CREATE TABLE IF NOT EXISTS play_voice_loved(id INTEGER PRIMARY KEY, trackId TEXT, title TEXT, coverSmall TEXT, coverLarge TEXT, playtimes TEXT, playUrl32 TEXT, playUrl64 TEXT, mp3size_32 TEXT, mp3size_64 TEXT, albumId TEXT, albumUid TEXT, duration TEXT, createdAt TEXT, updatedAt TEXT, tag TEXT)";
            [dbHelper executeUpdate:commandText];
            
            /**
             创建收藏的专辑列表,表play_voice_albums结构如下:
             albumId                  dataid
             title                   title
             coverSmall              缩小图片链接
             coverLarge               高清图片链接
             updatedAt
             finished
             plays_counts
             tracks_counts
             selected
             **/
            commandText = @"CREATE TABLE IF NOT EXISTS play_voice_albums(id INTEGER PRIMARY KEY, albumId TEXT, title TEXT, coverSmall TEXT, coverLarge TEXT, updatedAt TEXT, finished TEXT, plays_counts TEXT, tracks_counts TEXT, selected TEXT, tag TEXT)";
            [dbHelper executeUpdate:commandText];
        };
    }
    
    return self;
}

@end
