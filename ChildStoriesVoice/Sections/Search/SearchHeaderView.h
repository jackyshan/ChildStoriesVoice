//
//  SearchHeaderView.h
//  ChildStoriesVoice
//
//  Created by jackyshan on 1/6/16.
//  Copyright © 2016 jackyshan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchModel;
@protocol SearchHeaderViewDelegate <NSObject>

- (void)goToSearchVC:(SearchModel *)model;

@end

@interface SearchHeaderView : UIView

@property (nonatomic, weak) id<SearchHeaderViewDelegate> delegate;

@end
