//
//  AppDelegate.m
//  CH_ScrollMenu
//
//  Created by CH on 16/10/9.
//  Copyright © 2016年 CH. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreSpotlight/CoreSpotlight.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self configureSpotlight];
    
    [self configure3Dtouch];
    // Override point for customization after application launch.
    return YES;
}

- (void)configureSpotlight {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        @try {
            NSArray *temp = @[@"宫崎骏-龙猫", @"宫崎骏-千与千寻", @"宫崎骏-天空之城"];
            
            //创建SearchableItems的数组
            NSMutableArray *searchableItems = [[NSMutableArray alloc] initWithCapacity:temp.count];
            
            for (int i = 0; i < temp.count; i ++) {
                
                //1.创建条目的属性集合
                CSSearchableItemAttributeSet * attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString*) kUTTypeImage];
                
                //2.给属性集合添加属性
                attributeSet.title = temp[i];
                attributeSet.contentDescription = [NSString stringWithFormat:@"宫崎骏与%@", temp[i]];
                attributeSet.thumbnailData = UIImagePNGRepresentation([UIImage imageNamed:@"3Dtouch_details"]);
                
                //3.属性集合与条目进行关联
                CSSearchableItem *searchableItem = [[CSSearchableItem alloc] initWithUniqueIdentifier:[NSString stringWithFormat:@"%d", i+1] domainIdentifier:@"ch.SpotlightSearchDemo" attributeSet:attributeSet];
                
                //把该条目进行暂存
                [searchableItems addObject:searchableItem];
            }
            
            //4.吧条目数组与索引进行关联
            [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:searchableItems completionHandler:^(NSError * _Nullable error) {
                if (!error) {
                    NSLog(@"%s, %@", __FUNCTION__, [error localizedDescription]);
                }
            }];
        }
        @catch (NSException *exception) {
            NSLog(@"%s, %@", __FUNCTION__, exception);
        }
        @finally {
            
        }
    });
}

- (void)configure3Dtouch {
    
    UIApplicationShortcutItem *item1 =
    [[UIApplicationShortcutItem alloc] initWithType:@"3Dtouch_gift"
                                     localizedTitle:@"特价礼品"
                                  localizedSubtitle:nil
                                               icon:
     [UIApplicationShortcutIcon iconWithTemplateImageName:@"3Dtouch_gift"]
                                           userInfo:nil];
    
    UIApplicationShortcutItem *item2 =
    [[UIApplicationShortcutItem alloc] initWithType:@"3Dtouch_details"
                                     localizedTitle:@"查工资"
                                  localizedSubtitle:nil
                                               icon:
     [UIApplicationShortcutIcon iconWithTemplateImageName:@"3Dtouch_details"]
                                           userInfo:nil];
    
    UIApplicationShortcutItem *item3 =
    [[UIApplicationShortcutItem alloc] initWithType:@"3Dtouch_signin"
                                     localizedTitle:@"签到"
                                  localizedSubtitle:nil
                                               icon:
     [UIApplicationShortcutIcon iconWithTemplateImageName:@"3Dtouch_signin"]
                                           userInfo:nil];
    
    [UIApplication sharedApplication].shortcutItems = @[item1, item2, item3];
}

#pragma mark - 3Dtouch回调

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    
    if ([shortcutItem.type isEqualToString:@"3Dtouch_gift"]) {
        
    }
    else if ([shortcutItem.type isEqualToString:@"3Dtouch_details"]) {
        
    }
    else if ([shortcutItem.type isEqualToString:@"3Dtouch_signin"]) {
        
    }
}

#pragma mark - spotlight回调

- (BOOL)application:(nonnull UIApplication *)application continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray * __nullable))restorationHandler{
    
    NSString *idetifier = userActivity.userInfo[@"kCSSearchableItemActivityIdentifier"];
    
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    
//    ViewController *vc = [navigationController viewControllers][0];
//    [vc.myImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",idetifier]]];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
