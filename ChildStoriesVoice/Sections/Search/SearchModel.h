//
//  SearchModel.h
//  ChildStoriesVoice
//
//  Created by jackyshan on 1/6/16.
//  Copyright © 2016 jackyshan. All rights reserved.
//

#import "BaseModel.h"

@interface SearchModel : BaseModel

@end

@interface SearchHistoryModel : BaseModel

@end

@interface SearchResultModel : BaseModel

@property (nonatomic, strong) NSString *albumId;
@property (nonatomic, strong) NSString *title;

@end
