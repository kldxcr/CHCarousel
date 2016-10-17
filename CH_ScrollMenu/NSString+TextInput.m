//
//  NSString+TextInput.m
//  XQBrowser
//
//  Created by kevinxu on 7/16/13.
//  Copyright (c) 2013 kevinxu. All rights reserved.
//

#import "NSString+TextInput.h"

@implementation NSString (TextInput)

+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    
    return returnValue;
}

- (BOOL)isNumber
{
    __block BOOL returnValue = YES;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        NSString *numberStr = @"0123456789.";
        if ([numberStr rangeOfString:substring].location == NSNotFound) {
            returnValue = NO;
            *stop = YES;
        }
    }];
    return returnValue;
}

- (BOOL)isEmptyText {
    if (self == nil || [@"" isEqualToString:[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]) {
        return YES;
    }
    return NO;
}

- (BOOL)spaceCharacterExist {
    if (self) {
        NSRange range = [self rangeOfString:@" "];
        if (range.location != NSNotFound) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)deleteAllSpace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (CGFloat)widthOfStringByfont:(CGFloat)font {
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                     options:options
                                  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]}
                                     context:nil];
    
    return rect.size.width;
}

- (CGFloat)widthOfStringByfont:(CGFloat)font
                          Size:(CGSize)size
                        Option:(NSStringDrawingOptions)option
                    Attributes:(NSDictionary *)attributes {
    CGSize rectSize = !size.width ? CGSizeMake(MAXFLOAT, MAXFLOAT) : size;
    NSStringDrawingOptions drawOption =
    !option ? NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading : option;
    NSDictionary *fontAttributes =
    ![attributes isKindOfClass:[NSDictionary class]] ? @{NSFontAttributeName : [UIFont systemFontOfSize:font]} : attributes;
    CGRect rect = [self boundingRectWithSize:rectSize
                                     options:drawOption
                                  attributes:fontAttributes
                                     context:nil];
    
    return rect.size.width;
}

- (CGFloat)heightOfStringByFont:(CGFloat)font width:(CGFloat)width
{
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:options
                                  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]}
                                     context:nil];
    
    return rect.size.height;
}

@end
