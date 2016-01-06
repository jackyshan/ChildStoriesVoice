//
//  SearchResultCell.m
//  ChildStoriesVoice
//
//  Created by jackyshan on 1/6/16.
//  Copyright © 2016 jackyshan. All rights reserved.
//

#import "SearchResultCell.h"
#import "SearchModel.h"

@implementation SearchResultCell

- (void)addSubviews {
    [super addSubviews];
    
    [self.iconImgV setImage:[UIImage imageNamed:@"icon_search_suggest"]];
}

- (void)defineLayout {}

- (void)updateWithModel:(SearchResultModel *)model {
    self.titleLb.text = model.title;
}

@end
