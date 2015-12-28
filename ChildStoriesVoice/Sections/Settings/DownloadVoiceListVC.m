//
//  DownloadVoiceListVC.m
//  ChildStoriesVoice
//
//  Created by apple on 12/27/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "DownloadVoiceListVC.h"
#import "DataBaseServer.h"
#import "DownloadVoiceDetailCell.h"

#define DOWNLOAD_VOICE_DETAIL_CELL @"downloadVoiceDetailCell"

@interface DownloadVoiceListVC()<UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *_mArr;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UISegmentedControl *segmentControl;

@end

@implementation DownloadVoiceListVC

- (void)addSubviews {
    [self.view addSubview:self.tableView];
    
    self.navigationItem.titleView = self.segmentControl;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
        
        [_tableView registerClass:[DownloadVoiceDetailCell class] forCellReuseIdentifier:DOWNLOAD_VOICE_DETAIL_CELL];
    }
    
    return _tableView;
}

- (UISegmentedControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"已下载", @"正在下载"]];
        [_segmentControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
        _segmentControl.tintColor = COLOR_94999C;
        _segmentControl.selectedSegmentIndex = 0;
    }
    
    return _segmentControl;
}

#pragma mark - 实现segmentedControl的监听事件
- (void)segmentedControlAction:(UISegmentedControl *)sender {
    // 获取当前的选中项的索引值
    NSUInteger index = sender.selectedSegmentIndex;
    // 判断索引值
    switch (index) {
        case 0:
            NSLog(@"第一个选项被选中");
            break;
        case 1:
            NSLog(@"第二个选项被选中");
            break;
        case 2:
            NSLog(@"第三项被选中");
            break;
        case 3:
            NSLog(@"第四项被选中");
            break;
        default:
            break;
    }
}

- (void)defineLayout {
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.mas_equalTo(-kPlayBottomBarHeight);
    }];
}

- (void)loadingData {
    _mArr = [NSMutableArray arrayWithArray:[DataBaseServer selectDownloadList:YES]];
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mArr.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DownloadVoiceDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:DOWNLOAD_VOICE_DETAIL_CELL];
    
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    VoiceDetailModel *model = _mArr[indexPath.row];
    [DataBaseServer deletePlayVoiceLasted:model];
    
    [tableView reloadData];
}

@end
