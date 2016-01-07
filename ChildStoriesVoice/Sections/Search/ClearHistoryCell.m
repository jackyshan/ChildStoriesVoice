//
//  ClearHistoryCell.m
//  ChildStoriesVoice
//
//  Created by jackyshan on 1/7/16.
//  Copyright © 2016 jackyshan. All rights reserved.
//

#import "ClearHistoryCell.h"
#import "ColorHelper.h"
#import "DataBaseServer.h"

@interface ClearHistoryCell()

@property (nonatomic, strong) UIControl *clearContrl;

@end

@implementation ClearHistoryCell

- (void)addSubviews {
    
    
    self.backgroundColor = [UIColor clearColor];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.width - 20, self.height)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.clipsToBounds = YES;
    [self.contentView addSubview:backView];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = backView.frame;
    label.text = @"清除搜索记录";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [ColorHelper colorWithHexString:@"#949494"];
    label.font = [UIFont systemFontOfSize:14.f];
    [backView addSubview:label];
    
    [self.contentView addSubview:self.clearContrl];
}

- (UIControl *)clearContrl {
    if (!_clearContrl) {
        _clearContrl = [[UIControl alloc] init];
        [_clearContrl addTarget:self action:@selector(_clearHistory) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _clearContrl;
}

- (void)defineLayout {
    [_clearContrl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)_clearHistory {
    if (self.clearTap) {
        self.clearTap();
    }
}

@end
