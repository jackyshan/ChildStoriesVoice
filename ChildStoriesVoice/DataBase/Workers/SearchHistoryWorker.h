//
//  SearchHistoryWorker.h
//  ChildStoriesVoice
//
//  Created by jackyshan on 1/7/16.
//  Copyright © 2016 jackyshan. All rights reserved.
//

#import "DatabaseWorker.h"
#import "SearchModel.h"

@interface SearchHistoryWorker : DatabaseWorker

- (instancetype)initInsertSearchHistory:(SearchModel *)model;
- (instancetype)initSelectSearchHistoryList;
- (instancetype)initDeleteSearchHistoryList;

@end
