//
//  CHScrollRepeatView.h
//  CH_ScrollMenu
//
//  Created by CH on 16/10/14.
//  Copyright © 2016年 CH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHScrollRepeatView : UIView
@property (nonatomic, strong) UIScrollView *repeatScrollView;//滚动试图
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *pageArray;//数据源
///////option setting////////
@property (nonatomic, assign) CGFloat intervalTime;//滚动间隔时间
@end
