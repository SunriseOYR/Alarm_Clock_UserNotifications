# Alarm_Clock_UserNotifications
高仿iOS系统闹钟 UserNotifications
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
