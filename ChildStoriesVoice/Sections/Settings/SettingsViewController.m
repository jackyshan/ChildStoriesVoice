//
//  SettingsViewController.m
//  ChildStoriesVoice
//
//  Created by jackyshan on 12/25/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "SettingsViewController.h"
#import "ProjectHelper.h"
#import "SettingModel.h"
#import "PlayVoiceListVC.h"
#import "PlayVoiceLastedListVC.h"
#import "DownloadVoiceListVC.h"
#import "LovedVoiceListVC.h"
#import "CollectAlbumListVC.h"
#import "IAPHelper.h"

@interface SettingsViewController ()<UITableViewDataSource, UITableViewDelegate> {
    NSArray *_dataArr;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"设置";
    
    [self loadingData];
}

- (void)addSubviews {
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
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
    _dataArr = [ProjectHelper getSettingMenuModels];
    
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    SettingModel *model = _dataArr[section];
    return model.name;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SettingModel *model = _dataArr[section];
    return  model.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14.f];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
        cell.textLabel.textColor = COLOR_32393D;
        cell.detailTextLabel.textColor = COLOR_94999C;
    }
    
    SettingListModel *model = ((SettingModel*)_dataArr[indexPath.section]).list[indexPath.row];
    
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.detailTitle;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SettingListModel *model = ((SettingModel*)_dataArr[indexPath.section]).list[indexPath.row];
    if (model.type == 0) {
        PlayVoiceListVC *vc = [[PlayVoiceListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (model.type == 1) {
        PlayVoiceLastedListVC *vc = [[PlayVoiceLastedListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (model.type == 2) {
        DownloadVoiceListVC *vc = [[DownloadVoiceListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (model.type == 3) {
        LovedVoiceListVC *vc = [[LovedVoiceListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (model.type == 4) {
        CollectAlbumListVC *vc = [[CollectAlbumListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (model.type == 5) {
        [ProjectHelper buyIapProduct];
    }
    else if (model.type == 6) {
        [ProjectHelper restoreIapProduct];
    }
    else if (model.type == 7) {
        [ProjectHelper gotoAppStore];
    }
    else if (model.type == 8) {
        [ProjectHelper clearDiskCache];
    }
    else if (model.type == 9) {
        [[ProjectHelper shareInstance] reportBugForEmail];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.f;
}

@end
