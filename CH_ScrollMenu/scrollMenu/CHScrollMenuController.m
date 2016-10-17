//
//  CHScrollMenuController.m
//  CH_ScrollMenu
//
//  Created by CH on 16/10/9.
//  Copyright © 2016年 CH. All rights reserved.
//

#import "CHScrollMenuController.h"
#import "NSString+TextInput.h"

#define equalWidthCount 3//这个数量下，等分宽度

#define menuMargin 20//menuCell文字的左右间距之和
#define menuButtonWidth 44//menuScrollView 中每个菜单的高度
#define menuCellTag 1000//每个菜单的基tag
#define menuScrollViewTag 2001//滚动菜单试图的tag
#define contentScrollViewTag 2002//内容页的tag

#define followLineHeight 2//跟随线的高度
#define followLineLeftInset 5//跟随线相对文本的左边距

#pragma mark - 选择弹框配置
#define kCountOfLine 4 //每行显示的菜单数量，动态改变弹框高度
#define kChooseTagViewTitle @"切换频道"
#define kChooseTagButtonH 35.0
#define kChooseTagLeftMargin 15.0
#define kChooseTagButtonMargin 7.0
#define kCommonElementH 44.0
#define kButtonStartTag 666
#define kBtnCornerRadius 3

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define ch_Random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]

#define ch_RandomColor ch_Random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#define CH_DATA_ARRAY(property)     [(property) isKindOfClass:[NSArray class]]


@interface CHScrollView : UIScrollView <UIGestureRecognizerDelegate>

@end

@implementation CHScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer {
    //处理返回手势冲突问题
    return [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]];
}

@end

@interface CHScrollMenuController ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) BOOL isClickMenu;//用户点击菜单出发的内容页滚动

@property (nonatomic, assign) CGFloat contentSize_Width;//试图数*屏幕宽
@property (nonatomic, assign) CGFloat currentContentX;  //当前滚动试图的X值
@property (nonatomic, assign) CGFloat currentContentY;
@property (nonatomic, assign) CGFloat currentContentHeight;//当前滚动试图高度
@property (nonatomic, assign) CGFloat currentContentWidth;//宽度

@property (nonatomic, strong) NSMutableDictionary *menuDicM;
@property (nonatomic, strong) NSMutableDictionary *pageDicM;//所有Page和index的对应字典

//isShowMenuButton=YES:包含右侧按钮的View(menuScrollView+showMenuButton)
@property (nonatomic, strong) UIView *menuButtonScrollView;
@property (nonatomic, strong) UIButton *showMenuButton;//增加九宫格选择框的右侧按钮
@property (nonatomic, strong) UIButton *overLayView;//蒙层遮盖
@property (nonatomic, strong) UIButton *chooseButton;//纪录选中的菜单按钮
@property (nonatomic, assign) CGFloat chooseTagViewH;//选择区域的高度
@property (nonatomic, strong) UIView *chooseTagView;//弹框九宫格

@property (nonatomic, strong) UIView *followLine;//跟随高亮标题的线

@property (nonatomic, strong) CHScrollView *menuScrollView;//菜单滚动内容区域
@property (nonatomic, strong) CHScrollView *contentScrollView;//页面滚动内容区域

@end

@implementation CHScrollMenuController

#pragma mark - init

