//
//  SearchHistoryWorker.m
//  ChildStoriesVoice
//
//  Created by jackyshan on 1/7/16.
//  Copyright © 2016 jackyshan. All rights reserved.
//

#import "SearchHistoryWorker.h"

@implementation SearchHistoryWorker

//commandText = @"CREATE TABLE IF NOT EXISTS search_history(id INTEGER PRIMARY KEY, albumId TEXT, title TEXT, update_time TEXT, tag TEXT)";
- (instancetype)initInsertSearchHistory:(SearchModel*)model {
    if (self = [super init]) {
        self.execute = ^(FMDatabase *dbHelper) {
            NSString *commandText = @"SELECT * FROM search_history WHERE title = ?";
            FMResultSet *result = [dbHelper executeQuery:commandText, model.title];
            
            if ([result next]) {
                commandText = @"UPDATE search_history SET update_time = ? WHERE title = ?";
                [dbHelper executeUpdate:commandText, model.update_time, model.title];
            }else {
                commandText = @"INSERT INTO search_history (albumId, title, update_time) VALUES (?,?, ?)";
                [dbHelper executeUpdate:commandText, model.albumId?:@"", model.title, model.update_time];
            }
        };
    }
    
    return self;
}

- (instancetype)initSelectSearchHistoryList {
    if (self = [super init]) {
        
        __weak __typeof(self) weakSelf = self;
        self.execute = ^(FMDatabase *dbHelper) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            
            NSString *commandText = @"SELECT * FROM search_history ORDER BY update_time DESC";
            FMResultSet *result = [dbHelper executeQuery:commandText];
            
            NSMutableArray *mArr = [NSMutableArray array];
            while ([result next]) {
                SearchModel *model = [[SearchModel alloc] initWithDictionary:[result resultDictionary] error:nil];
                model.albumId = [result resultDictionary][@"albumId"];
                [mArr addObject:model];
            }
            
            strongSelf->_result= @{@"result":mArr};
        };
    }
    
    return self;
}

- (instancetype)initDeleteSearchHistoryList {
    if (self = [super init]) {
        self.execute = ^(FMDatabase *dbHelper) {
            
            NSString *commandText = @"DELETE FROM search_history";
            [dbHelper executeUpdate:commandText];
        };
    }
    
    return self;
}

@end
