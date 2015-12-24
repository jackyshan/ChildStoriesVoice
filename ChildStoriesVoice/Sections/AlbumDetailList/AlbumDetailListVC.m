//
//  AlbumDetailListVC.m
//  ChildStoriesVoice
//
//  Created by jackyshan on 12/18/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "AlbumDetailListVC.h"
#import "NWAlbumDetails.h"
#import "VoiceDetailCell.h"
#import "VoiceDetailModel.h"
#import "STKAudioPlayer.h"

#define VOICE_DETAIL_CELL @"voiceDetailCell"

@interface AlbumDetailListVC ()<UITableViewDataSource, UITableViewDelegate> {
    AlbumVoiceModel *_model;
}

@property (nonatomic, strong) UIImageView *albumImageView;
@property (nonatomic, strong) UILabel *albumInfo;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *naviLeftArrow;
@property (nonatomic, strong) UIView *statusBarView;

@property (nonatomic, strong) NSMutableArray *mArr;

@end

@implementation AlbumDetailListVC

- (instancetype)initWithModel:(AlbumVoiceModel *)model {
    if (self = [super init]) {
        _model = model;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.mArr = [NSMutableArray array];
    [self loadingData];
}

- (void)addSubviews {
    [self.view addSubview:self.albumImageView];
    [self.albumImageView addSubview:self.albumInfo];
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.naviLeftArrow];
    [self.view addSubview:self.statusBarView];
}

- (UIButton *)naviLeftArrow {
    if (!_naviLeftArrow) {
        _naviLeftArrow = [[UIButton alloc] init];
        [_naviLeftArrow setImage:[UIImage imageNamed:@"ArrowLeft"]];
        @weakify(self)
        [[_naviLeftArrow rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
            @strongify(self)
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    
    return _naviLeftArrow;
}

- (UIView *)statusBarView {
    if (!_statusBarView) {
        _statusBarView = [[UIView alloc] init];
        _statusBarView.backgroundColor = COLOR_CLEAR;
    }
    
    return _statusBarView;
}

- (UIImageView *)albumImageView {
    if (!_albumImageView) {
        _albumImageView = [[UIImageView alloc] init];
        @weakify(self)
        [_albumImageView sd_setImageWithURL:[NSURL URLWithString:_model.coverLarge] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            @strongify(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.25 animations:^{
                    self.statusBarView.backgroundColor = [ColorHelper mostColor:image];
                }];
            });
        }];
    }
    
    return _albumImageView;
}

- (UILabel *)albumInfo {
    if (!_albumInfo) {
        _albumInfo = [InputHelper createLabelWithFrame:CGRectZero title:nil textColor:COLOR_FFFFFF bgColor:COLOR_CLEAR fontSize:14.f textAlignment:NSTextAlignmentLeft addToView:_albumImageView bBold:NO];
        _albumInfo.numberOfLines = 0;
        
        NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] init];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", _model.title] attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14.f], NSFontAttributeName, COLOR_FFFFFF, NSForegroundColorAttributeName, nil]];
        [aString appendAttributedString:str];
        [aString appendAttributedString:[InputHelper attributeStringWith:[NSString stringWithFormat:@"%@ plays\n", _model.plays_counts] font:12.f color:COLOR_FFFFFF]];
        [aString appendAttributedString:[InputHelper attributeStringWith:[NSString stringWithFormat:@"%@ voices", _model.tracks_counts] font:12.f color:COLOR_FFFFFF]];
        
        NSParagraphStyle *para = [InputHelper paraGraphStyle:4.f align:NSTextAlignmentLeft];
        [aString addAttribute:NSParagraphStyleAttributeName value:para range:NSMakeRange(0, aString.length)];
        
        _albumInfo.attributedText = aString;
    }
    
    return _albumInfo;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
        
        [_tableView registerClass:[VoiceDetailCell class] forCellReuseIdentifier:VOICE_DETAIL_CELL];
    }
    
    return _tableView;
}

- (void)defineLayout {
    [_albumImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.equalTo(self.view);
        make.height.mas_equalTo(270);
    }];
    
    [_albumInfo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(26);
        make.width.mas_equalTo(210);
        make.height.mas_equalTo(55);
        make.bottom.mas_equalTo(-20);
    }];
    
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.view);
        make.top.mas_equalTo(_albumImageView.mas_bottom);
        make.bottom.mas_equalTo(-kPlayBottomBarHeight);
    }];
    
    [_naviLeftArrow mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(26);
        make.top.mas_equalTo(35);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [_statusBarView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
}

- (void)loadingData {
    [super loadingData];
    
    NWAlbumDetails *albumDetails = [[NWAlbumDetails alloc] init];
    [albumDetails setCompletion:^(NSArray *arr, BOOL succ) {
        if (succ) {
            if (arr.count == 0) {
                [CommonHelper showMessage:@"没有更多了"];return;
            }
            
            [self.mArr addObjectsFromArray:arr];
            [_tableView reloadData];
        }
        else {
            [self loadingFial];
        }
    }];
    
    albumDetails.path = [NSString stringWithFormat:@"948/albums/%@", _model.id];
    [albumDetails startRequestWithParams:@{@"page_id":@(1),
                                           @"isAsc":@(YES)}];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VoiceDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:VOICE_DETAIL_CELL];
    
    VoiceDetailModel *model = _mArr[indexPath.row];
    [cell updateWithModel:model];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VoiceDetailModel *model = _mArr[indexPath.row];
    [self.delegate.playBottomBar playWithModel:model andModels:_mArr];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

@end
