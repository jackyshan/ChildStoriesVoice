//
//  HomeCollectionCell.m
//  ChildStoriesVoice
//
//  Created by jackyshan on 12/18/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "HomeCollectionCell.h"
#import "AlbumVoiceModel.h"

@interface HomeCollectionCell()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *detailLb;
@property (nonatomic, strong) UILabel *songsNumLb;

@end

@implementation HomeCollectionCell

- (void)addSubviews {
    self.backgroundColor = COLOR_CLEAR;
    
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.detailLb];
    [self.contentView addSubview:self.songsNumLb];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = COLOR_GRAY;
    }
    
    return _imageView;
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.font = [UIFont boldSystemFontOfSize:14.f];
        _titleLb.textColor = COLOR_32393D;
    }
    
    return _titleLb;
}

- (UILabel *)detailLb {
    if (!_detailLb) {
        _detailLb = [[UILabel alloc] init];
        _detailLb.font = [UIFont systemFontOfSize:12.f];
        _detailLb.textColor = COLOR_32393D;
    }
    
    return _detailLb;
}

- (UILabel *)songsNumLb {
    if (!_songsNumLb) {
        _songsNumLb = [[UILabel alloc] init];
        _songsNumLb.font = [UIFont systemFontOfSize:12.f];
        _songsNumLb.textColor = COLOR_94999C;
    }
    
    return _songsNumLb;
}

- (void)defineLayout {
    [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.equalTo(self.contentView);
        make.height.mas_equalTo(124);
    }];
    
    [_titleLb mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.contentView);
        make.top.mas_equalTo(_imageView.mas_bottom).offset(7);
        make.height.mas_equalTo(15);
    }];

    [_detailLb mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.contentView);
        make.top.mas_equalTo(_titleLb.mas_bottom).offset(4);
        make.height.mas_equalTo(14);
    }];

    [_songsNumLb mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(_imageView);
        make.top.mas_equalTo(_detailLb.mas_bottom).offset(4);
        make.height.mas_equalTo(12);
    }];
}

- (void)updateWithModel:(AlbumVoiceModel *)model {
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.coverLarge]];
    
    _titleLb.text = model.title;
    _detailLb.text = [NSString stringWithFormat:@"%@ plays", model.plays_counts];
    _songsNumLb.text = [NSString stringWithFormat:@"%@ voices", model.tracks_counts];
}

@end
