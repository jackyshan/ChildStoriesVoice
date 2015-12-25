//
//  SettingModel.h
//  ChildStoriesVoice
//
//  Created by jackyshan on 12/25/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "BaseModel.h"

@class SettingListModel;
@protocol SettingListModel;
@interface SettingModel : BaseModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray<SettingListModel> *list;

@end

@protocol SettingListModel <NSObject>

@end

@interface SettingListModel : BaseModel

@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detailTitle;
@property (nonatomic, strong) NSString *type;

@end
