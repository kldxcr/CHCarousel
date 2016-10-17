//
//  NSString+TextInput.h
//  XQBrowser
//
//  Created by kevinxu on 7/16/13.
//  Copyright (c) 2013 kevinxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface NSString (TextInput)

/**
 *  是否包含Emoji表情
 */
+ (BOOL)stringContainsEmoji:(NSString *)string;

- (BOOL)isEmptyText;

- (BOOL)isNumber;

- (BOOL)spaceCharacterExist;

- (NSString *)deleteAllSpace;

- (CGFloat)widthOfStringByfont:(CGFloat)font;
- (CGFloat)widthOfStringByfont:(CGFloat)font
                          Size:(CGSize)size
                        Option:(NSStringDrawingOptions)option
                    Attributes:(NSDictionary *)attributes;

- (CGFloat)heightOfStringByFont:(CGFloat)font width:(CGFloat)width;
@end