- (void)viewDidLoad {
    [super viewDidLoad];
    _isKeepMenuCellTitleCenter = YES;
    // Do any additional setup after loading the view.
    _currentContentX = 0.0;
    _currentContentY = menuButtonWidth;//菜单栏高度、内容页Y值
    _currentContentWidth = self.view.bounds.size.width;
    _currentContentHeight = self.view.bounds.size.height - _currentContentY;
    
    _pageDicM = [NSMutableDictionary new];
    _menuDicM = [NSMutableDictionary new];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.contentScrollView.scrollEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazy load

- (UIScrollView *)menuScrollView {
    if (!_menuScrollView) {
        _menuScrollView = [CHScrollView new];
        _menuScrollView.tag = menuScrollViewTag;
        _menuScrollView.frame = CGRectMake(0, 0, _currentContentWidth, _currentContentY);
        _isShowMenuButton = [_menuTitleArray count] <= equalWidthCount ? NO : _isShowMenuButton;
        if (_isShowMenuButton) {
            _menuScrollView.frame = CGRectMake(0, 0, _currentContentWidth-menuButtonWidth, _currentContentY);
        }
        _menuScrollView.backgroundColor =
        _menuScrollBgColor ? _menuScrollBgColor : UIColorFromRGB(0xf8f8f8);
        _menuScrollView.showsHorizontalScrollIndicator = NO;
        _menuScrollView.alwaysBounceHorizontal = YES;
        _menuScrollView.delegate = self;
    }
    return _menuScrollView;
}

- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [CHScrollView new];
        _contentScrollView.tag = contentScrollViewTag;
        _contentScrollView.frame = self.view.bounds;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.delegate = self;
    }
    return _contentScrollView;
}

- (UIView *)menuButtonScrollView {
    if (!_menuButtonScrollView) {
        _menuButtonScrollView = [UIView new];
        _menuButtonScrollView.frame = CGRectMake(0, 0, _currentContentWidth, _currentContentY);
        _menuButtonScrollView.backgroundColor = [UIColor whiteColor];
    }
    return _menuButtonScrollView;
}

- (UIView *)followLine {
    if (!_followLine) {
        _followLine = [UIView new];
        _followLine.backgroundColor =
        _followLineBgColor ? _followLineBgColor : UIColorFromRGB(0x3097fd);
    }
    return _followLine;
}

- (UIButton *)showMenuButton {
    if (!_showMenuButton) {
        _showMenuButton = [[UIButton alloc] initWithFrame:CGRectMake(_menuButtonScrollView.bounds.size.width - menuButtonWidth, 0, menuButtonWidth, _currentContentY)];
        _showMenuButton.backgroundColor =
        _menuScrollBgColor ? _menuScrollBgColor : UIColorFromRGB(0xf8f8f8);//这里保持一致
        [_showMenuButton setImage:[UIImage imageNamed:_showMenuButton_Image_Down ? _showMenuButton_Image_Down : nil] forState:UIControlStateNormal];
        [_showMenuButton addTarget:self action:@selector(showMenuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat maskWidth = 10;
        UIImageView *maskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_showMenuButton.bounds.size.width-menuButtonWidth-maskWidth, 0, maskWidth, 40)];
        [maskImageView setImage:[UIImage imageNamed:_maskImage ? _maskImage : nil]];
        [self set:maskImageView CenterY:[self centerYOfView:_showMenuButton]];
        [_showMenuButton addSubview:maskImageView];
    }
    return _showMenuButton;
}

- (UIButton *)newButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [button setTitleColor:UIColorFromRGB(0x333333)
                 forState:UIControlStateNormal];
    UIColor *chooseButtonBgColor = _chooseButtonBgColor ? _chooseButtonBgColor : UIColorFromRGB(0xf2f2f2);
    UIColor *chooseButtonBgColor_h = _chooseButtonBgColor ? _chooseButtonBgColor : UIColorFromRGB(0x3097fd);
    [button setBackgroundImage:[self CH_imageWithColor:chooseButtonBgColor]
                      forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor whiteColor]
                 forState:UIControlStateSelected];
    [button setBackgroundImage:[self CH_imageWithColor:chooseButtonBgColor_h]
                      forState:UIControlStateSelected];
    
    button.layer.cornerRadius = kBtnCornerRadius;
    button.layer.masksToBounds = YES;
    
    return button;
}

#pragma mark - private method

