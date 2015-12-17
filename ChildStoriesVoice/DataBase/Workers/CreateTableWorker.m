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
			   创建收藏表,表star_photo_list结构如下:
			   dataid                  dataid
               title                   title
               dbtype                  数组
               starcount               喜欢次数
               datasrc                 图片链接
			 **/
			NSString *commandText = @"CREATE TABLE IF NOT EXISTS star_photo_list(id INTEGER PRIMARY KEY, dataid TEXT, title TEXT, dbtype BLOB, starcount INTEGER, datasrc TEXT, tag TEXT)";
			[dbHelper executeUpdate:commandText];
        };
    }
    
    return self;
}

@end
