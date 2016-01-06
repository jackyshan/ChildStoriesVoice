//
//  SearchModel.m
//  ChildStoriesVoice
//
//  Created by jackyshan on 1/6/16.
//  Copyright © 2016 jackyshan. All rights reserved.
//

#import "SearchModel.h"

@implementation SearchModel

@end

@implementation SearchHistoryModel

@end

@implementation SearchResultModel

+ (JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"albumId"}];
}

@end