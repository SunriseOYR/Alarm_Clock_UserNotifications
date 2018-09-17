//
//  UNotifivationManager.m
//  Alarm_Clock_UserNotifications
//
//  Created by 欧阳荣 on 2017/5/24.
//  Copyright © 2017年 欧阳荣. All rights reserved.
//

#import "UNNotificationsManager.h"

NSString * const UNDidReciveRemoteNotifationKey = @"UNDidReciveRemateNotifationKey";
NSString * const UNDidReciveLocalNotifationKey = @"UNDidReciveLocalNotifationKey";
NSString * const UNNotifationInfoIdentiferKey = @"UNNotifationInfoIdentiferKey";

@interface UNNotificationsManager ()<UNUserNotificationCenterDelegate>

@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end

@implementation UNNotificationsManager

+ (instancetype)shared {
    
    static UNNotificationsManager *manger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [UNNotificationsManager new];
    });
    return manger;
}

+ (void)registerLocalNotification API_AVAILABLE(ios(10.0)) {
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"request authorization succeeded!");
        }
    }];
    
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        NSLog(@"%@",settings);
    }];
    
    UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:actionFiveMin title:@"5分钟后" options:UNNotificationActionOptionNone];
    
    UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:actionHalfAnHour title:@"半小时后" options:UNNotificationActionOptionNone];
    UNNotificationAction *action3 = [UNNotificationAction actionWithIdentifier:actionOneHour title:@"1小时后" options:UNNotificationActionOptionNone];
    UNNotificationAction *action4 = [UNNotificationAction actionWithIdentifier:actionStop title:@"停止" options:UNNotificationActionOptionNone];
    
    
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:categryLaterIdf actions:@[action1, action2,action3, action4] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
    
    
    UNNotificationCategory *stopCategory = [UNNotificationCategory categoryWithIdentifier:categryStopIdf actions:@[action4] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
    
    [center setNotificationCategories:[NSSet setWithArray:@[category,stopCategory]]];
    
    [UNUserNotificationCenter currentNotificationCenter].delegate = [self shared];
}


#pragma mark -- public
+ (void)addNotificationWithRequest:(UNNotificationRequest *)requst completionHanler:(void (^)(NSError *))handler {
    
    dispatch_semaphore_t semaphore = [UNNotificationsManager shared].semaphore;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        [self getAllNotificationIdentiferBlock:^(NSArray<NSString *> *identifers) {
            
            if (identifers.count >= 64) {
                dispatch_semaphore_signal(semaphore);
                return;
            }
            [[self center] addNotificationRequest:requst withCompletionHandler:^(NSError * _Nullable error) {
                dispatch_semaphore_signal(semaphore);
                if (handler) {
                    handler(error);
                }
            }];
        }];
    });
    
//    [[self center] addNotificationRequest:requst withCompletionHandler:handler];
}

+ (void)addNotificationWithContent:(UNNotificationContent *)content identifer:(NSString *)identifer trigger:(UNNotificationTrigger *)trigger completionHanler:(void (^)(NSError *))handler {
    
    //设置 category
    UNMutableNotificationContent *aContent = [content mutableCopy];
//    if ([identifer hasPrefix:@"isLater"]) {
        aContent.categoryIdentifier = categryLaterIdf;

//    }else {
//        aContent.categoryIdentifier = categryStopIdf;
//    }
    
    [self addNotificationWithRequest:[UNNotificationRequest requestWithIdentifier:identifer content:aContent trigger:trigger] completionHanler:handler];
}

+ (void)addNotificationWithContent:(UNNotificationContent *)content dateComponents:(NSDateComponents *)components identifer:(NSString *)identifer isRepeat:(BOOL)repeat completionHanler:(void (^)(NSError *))handler {
    
    [self addNotificationWithContent:content identifer:identifer trigger:[self triggerWithDateComponents:components repeats:repeat] completionHanler:handler];
}

+ (void)addNotificationWithContent:(UNNotificationContent *)content interval:(NSTimeInterval)interval identifer:(NSString *)identifer isRepeat:(BOOL)repeat completionHanler:(void (^)(NSError *))handler {
    
    [self addNotificationWithContent:content identifer:identifer trigger:[self triggerWithTimeInterval:interval repeats:repeat] completionHanler:handler];
}

+ (void)addNotificationWithContent:(UNNotificationContent *)content weekDay:(NSInteger)weekDay date:(NSDate *)date identifer:(NSString *)identifer isRepeat:(BOOL)repeat completionHanler:(void (^)(NSError *))handler {
    [self addNotificationWithContent:content dateComponents:[self componentsWithDate:date weekday:weekDay] identifer:identifer isRepeat:repeat completionHanler:handler];
}

+ (void)addNotificationWithBody:(NSString *)body title:(NSString *)title subTitle:(NSString *)subTitle weekDay:(NSInteger)weekDay date:(NSDate *)date music:(NSString *)music identifer:(NSString *)identifer isRepeat:(BOOL)repeat completionHanler:(void (^)(NSError *))handler API_AVAILABLE(ios(10.0)) {
    
    UNNotificationContent *content = [self contentWithTitle:title subTitle:subTitle body:body sound:[UNNotificationSound soundNamed:music]];
    [self addNotificationWithContent:content weekDay:weekDay date:date identifer:identifer isRepeat:repeat completionHanler:handler];
}