- (void)setMenuTitleArray:(NSArray *)menuTitleArray {
    
    NSInteger menuCount = menuTitleArray.count;
    
    _menuTitleArray = menuTitleArray;
    
    [self.view addSubview:self.contentScrollView];
    
    [self.menuScrollView addSubview:self.followLine];
    
    _isShowMenuButton = menuCount <= equalWidthCount ? NO : _isShowMenuButton;
    
    if (_isShowMenuButton) {
        [self.view addSubview:self.menuButtonScrollView];
        
        [_menuButtonScrollView addSubview:_menuScrollView];

        [_menuButtonScrollView addSubview:self.showMenuButton];
    }
    else {
        [self.view addSubview:_menuScrollView];
        
    }
    //在设置完view的frame之后再去设置
    _currentContentHeight = self.view.bounds.size.height - _currentContentY;
    
    if (CH_DATA_ARRAY(menuTitleArray) && menuCount) {
        _contentSize_Width = _currentContentWidth * menuCount;
        _contentScrollView.contentSize = CGSizeMake(_currentContentWidth * menuCount, _currentContentHeight);
        
        CGFloat menuWidth = 0.0;
        for (int i = 0; i < menuCount; i++) {
            
            //初始化menuScrollView数据
            
            CGFloat menuCellWidth = 0.0;
            if (menuCount <= equalWidthCount) {
                menuCellWidth = _currentContentWidth / menuCount;//等分宽度
                
            } else {
                menuCellWidth = menuMargin + [menuTitleArray[i] widthOfStringByfont:18.0];
            }
            UIButton *menuCell = [UIButton new];
            menuCell.tag = menuCellTag + i;
            menuCell.frame = CGRectMake(menuWidth, 0, menuCellWidth, _currentContentY);
            [menuCell setTitle:menuTitleArray[i] forState:UIControlStateNormal];
            [menuCell.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
            menuCell.titleLabel.textAlignment = NSTextAlignmentCenter;
            [menuCell setTitleColor:_menuCellTextColor ? _menuCellTextColor : UIColorFromRGB(0x222222) forState:UIControlStateNormal];
            [menuCell setTitleColor:_menuCellTextColor_h ? _menuCellTextColor_h : UIColorFromRGB(0x3097fd) forState:UIControlStateSelected];
            [menuCell addTarget:self action:@selector(clickMenuCell:) forControlEvents:UIControlEventTouchUpInside];
            [_menuScrollView addSubview:menuCell];
            [_menuDicM setObject:menuCell forKey:[NSString stringWithFormat:@"%d",i]];
            menuWidth += menuCellWidth;
            
            //初始化contentScrollView数据
            
            if (_scrollMenuDelegate && [self.scrollMenuDelegate respondsToSelector:@selector(scrollMenu:VCForItemAtIndex:)]) {
                //初始化时只加载第一页
                if (_firstShowIndex == i) {
                    //初始化followLine在第一个title的位置
                    _followLine.frame = CGRectMake(0, _currentContentY-followLineHeight, menuCellWidth-2*followLineLeftInset, followLineHeight);
                    [self set:_followLine CenterX:[self centerXOfView:menuCell]];
                    //创建页面
                    [self createVCToPageDicMAtIndex:i];
                    //首次触发
                    [self changeChooseTagButton:nil];

                    [self clickMenuCell:menuCell];
                }
            }
        }
        _menuScrollView.contentSize = CGSizeMake(menuWidth, _currentContentY);
    }
}

//加载PageController
- (void)createVCToPageDicMAtIndex:(int)index {
    //若已经加载过了，就不加载了
    CGRect VCFrame = CGRectMake(index * _currentContentWidth, _currentContentY, _currentContentWidth, _currentContentHeight);
    //布局每一页
    UIViewController *VC = [_scrollMenuDelegate scrollMenu:self VCForItemAtIndex:index];
    VC.view.frame = VCFrame;
    //添加一个Page－Controller对象
    [_pageDicM setObject:VC forKey:[NSString stringWithFormat:@"%d",index]];
    [_contentScrollView addSubview:VC.view];
}

//点击菜单
- (void)clickMenuCell:(UIButton *)menuCell {
    NSInteger cellTag = menuCell.tag - menuCellTag;
    
    if (_currentPage != cellTag) {
        
        //复位上一个menuScrollView中的menuCell颜色
        UIButton *preMenuCell = [_menuDicM objectForKey:[NSString stringWithFormat:@"%d",_currentPage]];
        preMenuCell.selected = NO;
        
        //避免重复点击menu，导致页面卡顿
        _currentPage = (int)cellTag;
        _isClickMenu = YES;
        if (cellTag >= 0) {
            CGRect visibleRect = CGRectMake(cellTag * _currentContentWidth, _currentContentY, _currentContentWidth, _currentContentHeight);
            
            [_contentScrollView scrollRectToVisible:visibleRect animated:NO];
            
            if (_isKeepMenuCellTitleCenter) {
                
                [self centerShow];
            }
            else {
                //滑动结束后，判断menu是否完全在屏幕内（左右都在屏幕中）
                [_menuScrollView scrollRectToVisible:menuCell.frame animated:YES];
            }
        }
    }
}

//点击菜单按钮
- (void)showMenuButtonClick:(UIButton *)showButton {
    [self animationTagViewWithHidden:!self.chooseTagView.hidden];
}

#pragma mark - extension

- (CGFloat)centerXOfView:(UIView *)view {
    return view.frame.origin.x + view.frame.size.width / 2;
}

- (CGFloat)centerYOfView:(UIView *)view {
    return view.frame.origin.y + view.frame.size.height / 2;
}

- (void)set:(UIView *)view Top:(CGFloat)top {
    CGRect frame = view.frame;
    frame.origin.y = top;
    view.frame = frame;
}

- (void)set:(UIView *)view CenterX:(CGFloat)centerX {
    CGPoint center = view.center;
    center.x = centerX;
    view.center = center;
}

- (void)set:(UIView *)view CenterY:(CGFloat)centerY {
    CGPoint center = view.center;
    center.y = centerY;
    view.center = center;
}

- (void)set:(UIView *)view Width:(CGFloat)width {
    CGRect frame = view.frame;
    frame.size.width = width;
    view.frame = frame;
}

- (UIImage *)CH_imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    
    @autoreleasepool {
        
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return img;
    }
}

