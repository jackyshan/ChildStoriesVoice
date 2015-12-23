//
//  VoiceDetailCell.m
//  ChildStoriesVoice
//
//  Created by jackyshan on 12/18/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "VoiceDetailCell.h"
#import "VoiceDetailModel.h"

@interface VoiceDetailCell()

@property (nonatomic, strong) UILabel *numberLb;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation VoiceDetailCell

- (void)addSubviews {
    [self.contentView addSubview:self.numberLb];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.lineView];
}

- (UILabel *)numberLb {
    if (!_numberLb) {
        _numberLb = [InputHelper createLabelWithFrame:CGRectZero title:nil textColor:COLOR_94999C bgColor:COLOR_CLEAR fontSize:9.f textAlignment:NSTextAlignmentCenter addToView:self.contentView bBold:YES];
    }
    
    return _numberLb;
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [InputHelper createLabelWithFrame:CGRectZero title:nil textColor:COLOR_32393D bgColor:COLOR_CLEAR fontSize:14.f textAlignment:NSTextAlignmentLeft addToView:self.contentView bBold:YES];
    }
    
    return _titleLb;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = COLOR_F0F2F2;
    }
    
    return _lineView;
}

- (void)defineLayout {
    [_numberLb mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(20);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(10);
    }];
    
    [_titleLb mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_numberLb.mas_right).offset(5);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(19);
        make.height.mas_equalTo(14);
    }];
    
    [_lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.contentView);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)updateWithModel:(VoiceDetailModel *)model {
    _numberLb.text = model.playtimes;
    
    _titleLb.text = model.title;
}

@end
