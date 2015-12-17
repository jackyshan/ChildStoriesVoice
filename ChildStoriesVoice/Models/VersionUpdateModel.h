//
//  VersionUpdateModel.h
//  DBMeiziFuli
//
//  Created by jackyshan on 9/25/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "BaseModel.h"

@interface VersionUpdateModel : BaseModel

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *newestVersion;
@property (nonatomic, assign) BOOL active;
@property (nonatomic, assign) BOOL mustUpdate;

@end