//
//  LovedVoiceListVC.m
//  ChildStoriesVoice
//
//  Created by apple on 12/27/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "LovedVoiceListVC.h"
#import "DataBaseServer.h"
#import "VoiceDetailCell.h"

#define VOICE_DETAIL_CELL @"voiceDetailCell"

@interface LovedVoiceListVC()<UITableViewDataSource, UITableViewDelegate> {
    NSArray *_mArr;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LovedVoiceListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"喜欢的音乐";
    
    [self loadingData];
}

- (void)addSubviews {
    [self.view addSubview:self.tableView];
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
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.mas_equalTo(-kPlayBottomBarHeight);
    }];
}

- (void)loadingData {
    _mArr = [DataBaseServer selectLovedVoiceList];
    [_tableView reloadData];
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
