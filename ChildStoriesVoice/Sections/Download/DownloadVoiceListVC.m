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
#import "DownloadSingleton.h"

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
        
        _mArr = [NSMutableArray array];
        [self loadingData:NO];
    }
    
    return _segmentControl;
}

#pragma mark - 实现segmentedControl的监听事件
- (void)segmentedControlAction:(UISegmentedControl *)sender {
    // 获取当前的选中项的索引值
    NSUInteger index = sender.selectedSegmentIndex;
    
    [self loadingData:index];
}

- (void)defineLayout {
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.mas_equalTo(-kPlayBottomBarHeight);
    }];
}

- (void)loadingData:(BOOL)second {
    [_mArr removeAllObjects];
    
    [_mArr addObjectsFromArray:[DataBaseServer selectDownloadList:!second]];
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
    DownloadVoiceDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:DOWNLOAD_VOICE_DETAIL_CELL];
    
    VoiceDetailModel *model = _mArr[indexPath.row];
    [cell updateWithModel:model];
    
    [[DownloadSingleton shareInstance].downloadQueue enumerateObjectsUsingBlock:^(NWDownLoad *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.model.title isEqualToString:model.title]) {
            cell.nwDownload = obj;
            *stop = YES;
        }
    }];
    
    cell.pViewController = self;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VoiceDetailModel *model = _mArr[indexPath.row];
    
    if (_segmentControl.selectedSegmentIndex == 0) {
        [self.delegate.playBottomBar playWithModel:model andModels:_mArr];
    }
    else if (_segmentControl.selectedSegmentIndex == 1) {
        if (model.finished) {
            return;
        }
        
        DownloadVoiceDetailCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell.nwDownload) {
            [DownloadSingleton startDownloadModel:model];
            [tableView reloadData];
            return;
        }
        
        if ([cell.nwDownload downing]) {
            [cell.nwDownload cancel];
        }
        else {
            [cell.nwDownload startRequest];
        }
    }
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
    [self p_deleteDownloadFile:indexPath];
}

- (void)p_deleteDownloadFile:(NSIndexPath *)indexPath {
    VoiceDetailModel *model = _mArr[indexPath.row];
    [DataBaseServer deleteDownload:model];
    [CommonHelper deleteDownloadFile:model.savePath];
    [_mArr removeObject:model];
    DownloadVoiceDetailCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    [[DownloadSingleton shareInstance] remove:cell.nwDownload];
    [_tableView reloadData];
}

@end
