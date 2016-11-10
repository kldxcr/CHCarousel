//
//  CHTextField.m
//  CH_ScrollMenu
//
//  Created by CH on 16/11/9.
//  Copyright © 2016年 CH. All rights reserved.
//

#import "CHTextField.h"

@implementation CHTextField

-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)paste:(id)sender {
    
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    /*
     if (action == @selector(paste:))//禁止粘贴
     return NO;
     if (action == @selector(select:))// 禁止选择
     return NO;
     if (action == @selector(selectAll:))// 禁止全选
     return NO;
     return [super canPerformAction:action withSender:sender];
     */
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

@end
