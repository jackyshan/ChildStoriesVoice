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

#define VOICE_DETAIL_CELL @"voiceDetailCell"

@interface AlbumDetailListVC ()<UITableViewDataSource, UITableViewDelegate> {
    AlbumVoiceModel *_model;
}

@property (nonatomic, strong) UIImageView *albumImageView;
@property (nonatomic, strong) UITableView *tableView;

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
    [self.view addSubview:self.tableView];
}

- (UIImageView *)albumImageView {
    if (!_albumImageView) {
        _albumImageView = [[UIImageView alloc] init];
        [_albumImageView sd_setImageWithURL:[NSURL URLWithString:_model.coverLarge]];
    }
    
    return _albumImageView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[VoiceDetailCell class] forCellReuseIdentifier:VOICE_DETAIL_CELL];
    }
    
    return _tableView;
}

- (void)defineLayout {
    [_albumImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.equalTo(self.view);
        make.height.mas_equalTo(270);
    }];
    
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.view);
        make.top.mas_equalTo(_albumImageView.mas_bottom);
        make.bottom.mas_equalTo(-kPlayBottomBarHeight);
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
    
    albumDetails.path = [NSString stringWithFormat:@"948/albums/%@", @(_model.id).stringValue];
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
    
    AlbumVoiceModel *model = _mArr[indexPath.row];
    cell.textLabel.text = model.title;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 51.f;
}

@end
