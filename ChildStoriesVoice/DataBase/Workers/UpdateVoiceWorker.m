//
//  UpdateVoiceWorker.m
//  ChildStoriesVoice
//
//  Created by apple on 12/26/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "UpdateVoiceWorker.h"

@implementation UpdateVoiceWorker

//@"CREATE TABLE IF NOT EXISTS play_voice_list(id INTEGER PRIMARY KEY, trackId TEXT, title TEXT, coverSmall TEXT, coverLarge TEXT, playtimes TEXT, playUrl32 TEXT, playUrl64 TEXT, mp3size_32 TEXT, mp3size_64 TEXT, albumId TEXT, albumUid TEXT, duration TEXT, createdAt TEXT, updatedAt TEXT, progress TEXT,tag TEXT)"
- (instancetype)initDeletePlayVoiceList {
    if (self = [super init]) {
        self.execute = ^(FMDatabase *dbHelper) {
            NSString *commandText = @"DELETE FROM play_voice_list";//清空播放列表
            [dbHelper executeUpdate:commandText];
        };
    }
    
    return self;
}

- (instancetype)initInsertPlayVoice:(VoiceDetailModel *)model {
    if (self = [super init]) {
        self.execute = ^(FMDatabase *dbHelper) {
            //插入最新列表更新
            NSString *commandText = @"SELECT * FROM play_voice_list WHERE trackId = ?";
            FMResultSet *result = [dbHelper executeQuery:commandText, model.trackId];
            
            if ([result next]) {
                commandText = @"UPDATE play_voice_list SET progress = ? WHERE trackId = ?";
                [dbHelper executeUpdate:commandText, model.progress, model.trackId];
            }
            else {
                commandText = @"INSERT INTO play_voice_list (trackId, title, coverSmall, coverLarge, playtimes, playUrl32, playUrl64, mp3size_32, mp3size_64, albumId, albumUid, duration, createdAt, updatedAt, progress, finished) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
                [dbHelper executeUpdate:commandText, model.trackId, model.title, model.coverSmall, model.coverLarge, model.playtimes, model.playUrl32, model.playUrl64, model.mp3size_32, model.mp3size_64, model.albumId, model.albumUid, model.duration, model.createdAt, model.updatedAt, model.progress, @(model.finished).stringValue];
            }
        };
    }
    
    return self;
}

- (instancetype)initSelectPlayVoiceList {
    if (self = [super init]) {
        __weak __typeof(self) weakSelf = self;
        
        self.execute = ^(FMDatabase *dbHelper) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            
            NSString *commandText = @"SELECT * FROM play_voice_list";//返回播放列表
            FMResultSet *result = [dbHelper executeQuery:commandText];
            
            NSMutableArray *mArr = [NSMutableArray array];
            while ([result next]) {
                NSDictionary *dic = [result resultDictionary];
                VoiceDetailModel *model = [[VoiceDetailModel alloc] initWithDictionary:dic error:nil];
                [mArr addObject:model];
            }
            
            strongSelf->_result = @{@"result":mArr};
        };
    }
    
    return self;
}

