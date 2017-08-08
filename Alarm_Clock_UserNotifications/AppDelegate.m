    //
//  AppDelegate.m
//  Alarm_Clock_UserNotifications
//
//  Created by 欧阳荣 on 2017/5/12.
//  Copyright © 2017年 欧阳荣. All rights reserved.
//

#import "AppDelegate.h"
#import "UNNotificationsManager.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [UNNotificationsManager registerLocalNotification];
    
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    return YES;
}

#pragma mark -- UNUserNotificationCenterDelegate
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSLog(@"%s", __func__);
//    [self handCommnet:notification.request.]
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didReciveNotification" object:nil userInfo:@{@"idf" : notification.request.identifier}];
    completionHandler(UNNotificationPresentationOptionAlert + UNNotificationPresentationOptionSound + UNNotificationPresentationOptionBadge);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSLog(@"%s", __func__);
    [self handCommnet:response];
    completionHandler();
}

-(void)handCommnet:(UNNotificationResponse *)response
{
    NSString *actionIdef = response.actionIdentifier;
    NSDate *date;
    if ([actionIdef isEqualToString:actionStop]) {
        return;
    }else if ([actionIdef isEqualToString:actionFiveMin]) {
        date = [NSDate dateWithTimeIntervalSinceNow:5 * 60];
    }else if ([actionIdef isEqualToString:actionHalfAnHour]) {
        date = [NSDate dateWithTimeIntervalSinceNow:30 * 60];
    }else if ([actionIdef isEqualToString:actionOneHour]) {
        date = [NSDate dateWithTimeIntervalSinceNow:60 * 60];
    }
    
    if (date) {
        [UNNotificationsManager addNotificationWithContent:response.notification.request.content identifer:response.notification.request.identifier trigger:[UNNotificationsManager triggerWithDateComponents:[UNNotificationsManager componentsWithDate:date] repeats:NO] completionHanler:^(NSError *error) {
            NSLog(@"delay11111 %@", error);
        }];

    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didReciveNotification" object:nil userInfo:@{@"idf" : response.notification.request.identifier}];
    }
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