+ (void)addRepeatEveryDayNotificationWithBody:(NSString *)body title:(NSString *)title subTitle:(NSString *)subTitle date:(NSDate *)date music:(NSString *)music identifer:(NSString *)identifer completionHanler:(void (^)(NSError *))handler API_AVAILABLE(ios(10.0)) {
    
    UNNotificationContent *content = [self contentWithTitle:title subTitle:subTitle body:body sound:[UNNotificationSound soundNamed:music]];
    [self addNotificationWithContent:content dateComponents:[self componentsEveryDayWithDate:date] identifer:identifer isRepeat:YES completionHanler:handler];
}

+ (void)addComponentsNotificationWithBody:(NSString *)body title:(NSString *)title subTitle:(NSString *)subTitle dateComponents:(NSDateComponents *)components music:(NSString *)music identifer:(NSString *)identifer isRepeat:(BOOL)repeat completionHanler:(void (^)(NSError *))handler API_AVAILABLE(ios(10.0)) {
    
    UNNotificationContent *content = [self contentWithTitle:title subTitle:subTitle body:body sound:[UNNotificationSound soundNamed:music]];
    [self addNotificationWithContent:content dateComponents:components identifer:identifer isRepeat:repeat completionHanler:handler];
}

#pragma Notification mange

+ (void)removeAllNotification API_AVAILABLE(ios(10.0)) {
    [[self center] removeAllDeliveredNotifications];
    [[self center] removeAllPendingNotificationRequests];
}

+ (void)removeNotificationWithIdentifer:(NSString *)identifer API_AVAILABLE(ios(10.0)) {
    //移除已经展示过的
    [[self center] removeDeliveredNotificationsWithIdentifiers:@[identifer]];
    //移除未展示过的
    [[self center] removePendingNotificationRequestsWithIdentifiers:@[identifer]];
}

+ (void)removeNotificationWithIdentifers:(NSArray<NSString *> *)identifers API_AVAILABLE(ios(10.0)) {
    
    [[self center] removeDeliveredNotificationsWithIdentifiers:identifers];
    [[self center] removePendingNotificationRequestsWithIdentifiers:identifers];
}

+ (void)notificationIsExitWithIdentifer:(NSString *)identifer completion:(void (^)(BOOL))completion {
    [self getAllNotificationIdentiferBlock:^(NSArray<NSString *> *identifers) {
        [identifer enumerateLinesUsingBlock:^(NSString * _Nonnull line, BOOL * _Nonnull stop) {
            if ([line isEqualToString:identifer]) {
                completion(YES);
                *stop = YES;
            }
        }];
        completion(NO);
    }];
}

+ (void)getAllNotificationIdentiferBlock:(void (^)(NSArray<NSString *> *identifers))idBlock API_AVAILABLE(ios(10.0)) {
    
    [[self center] getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
        NSMutableArray *array= [NSMutableArray array];
        
        [notifications enumerateObjectsUsingBlock:^(UNNotification * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [array addObject:obj.request.identifier];
        }];
        
        [[self center] getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
            [requests enumerateObjectsUsingBlock:^(UNNotificationRequest * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [array addObject:obj.identifier];
            }];
            if (idBlock) {
                idBlock([array copy]);
            }
        }];
    }];
}

+ (void)getDeliveredNotificationIdentiferBlock:(void (^)(NSArray<NSString *> *))idBlock API_AVAILABLE(ios(10.0)) {
    
    [[self center] getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
        NSMutableArray *array= [NSMutableArray array];
        
        [notifications enumerateObjectsUsingBlock:^(UNNotification * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [array addObject:obj.request.identifier];
        }];
        
        if (idBlock) {
            idBlock([array copy]);
        }
    }];
}

+ (void)getPendingNotificationIdentiferBlock:(void (^)(NSArray<NSString *> *))idBlock API_AVAILABLE(ios(10.0)) {

    [[self center] getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        NSMutableArray *array= [NSMutableArray array];

        [requests enumerateObjectsUsingBlock:^(UNNotificationRequest * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [array addObject:obj.identifier];
        }];
        if (idBlock) {
            idBlock([array copy]);
        }
    }];
}

#pragma mark -- NSDateComponents
+ (NSDateComponents *)componentsWithDate:(NSDate *)date {
    
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:unitFlags fromDate:date];
//    NSLog(@"%@", components);
    return components;
}

+ (NSDateComponents *)componentsWithDate:(NSDate *)date weekday:(NSInteger)weekday {
    
//    NSDateComponents *components = [self componentsWithDate:date];
    // 每周重复
    NSInteger unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:unitFlags fromDate:date];
    components.weekday = weekday;
    return components;
}

+ (NSDateComponents *)componentsEveryDayWithDate:(NSDate *)date {
    
    NSInteger unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:unitFlags fromDate:date];
    return components;
}

