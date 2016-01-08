//
//  SearchHistoryCell.m
//  ChildStoriesVoice
//
//  Created by jackyshan on 1/6/16.
//  Copyright © 2016 jackyshan. All rights reserved.
//

#import "SearchHistoryCell.h"
#import "SearchModel.h"

@interface SearchHistoryCell()

@end

@implementation SearchHistoryCell

- (void)addSubviews {
    self.backgroundColor = [UIColor clearColor];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, self.height)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.clipsToBounds = YES;
    [self.contentView addSubview:backView];
    
    UIImageView *iconImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_search_history"]];
    iconImgV.frame = CGRectMake(11, 14, 16, 16);
    [backView addSubview:iconImgV];
    self.iconImgV = iconImgV;
    
    UILabel *titleLb = [InputHelper createLabelWithFrame:CGRectMake(35, 12, 240, 17) title:nil textColor:[ColorHelper colorWithHexString:@"#535353"] bgColor:COLOR_CLEAR fontSize:14.f textAlignment:NSTextAlignmentLeft addToView:backView bBold:NO];
    self.titleLb = titleLb;
    
    UIImageView *arrowImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cell_rightArrow"]];
    arrowImgV.frame = CGRectMake(backView.width - 17, 16, 7, 12);
    [backView addSubview:arrowImgV];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, backView.height-1, backView.width, 1)];
    lineView.backgroundColor = [ColorHelper colorWithHexString:@"#e0e0e0"];
    [backView addSubview:lineView];
}

- (void)defineLayout {}

- (void)updateWithModel:(SearchModel *)model {
    _titleLb.text = model.title;
}

@end
