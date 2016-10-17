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
#import "SDCycleScrollView.h"

@interface ViewController ()<CHScrollMenuDelegate>
@property (nonatomic, strong) SDCycleScrollView *circelView;
@property (nonatomic, strong) NSArray *circelArray;
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
    _circelArray = @[@"image0", @"image1", @"image2", @"image3"];
    NSMutableArray *imageArray = [NSMutableArray new];
    for (NSString *imageName in _circelArray) {
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
        [imageArray addObject:image];
    }
    _circelView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, CH_ScreenWidth, 180) shouldInfiniteLoop:YES imageNamesGroup:nil];
    _circelView.placeholderImage = [UIImage imageNamed:@"img_nodata"];
    _circelView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _circelView.autoScrollTimeInterval = 2.0;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _circelView.localizationImageNamesGroup = imageArray;
    });
    [self.view addSubview:_circelView];
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

#pragma mark - CircleDelegate

- (NSInteger)numberForViews {
    return _circelArray.count;
}

- (UIView *)viewAtIndex:(NSInteger)index {
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:_circelArray[index] ofType:@"jpg"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    return imageView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
