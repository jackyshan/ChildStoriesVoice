//
//  SearchViewController.m
//  ChildStoriesVoice
//
//  Created by jackyshan on 1/4/16.
//  Copyright © 2016 jackyshan. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultCell.h"
#import "SearchHeaderView.h"
#import "SearchHistoryCell.h"
#import "SearchTextField.h"
#import "NWSuggestSearch.h"

NSString * const kSearchHistoryCell = @"searchHistoryCell";
NSString * const kSearchResultCell = @"searchResultCell";

@interface SearchViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    UITextField *_searchField;
    NSString *_searchStr;
    NSMutableArray *_dataSearchArr;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataSearchArr = [NSMutableArray array];
    [self loadingData];
}

- (void)addSubviews {
    UITextField *searchField = [[SearchTextField alloc] initWithFrame:CGRectMake(0, 0, 260, 34)];
    searchField.clipsToBounds = YES;
    searchField.layer.cornerRadius = 3.f;
    searchField.returnKeyType = UIReturnKeySearch;
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.layer.borderWidth = 1.f;
    searchField.layer.borderColor = [ColorHelper colorWithHexString:@"#e0e0e0"].CGColor;
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 34)];
    [searchBtn setImage:[UIImage imageNamed:@"icon_search_glass"]];
    searchField.leftView = searchBtn;
    searchField.leftViewMode = UITextFieldViewModeAlways;
    searchField.placeholder = @"请输入搜索内容...";
    searchField.textAlignment = NSTextAlignmentLeft;
    searchField.font = [UIFont systemFontOfSize:12.f];
    searchField.backgroundColor = [UIColor whiteColor];
    searchField.tintColor = [ColorHelper colorWithHexString:@"#e0e0e0"];
    searchField.delegate = self;
    self.navigationItem.titleView = searchField;
    [searchField becomeFirstResponder];
    _searchField = searchField;
    
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [ColorHelper colorWithHexString:@"#ecebe8"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        SearchHeaderView *headView = [[SearchHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 160)];
        _tableView.tableHeaderView = headView;
        
        [_tableView registerClass:[SearchHistoryCell class] forCellReuseIdentifier:kSearchHistoryCell];
        [_tableView registerClass:[SearchResultCell class] forCellReuseIdentifier:kSearchResultCell];
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
    _searchStr = [_searchStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!_searchStr || [_searchStr isEqualToString:@""]) {
        return;
    }
    
    [_dataSearchArr removeAllObjects];
    NWSuggestSearch *suggestSearch = [[NWSuggestSearch alloc] init];
    [suggestSearch setCompletion:^(NSArray *arr, BOOL succ) {
        if (succ) {
            [_dataSearchArr addObjectsFromArray:arr];
            [_tableView reloadData];
        }
    }];
    [suggestSearch startRequestWithParams:@{@"condition":_searchStr}];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataSearchArr.count > 0) {
        return _dataSearchArr.count;
    }
    else {
        return 13;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataSearchArr.count > 0) {
        SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchResultCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell updateWithModel:_dataSearchArr[indexPath.row]];
        return cell;
    }
    else {
        SearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchHistoryCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [_searchField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    _searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self loadingData];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    _searchStr = textField.text;
    
    return YES;
}

@end
