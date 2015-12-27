//
//  AlbumVoiceModel.h
//  ChildStoriesVoice
//
//  Created by jackyshan on 12/18/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "BaseModel.h"

@interface AlbumVoiceModel : BaseModel

@property (nonatomic, strong) NSString *albumId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *coverSmall;
@property (nonatomic, strong) NSString *coverLarge;
@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, strong) NSString *finished;
@property (nonatomic, strong) NSString *plays_counts;
@property (nonatomic, strong) NSString *tracks_counts;
@property (nonatomic, strong) NSString *selected;

@end
