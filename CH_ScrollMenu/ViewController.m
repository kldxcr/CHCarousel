//
//  ViewController.m
//  CH_ScrollMenu
//
//  Created by CH on 16/10/9.
//  Copyright © 2016年 CH. All rights reserved.
//

#import "ViewController.h"
#import "CHScrollMenuController.h"
#import "CHTableViewController.h"
#import "CHDataMarcos.h"
#import "CHScrollRepeatView.h"

@interface ViewController ()<CHScrollMenuDelegate>
@property (nonatomic, strong) CHScrollRepeatView *repeatView;
@property (nonatomic, strong) CHScrollMenuController *scrollMenuC;
@property (nonatomic, strong) NSArray *menuTitleArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //展示轮播图
    [self showRepeatScrollView];
    
    //展示有菜单的多页面滚动试图
//    [self showScrollMenuController];
}

- (void)showRepeatScrollView {
    _repeatView = [[CHScrollRepeatView alloc] initWithFrame:CGRectMake(0, 0, CH_ScreenWidth, 200)];
    [_repeatView setPageArray:@[@"image0", @"image1", @"image2", @"image3"]];
    [self.view addSubview:_repeatView];
}

- (void)showScrollMenuController {
    _menuTitleArray = @[@"abc", @"123", @"新闻", @"网易", @"2345", @"王健林王思聪", @"1", @"哈哈哈哈哈哈哈哈哈😄", @"abc", @"123", @"新闻", @"网易", @"2345", @"王健林王思聪", @"1", @"哈哈哈哈哈哈哈哈哈😄"];
    
    _scrollMenuC = [CHScrollMenuController new];
    _scrollMenuC.view.frame = CGRectMake(0, 100, CH_ScreenWidth, CH_ScreenHeight-100);
    _scrollMenuC.scrollMenuDelegate = self;
    //setting
    //    _scrollMenuC.firstShowIndex = 2;
    _scrollMenuC.isShowMenuButton = YES;
    _scrollMenuC.showMenuButton_Image_Down = @"forum_btn_unfold";
    _scrollMenuC.showMenuButton_Image_Up = @"forum_btn_packup";
    _scrollMenuC.maskImage = @"forum_scrollmenu_mask";
    [self.view addSubview:_scrollMenuC.view];
    _scrollMenuC.menuTitleArray = _menuTitleArray;
}

- (NSUInteger)numberOfItemsInScrollMenu {
    return _menuTitleArray.count;
}

- (UIViewController *)scrollMenu:(CHScrollMenuController *)scrollMenu VCForItemAtIndex:(NSInteger)index {
    CHTableViewController *tableVC = [CHTableViewController new];
    tableVC.cellTitle = _menuTitleArray[index];
    return tableVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