#pragma mark - chooseTagView

//chooseTagView动画
- (void)animationTagViewWithHidden:(BOOL)hidden {
    if (!_chooseTagView) {
        [self chooseTagView];
    }
    if (hidden) {
        [self.overLayView removeFromSuperview];
    }
    else {
        self.overLayView = [[UIButton alloc] initWithFrame:self.view.bounds];
        [_overLayView addTarget:self action:@selector(clickOverLay) forControlEvents:UIControlEventTouchUpInside];
        _overLayView.backgroundColor = [UIColor blackColor];
        _overLayView.alpha = 0.0;
        [self.view addSubview:self.overLayView];
        [self.view bringSubviewToFront:_chooseTagView];
    }
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (hidden) {
            [self set:_chooseTagView Top:-self.chooseTagViewH];
        }
        else {
            _overLayView.alpha = 0.3;
            _chooseTagView.hidden = NO;
            [self set:_chooseTagView Top:0];
        }
        _chooseTagView.userInteractionEnabled = NO;
        _menuScrollView.userInteractionEnabled = NO;
    } completion:^(BOOL finished) {
        if (hidden) {
            _chooseTagView.hidden = YES;
        }
        self.chooseTagView.userInteractionEnabled = YES;
        _menuScrollView.userInteractionEnabled = YES;
    }];
}

//隐藏选择tag界面
- (void)hideChooseTagView {
    [self animationTagViewWithHidden:YES];
}

