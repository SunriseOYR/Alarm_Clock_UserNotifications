//
//  UNotifivationManager.h
//  Alarm_Clock_UserNotifications
//
//  Created by 欧阳荣 on 2017/5/24.
//  Copyright © 2017年 欧阳荣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

#define categryLaterIdf @"categryIdentiferLater"
#define categryStopIdf @"categryIdentiferStop"

#define actionFiveMin @"fiveMinete"
#define actionHalfAnHour @"halfAnHour"
#define actionOneHour @"oneHour"
#define actionStop @"stopCancel"

extern NSString * const UNDidReciveRemoteNotifationKey;
extern NSString * const UNDidReciveLocalNotifationKey;
extern NSString * const UNNotifationInfoIdentiferKey;

@interface UNNotificationsManager : NSObject

+ (instancetype)shared;

//注册本地通知
+ (void)registerLocalNotification API_AVAILABLE(ios(10.0));

#pragma mark -- AddNotification

/* 添加通知
 * requst  通知请求
 */
+ (void)addNotificationWithRequest:(UNNotificationRequest *)requst
                  completionHanler:(void(^)(NSError *error))handler API_AVAILABLE(ios(10.0));

/*
 * content  通知内容
 * identifer 标识符
 * trigger  触发器
 */
+ (void)addNotificationWithContent:(UNNotificationContent *)content
                         identifer:(NSString *)identifer
                           trigger:(UNNotificationTrigger *)trigger
                  completionHanler:(void(^)(NSError *error))handler API_AVAILABLE(ios(10.0));

/*
 * interval 间隔
 * repeat   是否重复
 * ep: interval 需要大于60 方可重复
 */
+ (void)addNotificationWithContent:(UNNotificationContent *)content
                          interval:(NSTimeInterval)interval
                         identifer:(NSString *)identifer
                          isRepeat:(BOOL)repeat
                  completionHanler:(void(^)(NSError *error))handler API_AVAILABLE(ios(10.0));

/*
 * compents 日期组件
 */
+ (void)addNotificationWithContent:(UNNotificationContent *)content
                    dateComponents:(NSDateComponents *)components
                         identifer:(NSString *)identifer
                          isRepeat:(BOOL)repeat
                  completionHanler:(void(^)(NSError *error))handler API_AVAILABLE(ios(10.0));

/*
 * weekDay  周几
 * date 日期
 */
+ (void)addNotificationWithContent:(UNNotificationContent *)content
                           weekDay:(NSInteger)weekDay
                              date:(NSDate *)date
                         identifer:(NSString *)identifer
                          isRepeat:(BOOL)repeat
                  completionHanler:(void(^)(NSError *error))handler API_AVAILABLE(ios(10.0));

/*
 * body  主体
 * title 标题
 * subTitle 子标题
 * music 音乐
 */
+ (void)addNotificationWithBody:(NSString *)body
                          title:(NSString *)title
                       subTitle:(NSString *)subTitle
                        weekDay:(NSInteger)weekDay
                           date:(NSDate *)date
                          music:(NSString *)music
                      identifer:(NSString *)identifer
                       isRepeat:(BOOL)repeat
               completionHanler:(void (^)(NSError *error))handler API_AVAILABLE(ios(10.0));

//每天重复
+ (void)addRepeatEveryDayNotificationWithBody:(NSString *)body
                                        title:(NSString *)title
                                     subTitle:(NSString *)subTitle
                                         date:(NSDate *)date
                                        music:(NSString *)music
                                    identifer:(NSString *)identifer
                             completionHanler:(void (^)(NSError *error))handler API_AVAILABLE(ios(10.0));

//components
+ (void)addComponentsNotificationWithBody:(NSString *)body
                                    title:(NSString *)title
                                 subTitle:(NSString *)subTitle
                           dateComponents:(NSDateComponents *)components
                                    music:(NSString *)music
                                identifer:(NSString *)identifer
                                 isRepeat:(BOOL)repeat
                         completionHanler:(void (^)(NSError *error))handler API_AVAILABLE(ios(10.0));

#pragma mark -- NotificationManage

/*
 * 移除所有本地通知
 */
+ (void)removeAllNotification;

/*
 * identifer 标识符
 * 根据标识符 移除 本地通知
 */
+ (void)removeNotificationWithIdentifer:(NSString *)identifer;

/*
 * 移除通知们
 */
+ (void)removeNotificationWithIdentifers:(NSArray<NSString *> *)identifers;

/*
 * 判断某个通知是否存在
 */
+ (void)notificationIsExitWithIdentifer:(NSString *)identifer completion:(void(^)(BOOL isExit))completion;

