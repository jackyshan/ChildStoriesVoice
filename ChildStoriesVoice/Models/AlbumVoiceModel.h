//
//  AlbumVoiceModel.h
//  ChildStoriesVoice
//
//  Created by jackyshan on 12/18/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "BaseModel.h"

@interface AlbumVoiceModel : BaseModel

@property (nonatomic, assign) NSUInteger id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *coverSmall;
@property (nonatomic, strong) NSString *coverLarge;
@property (nonatomic, assign) NSTimeInterval updatedAt;
@property (nonatomic, assign) NSInteger finished;
@property (nonatomic, assign) NSUInteger plays_counts;
@property (nonatomic, assign) NSUInteger tracks_counts;
@property (nonatomic, assign) BOOL selected;

@end
