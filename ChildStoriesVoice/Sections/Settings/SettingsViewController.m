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
    [self createLeftButtonWithTitle:nil withLeftImage:[UIImage imageNamed:@"ArrowLeft"]];
    
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.f;
}

@end
