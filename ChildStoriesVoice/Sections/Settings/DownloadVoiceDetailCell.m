//
//  DownloadVoiceDetailCell.m
//  ChildStoriesVoice
//
//  Created by apple on 12/28/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "DownloadVoiceDetailCell.h"

@interface DownloadVoiceDetailCell()

@property (nonatomic, strong) MBRoundProgressView *roundProgressView;

@end

@implementation DownloadVoiceDetailCell

- (void)addSubviews {
    [super addSubviews];
    
    [self.contentView addSubview:self.roundProgressView];
}

- (MBRoundProgressView *)roundProgressView {
    if (!_roundProgressView) {
        _roundProgressView = [[MBRoundProgressView alloc] init];
        _roundProgressView.progressTintColor = COLOR_9AFCB8;
        _roundProgressView.progress = 1.0;
    }
    
    return _roundProgressView;
}

- (void)defineLayout {
    [super defineLayout];
    
    [_roundProgressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.width.height.mas_equalTo(22);
        make.center.equalTo(self.contentView);
    }];
}

@end