+ (NSDateComponents *)componentsEveryWeekWithDate:(NSDate *)date {
    
    NSInteger unitFlags = NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:unitFlags fromDate:date];
    return components;
}

+ (NSDateComponents *)componentsEveryMonthWithDate:(NSDate *)date {
    
    NSInteger unitFlags = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:unitFlags fromDate:date];
    return components;
}

+ (NSDateComponents *)componentsEveryYearWithDate:(NSDate *)date {
    
    NSInteger unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:unitFlags fromDate:date];
    return components;
}

#pragma mark -- UNNotificationContent
+ (UNMutableNotificationContent *)contentWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body {
    
    //title、body不能为空
    NSString *titleStr = title.length > 0 ? title : @"闹钟";
    NSString *bodyStr = body.length > 0 ? body : @"闹钟";
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = titleStr;
    content.subtitle = subTitle;
    content.body = bodyStr;
    content.sound = [UNNotificationSound defaultSound];

    return content;
}

+ (UNMutableNotificationContent *)contentWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body badge:(NSInteger)badge {
    
    UNMutableNotificationContent *content = [self contentWithTitle:title subTitle:subTitle body:body];
    content.badge = @(badge);
    return content;
}

+ (UNMutableNotificationContent *)contentWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body sound:(UNNotificationSound *)sound {
    UNMutableNotificationContent *content = [self contentWithTitle:title subTitle:subTitle body:body];
    content.sound = sound;

    return content;
}

+ (UNMutableNotificationContent *)contentWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body badge:(NSInteger)badge sound:(UNNotificationSound *)sound {
    
    UNMutableNotificationContent *content = [self contentWithTitle:title subTitle:subTitle body:body badge:badge];
    content.sound = sound;
    return content;
}

+ (UNMutableNotificationContent *)contentWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body badge:(NSInteger)badge sound:(UNNotificationSound *)sound attachment:(UNNotificationAttachment *)attachment {
    
    UNMutableNotificationContent *content = [self contentWithTitle:title subTitle:subTitle body:body badge:badge sound:sound];
    content.attachments = @[attachment];
    return content;
}

+ (UNMutableNotificationContent *)contentWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body badge:(NSInteger)badge sound:(UNNotificationSound *)sound attachments:(NSArray<UNNotificationAttachment *> *)attachments {
    
    UNMutableNotificationContent *content = [self contentWithTitle:title subTitle:subTitle body:body badge:badge sound:sound];
    content.attachments = attachments;
    return content;
}

#pragma mark -- UNNotificationTrigger
+ (UNNotificationTrigger *)triggerWithRegion:(CLRegion *)Region repeats:(BOOL)repeats {
    return [UNLocationNotificationTrigger triggerWithRegion:Region repeats:repeats];
}

+ (UNNotificationTrigger *)triggerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats {
    return [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:interval repeats:repeats];
}

+ (UNNotificationTrigger *)triggerWithDateComponents:(NSDateComponents *)components repeats:(BOOL)repeats {
    return [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:repeats];
}

+ (UNNotificationSound *)soundWithName:(NSString *)name {
    return [UNNotificationSound soundNamed:name];
}

#pragma mark -- paivate
+ (UNUserNotificationCenter *)center API_AVAILABLE(ios(10.0)) {
    return [UNUserNotificationCenter currentNotificationCenter];
}

#pragma mark -- UNUserNotificationCenterDelegate
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler  API_AVAILABLE(ios(10.0)) {
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        NSDictionary * userInfo = notification.request.content.userInfo;
        [[NSNotificationCenter defaultCenter] postNotificationName:UNDidReciveRemoteNotifationKey object:nil userInfo:userInfo];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:UNDidReciveLocalNotifationKey object:nil userInfo:@{UNNotifationInfoIdentiferKey : notification.request.identifier}];
    }
    
    completionHandler(UNNotificationPresentationOptionAlert + UNNotificationPresentationOptionSound + UNNotificationPresentationOptionBadge);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        NSDictionary * userInfo = response.notification.request.content.userInfo;
        [[NSNotificationCenter defaultCenter] postNotificationName:UNDidReciveRemoteNotifationKey object:nil userInfo:userInfo];
    }else {
        [self handCommnet:response];
    }
    
    completionHandler();
}


-(void)handCommnet:(UNNotificationResponse *)response API_AVAILABLE(ios(10.0)) {
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
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"yyyyMMddhhmmss";
        NSString *identifer = [format stringFromDate:[NSDate date]];
        
        [UNNotificationsManager addNotificationWithContent:response.notification.request.content identifer:identifer trigger:[UNNotificationsManager triggerWithDateComponents:[UNNotificationsManager componentsWithDate:date] repeats:NO] completionHanler:^(NSError *error) {
            NSLog(@"dart %@", error);
        }];
        
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:UNDidReciveLocalNotifationKey object:nil userInfo:@{UNNotifationInfoIdentiferKey : response.notification.request.identifier}];
    }
}

#pragma mark -- getter
- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(1);
    }
    return _semaphore;
}

@end
