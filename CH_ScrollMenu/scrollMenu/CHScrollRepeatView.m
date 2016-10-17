//
//  CHScrollRepeatView.m
//  CH_ScrollMenu
//
//  Created by CH on 16/10/14.
//  Copyright © 2016年 CH. All rights reserved.
//

#import "CHScrollRepeatView.h"
#import "CHDataMarcos.h"

#define defaultPage 2

@interface CHScrollRepeatView()<UIScrollViewDelegate>
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) CGFloat currentContentHeight;//当前滚动试图高度
@property (nonatomic, assign) CGFloat currentContentWidth;//宽度
@end

@implementation CHScrollRepeatView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _currentContentWidth = self.bounds.size.width;
        _currentContentHeight = self.bounds.size.height;
        
        [self addSubview:self.repeatScrollView];
        
        [self addSubview:self.pageControl];
    }
    return self;
}

- (UIScrollView *)repeatScrollView {
    if (!_repeatScrollView) {
        _repeatScrollView = [UIScrollView new];
        _repeatScrollView.frame = self.bounds;
        _repeatScrollView.showsHorizontalScrollIndicator = NO;
        _repeatScrollView.showsVerticalScrollIndicator = NO;
        _repeatScrollView.alwaysBounceHorizontal = YES;
        _repeatScrollView.delegate = self;
        _repeatScrollView.pagingEnabled = YES;
        _repeatScrollView.contentSize = CGSizeMake(_currentContentWidth * defaultPage, _currentContentHeight);
    }
    return _repeatScrollView;
}

- (UIImageView *)CHImageView {
    UIImageView *imageView = [UIImageView new];
    imageView.backgroundColor = [UIColor redColor];
    [imageView setImage:[UIImage imageNamed:@"img_nodata"]];
    return imageView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [UIPageControl new];
        _pageControl.center = CGPointMake(_currentContentWidth * 0.5, _currentContentHeight - 15);  // 设置pageControl的位置
        _pageControl.numberOfPages = defaultPage;//默认2张，更新数据源再更新真实数量
        _pageControl.hidesForSinglePage = YES;
        _pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
        _pageControl.pageIndicatorTintColor = [UIColor yellowColor];
    }
    return _pageControl;
}

- (void)setPageArray:(NSArray *)pageArray {
    NSInteger pageCount = pageArray.count;
    _pageArray = pageArray;
    if (CH_DATA_ARRAY(pageArray) && pageCount) {
        _repeatScrollView.contentSize = CGSizeMake(_currentContentWidth * pageCount, _currentContentHeight);
        //更新pageControler
        self.pageControl.numberOfPages = pageCount;
        //创建图片控件
        for (int i = 0; i < pageCount; i++) {
            UIImageView *imageView = [self CHImageView];
            imageView.frame = CGRectMake(i * _currentContentWidth, 0, _currentContentWidth, _currentContentHeight);
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:pageArray[i] ofType:@"jpg"];
            UIImage *appleImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
            [imageView setImage:appleImage];
//            [imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL  URLWithString:_pageArray[i]] options:0 error:nil] scale:1.0]];
            [_repeatScrollView addSubview:imageView];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //滚动到了Page
    int currentPage = (scrollView.contentOffset.x + _currentContentWidth*0.5) / _currentContentWidth;
    if (currentPage == _currentPage) {
        //更新pageController
        _pageControl.currentPage = currentPage;
    }
    _currentPage = currentPage;
}

@end
