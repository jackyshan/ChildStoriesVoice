//
//  SearchModel.h
//  ChildStoriesVoice
//
//  Created by jackyshan on 1/6/16.
//  Copyright © 2016 jackyshan. All rights reserved.
//

#import "BaseModel.h"

@interface SearchModel : BaseModel

@property (nonatomic, strong) NSString *albumId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *update_time;

@end