- (UIView *)chooseTagView {
    if (!_chooseTagView) {
        self.chooseTagViewH = kCommonElementH + (kChooseTagButtonH+kChooseTagButtonMargin) * (_menuTitleArray.count / kCountOfLine + (_menuTitleArray.count % kCountOfLine != 0 ? 1:0));
        _chooseTagView = [[UIView alloc] initWithFrame:CGRectMake(0, -self.chooseTagViewH, _currentContentWidth, _chooseTagViewH)];
        _chooseTagView.backgroundColor = [UIColor whiteColor];
        //添加标题
        CGFloat maskWidth = 10;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kChooseTagLeftMargin, 0, _currentContentWidth-kChooseTagLeftMargin-kCommonElementH-maskWidth, kCommonElementH)];
        [titleLabel setText:kChooseTagViewTitle];
        [_chooseTagView addSubview:titleLabel];
        
        //按钮左边的阴影
        UIImageView *maskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_currentContentWidth-kCommonElementH-maskWidth, 0, maskWidth, kCommonElementH)];
        [maskImageView setImage:[UIImage imageNamed:_maskImage ? _maskImage : nil]];
        [self set:maskImageView CenterY:[self centerYOfView:titleLabel]];
        [_chooseTagView addSubview:maskImageView];
        
        UIButton *arrowsButton = [[UIButton alloc] initWithFrame:CGRectMake(_currentContentWidth - kCommonElementH, 0, kCommonElementH, kCommonElementH)];
        //这里通过两个位置显示不同的图片来实现方向的变化
        [arrowsButton setImage:[UIImage imageNamed:_showMenuButton_Image_Up ? _showMenuButton_Image_Up : nil] forState:UIControlStateNormal];
        [arrowsButton setContentMode:UIViewContentModeScaleAspectFit];
        [arrowsButton addTarget:self action:@selector(hideChooseTagView) forControlEvents:UIControlEventTouchUpInside];
        [_chooseTagView addSubview:arrowsButton];
        //添加新按钮
        CGFloat buttonWidth = (_currentContentWidth - kChooseTagLeftMargin * 2 - kChooseTagButtonMargin * (kCountOfLine - 1) ) / kCountOfLine;
        for (int i = 0; i < _menuTitleArray.count; ++i) {
            UIButton *button = [self newButton];
            [button setTitle:_menuTitleArray[i] forState:UIControlStateNormal];
            [button addTarget:self
                       action:@selector(changeForumTag:)
             forControlEvents:UIControlEventTouchUpInside];
            button.tag = i+kButtonStartTag;
            NSInteger section = i / kCountOfLine;
            NSInteger row = i % kCountOfLine;
            button.frame = CGRectMake(kChooseTagLeftMargin + (buttonWidth + kChooseTagButtonMargin) * row ,
                                      kCommonElementH + (kChooseTagButtonH + kChooseTagButtonMargin) * section,
                                      buttonWidth,
                                      kChooseTagButtonH);
            [_chooseTagView addSubview:button];
        }
        [self.view addSubview:_chooseTagView];
        [_chooseTagView setHidden:YES];
    }
    return _chooseTagView;
}

//更新menu选择框中选中tag的按钮
- (void)changeChooseTagButton:(UIButton *)newButton {
    if (newButton) {
        self.chooseButton.selected = NO;
        newButton.selected = YES;
        self.chooseButton = newButton;
        
        NSInteger index = newButton.tag - kButtonStartTag;
        UIButton *menuCell = [_menuDicM objectForKey:[NSString stringWithFormat:@"%ld",index]];
        menuCell.selected = YES;
        //更新followLine状态
        [UIView animateWithDuration:0.3 animations:^{
            [self set:_followLine Width:menuCell.bounds.size.width-2*followLineLeftInset];
            [self set:_followLine CenterX:[self centerXOfView:menuCell]];
        }];
    }
    else {
        UIButton *tagButton = (UIButton *)[self.chooseTagView viewWithTag:_currentPage+kButtonStartTag];
        if (tagButton) {
            [self changeChooseTagButton:tagButton];
        }
    }
}

//在选择框中选中新tag操作
- (void)changeForumTag:(UIButton *)tagButton {
    NSLog(@"changeForumTag");
    [self hideChooseTagView];
    
    //手动点击menuCell
    NSInteger buttonTag = tagButton.tag-kButtonStartTag;
    UIButton *menuCell = (UIButton *)[_menuDicM objectForKey:[NSString stringWithFormat:@"%ld",buttonTag]];
    [self clickMenuCell:menuCell];
}

//点击遮盖
- (void)clickOverLay {
    [self hideChooseTagView];
}

