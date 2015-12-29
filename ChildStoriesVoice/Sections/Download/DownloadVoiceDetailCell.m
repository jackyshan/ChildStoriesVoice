//
//  DownloadVoiceDetailCell.m
//  ChildStoriesVoice
//
//  Created by apple on 12/28/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "DownloadVoiceDetailCell.h"
#import "VoiceDetailModel.h"
#import "DownloadVoiceListVC.h"

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
        _roundProgressView.backgroundTintColor = COLOR_9AFCB8;
    }
    
    return _roundProgressView;
}

- (void)defineLayout {
    [super defineLayout];
    
    [_roundProgressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.right.mas_equalTo(-10);
        make.width.height.mas_equalTo(22);
    }];
}

- (void)setNwDownload:(NWDownLoad *)nwDownload {
    _nwDownload = nwDownload;
    
    @weakify(self)
    [_nwDownload setCompletion:^(NSNumber *progress, BOOL succ) {
        @strongify(self)
        self.roundProgressView.progress = progress.floatValue;
    }];
}

- (void)updateWithModel:(VoiceDetailModel *)model {
    [super updateWithModel:model];
    
    _roundProgressView.progress = model.downloadProgress;
}

@end
