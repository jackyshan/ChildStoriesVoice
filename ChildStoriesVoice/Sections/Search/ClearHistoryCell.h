//
//  ClearHistoryCell.h
//  ChildStoriesVoice
//
//  Created by jackyshan on 1/7/16.
//  Copyright © 2016 jackyshan. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ClearHistoryCell : BaseTableViewCell

@property (nonatomic, copy) void(^clearTap)();

@end