/*
 * 获取所有通知的标识符
 */
+ (void)getAllNotificationIdentiferBlock:(void(^)(NSArray <NSString *>*identifers))idBlock;

/*
 * 获取已交付的标识符
 */
+ (void)getDeliveredNotificationIdentiferBlock:(void(^)(NSArray <NSString *>*identifers))idBlock;

/*
 * 获取为触发的标识符
 */
+ (void)getPendingNotificationIdentiferBlock:(void(^)(NSArray <NSString *>*identifers))idBlock;

#pragma mark -- NSDateComponents
/* NSDateComponents 日期组件
 * date  日期
 * return 日期组件 年月日时分秒
 * ex 将不会重复，因为年份无法重复
 */
+ (NSDateComponents *)componentsWithDate:(NSDate *)date;

/*
 * weakday 指定周几 1~7 周日~周六
 * return 日期组件 周时分秒
 * ex 每周重复
 */
+ (NSDateComponents *)componentsWithDate:(NSDate *)date weekday:(NSInteger)weekday;

/*
 * return 日期组件 时分秒
 * ex 每天重复
 */
+ (NSDateComponents *)componentsEveryDayWithDate:(NSDate *)date;

/*
 * return 日期组件 周时分秒
 * ex 每周重复
 */
+ (NSDateComponents *)componentsEveryWeekWithDate:(NSDate *)date;

/*
 * return 日期组件 日时分秒
 * ex 每月重复
 */
+ (NSDateComponents *)componentsEveryMonthWithDate:(NSDate *)date;

/*
 * return 日期组件 月日时分秒
 * ex 每天重复
 */
+ (NSDateComponents *)componentsEveryYearWithDate:(NSDate *)date;

#pragma mark -- UNNotificationContent
/* UNMutableNotificationContent 通知内容
 * title  标题
 * subTitle 子标题
 * body 主体
 */
+ (UNMutableNotificationContent *)contentWithTitle:(NSString *)title
                                   subTitle:(NSString *)subTitle
                                              body:(NSString *)body API_AVAILABLE(ios(10.0));
/*
 * badge  标记
 */
+ (UNMutableNotificationContent *)contentWithTitle:(NSString *)title
                                   subTitle:(NSString *)subTitle
                                       body:(NSString *)body
                                             badge:(NSInteger)badge API_AVAILABLE(ios(10.0));
/*
 * sound  声音
 */
+ (UNMutableNotificationContent *)contentWithTitle:(NSString *)title
                                   subTitle:(NSString *)subTitle
                                       body:(NSString *)body
                                             sound:(UNNotificationSound *)sound API_AVAILABLE(ios(10.0));

+ (UNMutableNotificationContent *)contentWithTitle:(NSString *)title
                                   subTitle:(NSString *)subTitle
                                       body:(NSString *)body
                                      badge:(NSInteger)badge
                                             sound:(UNNotificationSound *)sound API_AVAILABLE(ios(10.0));
/*
 * attachment  附件
 */
+ (UNMutableNotificationContent *)contentWithTitle:(NSString *)title
                                   subTitle:(NSString *)subTitle
                                       body:(NSString *)body
                                      badge:(NSInteger)badge
                                      sound:(UNNotificationSound *)sound
                                        attachment:(UNNotificationAttachment *)attachment API_AVAILABLE(ios(10.0));
/*
 * attachments  附件们
 */
+ (UNMutableNotificationContent *)contentWithTitle:(NSString *)title
                                   subTitle:(NSString *)subTitle
                                       body:(NSString *)body
                                      badge:(NSInteger)badge
                                      sound:(UNNotificationSound *)sound
                                       attachments:(NSArray <UNNotificationAttachment *> *)attachments API_AVAILABLE(ios(10.0));


#pragma mark -- UNNotificationTrigger
/* UNNotificationTrigger 通知触发器
 * interval  通知间隔
 * repeats 是否重复
 */
+ (UNNotificationTrigger *)triggerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats API_AVAILABLE(ios(10.0));

/*
 * components 时间组件
 */
+ (UNNotificationTrigger *)triggerWithDateComponents:(NSDateComponents *)components repeats:(BOOL)repeats API_AVAILABLE(ios(10.0));

/*
 * Region 地理信息
 */
+ (UNNotificationTrigger *)triggerWithRegion:(CLRegion *)Region repeats:(BOOL)repeats API_AVAILABLE(ios(10.0));


#pragma mark -- UNNotificationSound

+ (UNNotificationSound *)soundWithName:(NSString *)name API_AVAILABLE(ios(10.0));

@end