//commandText = @"CREATE TABLE IF NOT EXISTS play_voice_lasted(id INTEGER PRIMARY KEY, trackId TEXT, title TEXT, coverSmall TEXT, coverLarge TEXT, playtimes TEXT, playUrl32 TEXT, playUrl64 TEXT, mp3size_32 TEXT, mp3size_64 TEXT, albumId TEXT, albumUid TEXT, duration TEXT, createdAt TEXT, updatedAt TEXT, playtime TEXT, tag TEXT)";
- (instancetype)initInsertPlayVoiceLasted:(VoiceDetailModel *)model {
    if (self = [super init]) {
        self.execute = ^(FMDatabase *dbHelper) {
            NSString *commandText = @"SELECT * FROM play_voice_lasted WHERE trackId = ?";
            FMResultSet *result = [dbHelper executeQuery:commandText, model.trackId];
            
            if ([result next]) {
                commandText = @"UPDATE play_voice_lasted SET playtime = ? WHERE trackId = ?";
                [dbHelper executeUpdate:commandText, model.playtime, model.trackId];
            }else {
                commandText = @"INSERT INTO play_voice_lasted (trackId, title, coverSmall, coverLarge, playtimes, playUrl32, playUrl64, mp3size_32, mp3size_64, albumId, albumUid, duration, createdAt, updatedAt, playtime) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
                [dbHelper executeUpdate:commandText, model.trackId, model.title, model.coverSmall, model.coverLarge, model.playtimes, model.playUrl32, model.playUrl64, model.mp3size_32, model.mp3size_64, model.albumId, model.albumUid, model.duration, model.createdAt, model.updatedAt, model.playtime];
            }
        };
    }
    
    return self;
}

- (instancetype)initSelectPlayVoiceLastedList {
    if (self = [super init]) {
        
        __weak __typeof(self) weakSelf = self;
        self.execute = ^(FMDatabase *dbHelper) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            
            NSString *commandText = @"SELECT * FROM play_voice_lasted ORDER BY playtime DESC";
            FMResultSet *result = [dbHelper executeQuery:commandText];
            
            NSMutableArray *mArr = [NSMutableArray array];
            while ([result next]) {
                NSDictionary *dic = [result resultDictionary];
                VoiceDetailModel *model = [[VoiceDetailModel alloc] initWithDictionary:[result resultDictionary] error:nil];
                [mArr addObject:dic];
            }
            
            strongSelf->_result= @{@"result":mArr};
        };
    }
    
    return self;
}

- (instancetype)initDeletePlayVoiceLastedList {
    if (self = [super init]) {
        self.execute = ^(FMDatabase *dbHelper) {
            
            NSString *commandText = @"DELETE FROM play_voice_lasted";
            [dbHelper executeUpdate:commandText];
        };
    }
    
    return self;
}

- (instancetype)initDeletePlayVoiceLasted:(VoiceDetailModel *)model {
    if (self = [super init]) {
        self.execute = ^(FMDatabase *dbHelper) {
            
            NSString *commandText = @"DELETE FROM play_voice_lasted WHERE trackId = ?";
            [dbHelper executeUpdate:commandText, model.trackId];
        };
    }
    
    return self;
}

//commandText = @"CREATE TABLE IF NOT EXISTS play_voice_download(id INTEGER PRIMARY KEY, trackId TEXT, title TEXT, coverSmall TEXT, coverLarge TEXT, playtimes TEXT, playUrl32 TEXT, playUrl64 TEXT, mp3size_32 TEXT, mp3size_64 TEXT, albumId TEXT, albumUid TEXT, duration TEXT, createdAt TEXT, updatedAt TEXT, progress TEXT, downloadProgress TEXT, finished TEXT, tag TEXT)";
- (instancetype)initInsertDownload:(VoiceDetailModel *)model {
    if (self = [super init]) {
        
        __weak __typeof(self) weakSelf = self;
        self.execute = ^(FMDatabase *dbHelper){
            
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            NSString *commandText = @"SELECT * FROM play_voice_download WHERE trackId = ?";
            FMResultSet *result = [dbHelper executeQuery:commandText, model.trackId];
            
            if ([result next]) {
                strongSelf->_result = @{@"result":@(YES)};
            }
            else {
                commandText = @"INSERT INTO play_voice_download (trackId, title, coverSmall, coverLarge, playtimes, playUrl32, playUrl64, mp3size_32, mp3size_64, albumId, albumUid, duration, createdAt, updatedAt, downloadProgress, finished, savePath) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
                [dbHelper executeUpdate:commandText, model.trackId, model.title, model.coverSmall, model.coverLarge, model.playtimes, model.playUrl32, model.playUrl64, model.mp3size_32, model.mp3size_64, model.albumId, model.albumUid, model.duration, model.createdAt, model.updatedAt, @(model.downloadProgress).stringValue, @(model.finished).stringValue, model.savePath];
            }
            
        };
    }
    
    return self;
}