#pragma mark - scrollDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"scrollViewDidScroll");//位置变化
    if (scrollView.tag == menuScrollViewTag) {//_menuScrollView
        
    }
    else if (scrollView.tag == contentScrollViewTag) {//_contentScrollView
        //滚动到了Page
        int currentPage = (scrollView.contentOffset.x + _currentContentWidth*0.5) / _currentContentWidth;
        
        if (_isClickMenu) {
            //是手动点了菜单栏
            if (currentPage == _currentPage) {
                //点击的Page和滚动的Page相同，则加载新一页
                _isClickMenu = NO;
                //手动再次触发一次
                [self scrollViewDidScroll:scrollView];
            }
        }
        else {
            //只有到了新一页，才加载新一页的内容
            if (_scrollMenuDelegate && [self.scrollMenuDelegate respondsToSelector:@selector(scrollMenu:VCForItemAtIndex:)]) {
                //复位当前page位置
                UIButton *preMenuCell = [_menuDicM objectForKey:[NSString stringWithFormat:@"%d",_currentPage]];
                preMenuCell.selected = NO;
                
                if (_currentPage == currentPage) {
                    //更新followLine位置
                    
                    UIViewController *VC = [_pageDicM objectForKey:[NSString stringWithFormat:@"%d",currentPage]];
                    if (!VC) {
                        //创建新View
                        [self createVCToPageDicMAtIndex:currentPage];
                    }
                }
                _currentPage = currentPage;
                
                //更新选择框中的tag状态、更新menuCell状态
                [self changeChooseTagButton:nil];
                
            }
        }
    }
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    NSLog(@"1scrollViewWillBeginDragging");//开始滑动
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    NSLog(@"2scrollViewDidEndDragging");//手指离开屏幕
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"3scrollViewDidEndDecelerating");//动画结束
    if (scrollView.tag == menuScrollViewTag) {//_menuScrollView
        
    }
    else if (scrollView.tag == contentScrollViewTag) {//_contentScrollView
        _currentPage = (scrollView.contentOffset.x + _currentContentWidth*0.5) / _currentContentWidth;

        if (_isKeepMenuCellTitleCenter) {
            
            [self centerShow];
        }
        else {
            //滑动结束后，判断menu是否完全在屏幕内（左右都在屏幕中）
            UIButton *menuCell = [_menuDicM objectForKey:[NSString stringWithFormat:@"%d",_currentPage]];
            [_menuScrollView scrollRectToVisible:menuCell.frame animated:YES];
        }
    }
}

//保持当前标题在中间
- (void) centerShow {

    //滑动结束后，判断menu是否完全在屏幕内（左右都在屏幕中）
    
    //纪录当前menuCell的左右cell个数,动态实现扩展显示的数量
    int movePage_l = _currentPage < 2 ? _currentPage : 2 ;
    int movePage_r = _menuTitleArray.count - _currentPage <= 2 ? (int)_menuTitleArray.count - 1 - _currentPage : 2 ;
    
    UIButton *menuCell = [_menuDicM objectForKey:[NSString stringWithFormat:@"%d",_currentPage]];
    UIButton *menuCell_l = [_menuDicM objectForKey:[NSString stringWithFormat:@"%d",_currentPage-movePage_l]];
    UIButton *menuCell_r = [_menuDicM objectForKey:[NSString stringWithFormat:@"%d",_currentPage+movePage_r]];
    
    CGFloat offset = _menuScrollView.contentOffset.x;
    
    BOOL showRight = menuCell_r ? menuCell.frame.origin.x - offset > _currentContentWidth * 0.5 : NO;
    BOOL showLeft = menuCell_l ?  menuCell.frame.origin.x - offset < _currentContentWidth * 0.5: NO;
    
    
    if (showRight) {
        
            [_menuScrollView scrollRectToVisible:menuCell_r.frame animated:YES];
    }
    else if (showLeft) {
        
            [_menuScrollView scrollRectToVisible:menuCell_l.frame animated:YES];
    }
    else {
        
        [_menuScrollView scrollRectToVisible:menuCell.frame animated:YES];
    }

}

@end
