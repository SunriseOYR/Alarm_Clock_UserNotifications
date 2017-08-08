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
    