- (instancetype)initUpdateDownload:(VoiceDetailModel *)model {
    if (self = [super init]) {
        self.execute = ^(FMDatabase *dbHelper) {
            if (model.downloadProgress == 1) {
                model.finished = YES;
            }
            
            NSString *commandText = @"UPDATE play_voice_download SET downloadProgress = ?, finished = ? WHERE trackId = ?";
            [dbHelper executeUpdate:commandText, @(model.downloadProgress).stringValue, @(model.finished).stringValue, model.trackId];
        };
    }
    
    return self;
}

- (instancetype)initSelectDownloadList:(BOOL)finished {
    if (self = [super init]) {
        
        __weak __typeof(self) weakSelf = self;
        self.execute = ^(FMDatabase *dbHelper) {
            NSString *commandText = @"SELECT * FROM play_voice_download WHERE finished = ?";
            FMResultSet *result = [dbHelper executeQuery:commandText, @(finished).stringValue];
            
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            NSMutableArray *mArr = [NSMutableArray array];
            while ([result next]) {
                VoiceDetailModel *model = [[VoiceDetailModel alloc] initWithDictionary:[result resultDictionary] error:nil];
                [mArr addObject:model];
            }
            
            strongSelf->_result = @{@"result":mArr};
        };
    }
    
    return self;
}

- (instancetype)initDeleteDownload:(VoiceDetailModel *)model {
    if (self = [super init]) {
        self.execute = ^(FMDatabase *dbHelper) {
            NSString *commandText = @"DELETE FROM play_voice_download WHERE trackId = ?";
            [dbHelper executeUpdate:commandText, model.trackId];
        };
    }
    
    return self;
}

//commandText = @"CREATE TABLE IF NOT EXISTS play_voice_loved(id INTEGER PRIMARY KEY, trackId TEXT, title TEXT, coverSmall TEXT, coverLarge TEXT, playtimes TEXT, playUrl32 TEXT, playUrl64 TEXT, mp3size_32 TEXT, mp3size_64 TEXT, albumId TEXT, albumUid TEXT, duration TEXT, createdAt TEXT, updatedAt TEXT, tag TEXT)";
- (instancetype)initInsertLovedVoice:(VoiceDetailModel *)model {
    if (self = [super init]) {
        self.execute = ^(FMDatabase *dbHelper) {
            NSString *commandText = @"INSERT INTO play_voice_loved (trackId, title, coverSmall, coverLarge, playtimes, playUrl32, playUrl64, mp3size_32, mp3size_64, albumId, albumUid, duration, createdAt, updatedAt) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            [dbHelper executeUpdate:commandText, model.trackId, model.title, model.coverSmall, model.coverLarge, model.playtimes, model.playUrl32, model.playUrl64, model.mp3size_32, model.mp3size_64, model.albumId, model.albumUid, model.duration, model.createdAt, model.updatedAt];
        };
    };
    
    return self;
}

- (instancetype)initSelectLovedVoiceList {
    if (self = [super init]) {
        
        __weak __typeof(self) weakSelf = self;
        self.execute = ^(FMDatabase *dbHelper) {
            NSString *commandText = @"SELECT * FROM play_voice_loved ORDER BY id DESC";
            FMResultSet *result = [dbHelper executeQuery:commandText];
            
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            NSMutableArray *mArr = [NSMutableArray array];
            while ([result next]) {
                VoiceDetailModel *model = [[VoiceDetailModel alloc] initWithDictionary:[result resultDictionary] error:nil];
                [mArr addObject:model];
            }
            
            strongSelf->_result = @{@"result":mArr};
        };
    }
    
    return self;
}

