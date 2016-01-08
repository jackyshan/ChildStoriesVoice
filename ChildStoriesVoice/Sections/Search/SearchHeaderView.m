//
//  SearchHeaderView.m
//  ChildStoriesVoice
//
//  Created by jackyshan on 1/6/16.
//  Copyright © 2016 jackyshan. All rights reserved.
//

#import "SearchHeaderView.h"
#import "ColorHelper.h"
#import "InputHelper.h"
#import "UIView+FrameHelper.h"
#import "ProjectHelper.h"
#import "SearchModel.h"

#define kBtnTag 9999

@interface SearchHeaderView()<UIScrollViewDelegate> {
    UIPageControl *_pageControl;
    
    NSArray *_dataArr;
}

@end

@implementation SearchHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [ColorHelper colorWithHexString:@"#f1f1f1"];
        
        UILabel *titleLb = [InputHelper createLabelWithFrame:CGRectMake(21, 8, 150, 14) title:@"推荐搜索" textColor:[ColorHelper colorWithHexString:@"#666666"] bgColor:[UIColor clearColor] fontSize:14.f textAlignment:NSTextAlignmentLeft addToView:self bBold:NO];
        
        UIScrollView *scrollView = nil;
        if([[UIDevice currentDevice] userInterfaceIdiom ] == UIUserInterfaceIdiomPhone ) {
            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,  titleLb.buttom + 8, self.width, 102)];
            scrollView.pagingEnabled = YES;
            //IPhone设备
            
        }else{
            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,  titleLb.buttom + 8, self.width, 65)];
            //ipad设备
        }

        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        [self addSubview:scrollView];
        
        _dataArr = [ProjectHelper getSearchRecommend];
        
        CGFloat x = 10, y = 0, width = 96, height = 29;
        NSInteger idx = 1;
        for (int i = 0; i < _dataArr.count; i ++) {
            SearchModel *model = _dataArr[i];
            UIButton *searchBtn = [InputHelper createButtonWithTitle:model.title textColor:[ColorHelper colorWithHexString:@"#666666"] bgColor:[UIColor whiteColor] bgColorHigh:[UIColor clearColor] fontSize:12.f target:self action:nil tag:i+kBtnTag addToView:scrollView frame:CGRectMake(x, y, width, height) supportAotuLayout:NO];
            [searchBtn addTarget:self action:@selector(tapSearch:) forControlEvents:UIControlEventTouchUpInside];
            searchBtn.clipsToBounds = YES;
            searchBtn.layer.cornerRadius = 3.f;
            
            x = searchBtn.right + 6;
            
            if (x + 4 == scrollView.width * idx) {
                x = scrollView.width * (idx - 1) + 10;
                y = searchBtn.buttom + 6;
                scrollView.contentSize = CGSizeMake(scrollView.width * idx, 0);
                
                if (y > scrollView.height) {
                    x = scrollView.width * idx + 10;
                    idx++;
                    y = 0;
                }
            }
            else if (scrollView.height == 65.f) {
                scrollView.contentSize = CGSizeMake(searchBtn.right+10, 0);
            }
        }
        
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, scrollView.buttom + 9, self.width, 8)];
        pageControl.currentPageIndicatorTintColor = COLOR_32393D;
        pageControl.pageIndicatorTintColor = COLOR_GRAY;
        pageControl.numberOfPages = (int)scrollView.contentSize.width / scrollView.width;
        [self addSubview:pageControl];
        _pageControl = pageControl;
    }
    
    return self;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControl.currentPage = scrollView.contentOffset.x / scrollView.width;
}

- (void)tapSearch:(UIButton *)sender {
    NSInteger idx = sender.tag - kBtnTag;
    
    SearchModel *model = _dataArr[idx];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(goToSearchVC:)]) {
        [self.delegate goToSearchVC:model];
    }
}

@end
