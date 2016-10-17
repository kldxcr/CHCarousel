//
//  CHDataMarcos.h
//  CH_ScrollMenu
//
//  Created by CH on 16/10/9.
//  Copyright © 2016年 CH. All rights reserved.
//

#ifndef CHDataMarcos_h
#define CHDataMarcos_h

//--------------------------BASIC DATA--------------------------
#pragma mark - Basic Data
/**
 *  Analyzing the basic data types
 */
#define CH_DATA_NULL(property)                 [(property) isKindOfClass:[NSNull class]]
#define CH_DATA_ERROR(property)                [(property) isKindOfClass:[NSError class]]

#define CH_DATA_STRING(property)               ([(property) isKindOfClass:[NSString class]] && [property length] > 0)
#define CH_DATA_NUMBER(property)               [(property) isKindOfClass:[NSNumber class]]
#define CH_DATA_ARRAY(property)                [(property) isKindOfClass:[NSArray class]]
#define CH_DATA_DICTIONARY(property)           [(property) isKindOfClass:[NSDictionary class]]

#define CH_DATA_INTEGER(property)              (!CH_DATA_NULL(property) && [property integerValue] >= 0)
#define CH_DATA_FLOAT(property)                (!CH_DATA_NULL(property) && [property floatValue] >= 0)
#define CH_DATA_UINT(property)                 (!CH_DATA_NULL(property) && [property intValue] > 0)
//--------------------------BASIC DATA--------------------------

#define CH_SystemVersion ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define CH_iOS_9_OR_ABOVE (SystemVersion >= 9)
#define CH_iOS_10_OR_ABOVE (SystemVersion >= 10)

#define CH_ScreenWidth     CGRectGetWidth([UIScreen mainScreen].bounds)
#define CH_ScreenHeight    CGRectGetHeight([UIScreen mainScreen].bounds)

#define CH_AppKeyWindow    ([UIApplication sharedApplication].keyWindow)


#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]

#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))


#endif /* CHDataMarcos_h */