- (instancetype)initCheckLovedVoice:(VoiceDetailModel *)model {
    if (self = [super init]) {
        
        __weak __typeof(self) weakSelf = self;
        self.execute = ^(FMDatabase *dbHelper) {
            NSString *commandText = @"SELECT * FROM play_voice_loved WHERE trackId = ?";
            FMResultSet *result = [dbHelper executeQuery:commandText, model.trackId];
            
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            BOOL isLoved = [result next];
            
            strongSelf->_result = @{@"result":@(isLoved)};
        };
    }
    
    return self;
}

- (instancetype)initDeleteLovedVoice:(VoiceDetailModel *)model {
    if (self = [super init]) {
        
        self.execute = ^(FMDatabase *dbHelper) {
            NSString *commandText = @"DELETE FROM play_voice_loved WHERE trackId = ?";
            [dbHelper executeUpdate:commandText, model.trackId];
        };
    }
    
    return self;
}

- (instancetype)initDeleteLovedVoiceList {
    if (self = [super init]) {
        
        self.execute = ^(FMDatabase *dbHelper) {
            NSString *commandText = @"DELETE FROM play_voice_loved";
            [dbHelper executeUpdate:commandText];
        };
    }
    
    return self;
}

//commandText = @"CREATE TABLE IF NOT EXISTS play_voice_albums(id INTEGER PRIMARY KEY, albumId TEXT, title TEXT, coverSmall TEXT, coverLarge TEXT, updatedAt TEXT, finished TEXT, plays_counts TEXT, tracks_counts TEXT, selected TEXT, tag TEXT)";
- (instancetype)initInsertCollectAlbum:(AlbumVoiceModel *)model {
    if (self = [super init]) {
        self.execute = ^(FMDatabase *dbHelper) {
            NSString *commandText = @"INSERT INTO play_voice_albums (albumId, title, coverSmall, coverLarge, updatedAt, finished, plays_counts, tracks_counts, selected) VALUES (?,?,?,?,?,?,?,?,?)";
            [dbHelper executeUpdate:commandText, model.albumId, model.title, model.coverSmall, model.coverLarge, model.updatedAt, model.finished, model.plays_counts, model.tracks_counts, model.selected];
        };
    };
    
    return self;
}

- (instancetype)initSelectCollectAlbumList {
    if (self = [super init]) {
        
        __weak __typeof(self) weakSelf = self;
        self.execute = ^(FMDatabase *dbHelper) {
            NSString *commandText = @"SELECT * FROM play_voice_albums";
            FMResultSet *result = [dbHelper executeQuery:commandText];
            
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            NSMutableArray *mArr = [NSMutableArray array];
            while ([result next]) {
                AlbumVoiceModel *model = [[AlbumVoiceModel alloc] initWithDictionary:[result resultDictionary] error:nil];
                model.albumId = [result resultDictionary][@"albumId"];
                [mArr addObject:model];
            }
            
            strongSelf->_result = @{@"result":mArr};
        };
    }
    
    return self;
}

- (instancetype)initCheckCollectAlbum:(AlbumVoiceModel *)model {
    if (self = [super init]) {
        
        __weak __typeof(self) weakSelf = self;
        self.execute = ^(FMDatabase *dbHelper) {
            NSString *commandText = @"SELECT * FROM play_voice_albums WHERE albumId = ?";
            FMResultSet *result = [dbHelper executeQuery:commandText, model.albumId];
            
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            BOOL isStar = [result next];
            
            strongSelf->_result = @{@"result":@(isStar)};
        };
    }
    
    return self;
}

- (instancetype)initDeleteCollectAlbum:(AlbumVoiceModel *)model {
    if (self = [super init]) {
        
        self.execute = ^(FMDatabase *dbHelper) {
            NSString *commandText = @"DELETE FROM play_voice_albums WHERE albumId = ?";
            [dbHelper executeUpdate:commandText, model.albumId];
        };
    }
    
    return self;
}

@end
