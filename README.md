# Alarm_Clock_UserNotifications

###ios系统闹钟

* 添加闹钟效果图   
![](https://github.com/SunriseOYR/Alarm_Clock_UserNotifications/blob/master/gif/001.gif?raw=true)  

* 收到通知效果图   
![](https://github.com/SunriseOYR/Alarm_Clock_UserNotifications/blob/master/gif/002.gif?raw=true)

* 前言  
最近项目中涉及到了本地通知的功能，索性就模仿系统闹钟写了个demo，对于iOS系统闹钟，应该都比较熟悉，该demo，基本实现了系统闹钟的全部功能。该demo本地通知使用的是iOS10 推出的UserNotifications， 关于UserNotifications的介绍和使用，网上已有诸多文章，在此就不多做赘述。

* UNNotificationsManager 关于闹钟所使用到的UserNotifications做了一个简单的封装,部分代码如下  
    
    //注册本地通知
      + (void)registerLocalNotification;
      
      #pragma mark -- AddNotification
    
      /* 添加通知
      * identifer 标识符
      * body  主体
      * title 标题
      * subTitle 子标题
      * weekDay  周几
      * date 日期
      * repeat   是否重复
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
                 completionHanler:(void (^)(NSError *))handler;
                 
      #pragma mark -- NotificationManage
      /*
       * identifer 标识符
       * 根据标识符 移除 本地通知
       */
      + (void)removeNotificationWithIdentifer:(NSString *)identifer;
    
      #pragma mark -- NSDateComponents
      /*
       * return 日期组件 时分秒
       * ex 每天重复
       */
      + (NSDateComponents *)componentsEveryDayWithDate:(NSDate *)date;
    
      #pragma mark -- UNNotificationContent
      /* UNMutableNotificationContent 通知内容
       * title  标题
       * subTitle 子标题
       * body 主体
       */
      + (UNMutableNotificationContent *)contentWithTitle:(NSString *)title
                                     subTitle:(NSString *)subTitle
                                         body:(NSString *)body;
    
      #pragma mark -- UNNotificationTrigger
      /* UNNotificationTrigger 通知触发器
      * interval  通知间隔
      * repeats 是否重复
       */
      + (UNNotificationTrigger *)triggerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats;
    
* 添加闹钟 
> 普通闹钟 
    
![](https://github.com/SunriseOYR/Alarm_Clock_UserNotifications/blob/master/gif/004.jpeg?raw=true)

       [UNNotificationsManager addNotificationWithContent:[UNNotificationsManager contentWithTitle:@"时钟" subTitle:nil body:nil sound:[UNNotificationSound soundNamed:self.music]] dateComponents:[UNNotificationsManager componentsWithDate:self.date] identifer:self.identifer isRepeat:self.repeats completionHanler:^(NSError *error) {
            NSLog(@"add error %@", error);
        }];

> 每天重复 
    
![](https://github.com/SunriseOYR/Alarm_Clock_UserNotifications/blob/master/gif/005.jpeg?raw=true)

            [UNNotificationsManager addNotificationWithContent:[UNNotificationsManager contentWithTitle:@"时钟" subTitle:nil body:nil sound:[UNNotificationSound soundNamed:self.music]] dateComponents:[UNNotificationsManager componentsEveryDayWithDate:self.date] identifer:self.identifer isRepeat:self.repeats completionHanler:^(NSError *error) {
            NSLog(@"add error %@", error);
        }];

> 每周重复（周一，周二等）

    [self.repeatStrs enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger week = 0;
            if ([obj containsString:@"周日"]) {
                week = 1;
            }else if([obj containsString:@"周一"]){
                week = 2;
            }else if([obj containsString:@"周二"]){
                week = 3;
            }else if([obj containsString:@"周三"]){
                week = 4;
            }else if([obj containsString:@"周四"]){
                week = 5;
            }else if([obj containsString:@"周五"]){
                week = 6;
            }else if([obj containsString:@"周六"]){
                week = 7;
            }
            [UNNotificationsManager addNotificationWithContent:[UNNotificationsManager contentWithTitle:@"闹钟" subTitle:nil body:nil sound:[UNNotificationSound soundNamed:self.music]] weekDay:week date:self.date identifer:self.identifer isRepeat:YES completionHanler:^(NSError *error) {
                NSLog(@"add error %@", error);
            }];
        }];
    }

* 铃声   
这里无法获取系统铃声和震动类型，自己在网上找了点[铃声素材](http://www.zedge.net/ringtones/0-1-3-ios)。 系统铃声需要caf格式，MP3和caf 格式相互转化方法如下

        //控制台输入
        afconvert xxx.mp3 xxx.caf -d ima4 -f caff -v


![](https://github.com/SunriseOYR/Alarm_Clock_UserNotifications/blob/master/gif/006.jpeg?raw=true)

* 通知栏选项 

![](https://github.com/SunriseOYR/Alarm_Clock_UserNotifications/blob/master/gif/007.png?raw=true)
![](https://github.com/SunriseOYR/Alarm_Clock_UserNotifications/blob/master/gif/010.png?raw=true)
 > 首先注册通知的时候需要UNNotificationCategory 以及UNNotificationAction 

    UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:actionFiveMin title:@"5分钟后" options:UNNotificationActionOptionNone];

    UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:actionHalfAnHour title:@"半小时后" options:UNNotificationActionOptionNone];

    UNNotificationAction *action3 = [UNNotificationAction actionWithIdentifier:actionOneHour title:@"1小时后" options:UNNotificationActionOptionNone];

    UNNotificationAction *action4 = [UNNotificationAction actionWithIdentifier:actionStop title:@"停止" options:UNNotificationActionOptionNone];
    
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:identiferStr actions:@[action1, action2,action3, action4] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
    
    UNNotificationCategory *stopCategory = [UNNotificationCategory categoryWithIdentifier:categryStopIdf actions:@[action4] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
    
    [center setNotificationCategories:[NSSet setWithArray:@[category,stopCategory]]];

> 然后在设置UNMutableNotificationContent的时候需要设置对应的categoryIdentifier   这里区分了是否设置了稍候提醒  
![](https://github.com/SunriseOYR/Alarm_Clock_UserNotifications/blob/master/gif/009.png?raw=true)
  
    + (void)addNotificationWithContent:(UNNotificationContent *)content identifer:(NSString *)identifer trigger:(UNNotificationTrigger *)trigger completionHanler:(void (^)(NSError *))handler {
    
        //设置 category
        UNMutableNotificationContent *aContent = [content mutableCopy];
        if ([identifer hasPrefix:@"isLater"]) {
            aContent.categoryIdentifier = categryLaterIdf;
        }else {
            aContent.categoryIdentifier = categryStopIdf;
        }
        [self addNotificationWithRequest:[UNNotificationRequest requestWithIdentifier:identifer content:aContent trigger:trigger] completionHanler:handler];
    }
> 最后在用户点击导航栏控件的时候，根据identifier处理相应事件   
  
    //与导航控件交互的时候会调用
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
        }
    }

* 首页日期格式  

 ![](https://github.com/SunriseOYR/Alarm_Clock_UserNotifications/blob/master/gif/008.png?raw=true)

这个格式应该很多人知道，但是笔者在写这个demo的时候还不知道，所以还是亮出来吧

    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"ahh:mm";
    format.AMSymbol = @"上午";
    format.PMSymbol = @"下午"; 

最后  [GitHub传送门](https://github.com/SunriseOYR/Alarm_Clock_UserNotifications)，记得点个赞额
