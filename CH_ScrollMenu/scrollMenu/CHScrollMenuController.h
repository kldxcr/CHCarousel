//
//  CHScrollMenuController.h
//  CH_ScrollMenu
//
//  Created by CH on 16/10/9.
//  Copyright © 2016年 CH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CHScrollMenuDelegate;
@interface CHScrollMenuController : UIViewController
@property (nonatomic, weak) id<CHScrollMenuDelegate> scrollMenuDelegate;
///////require setting///////
@property (nonatomic, strong) NSArray *menuTitleArray;//菜单标题数组，最后调用
@property(nonatomic, copy) NSString *showMenuButton_Image_Down;//选择框默认出图片
@property(nonatomic, copy) NSString *showMenuButton_Image_Up;//选择框弹出图片
@property(nonatomic, copy) NSString *maskImage;//showMenu的mask
///////option setting////////
@property (nonatomic, assign) NSInteger firstShowIndex;//初始化时展示的位置，default=0
@property (nonatomic, assign) BOOL isShowMenuButton;//增加九宫格选择框，default=NO
@property (nonatomic, assign) BOOL isKeepMenuCellTitleCenter;//菜单标题是否保持中间，default=YES
//Color Image
@property (nonatomic, assign) UIColor *menuCellTextColor;//菜单文本颜色
@property (nonatomic, assign) UIColor *menuCellTextColor_h;//菜单文本高亮色
@property (nonatomic, assign) UIColor *menuScrollBgColor;//菜单滚动试图背景色
@property (nonatomic, assign) UIColor *followLineBgColor;//跟随滚动线的背景色
@property (nonatomic, assign) UIColor *chooseButtonBgColor;//选择弹框中菜单的背景色
@property (nonatomic, assign) UIColor *chooseButtonBgColor_h;//选择弹框中菜单的背景高亮色

@end

@protocol CHScrollMenuDelegate <NSObject>

- (NSUInteger)numberOfItemsInScrollMenu;

- (UIViewController *)scrollMenu:(CHScrollMenuController *)scrollMenu
                VCForItemAtIndex:(NSInteger)index;

@end
