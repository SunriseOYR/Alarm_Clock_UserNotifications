//
//  ClockViewModel.m
//  Alarm_Clock_UserNotifications
//
//  Created by 欧阳荣 on 2017/5/23.
//  Copyright © 2017年 欧阳荣. All rights reserved.
//

#import "ClockViewModel.h"
#import "YYCache.h"
#import "NSObject+YYModel.h"
#import "UNNotificationsManager.h"

@implementation ClockViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _clockData = [NSMutableArray array];
    }
    return self;
}

- (void)saveData {
    YYCache *cache = [[YYCache alloc] initWithName:@"cache"];
    [cache setObject:self forKey:[ClockViewModel keyForSaveClockData]];
}

- (void)addClockModel:(ClockModel *)model {
    [self.clockData addObject:model];
    [self saveData];
    [model addUserNotification];
}

- (void)replaceModelAtIndex:(NSUInteger)index withModel:(ClockModel *)model {
    [self.clockData[index] removeUserNotification];
    [self.clockData replaceObjectAtIndex:index withObject:model];
    [self saveData];
    [model addUserNotification];
}

- (void)removeClockModel:(ClockModel *)model {
    [model removeUserNotification];
    [self.clockData removeObject:model];
    [self saveData];
}

- (void)removeClockAtIndex:(NSInteger)index {
    [self removeClockModel:self.clockData[index]];
}

- (void)changeClockSwitchIsOn:(BOOL)isOn WithModel:(ClockModel *)model {
    model.isOn = isOn;
    isOn ? [model addUserNotification] : [model removeUserNotification];
    [self saveData];
}

- (void)reciveNotificationWithIdentifer:(NSString *)identifer {
    [self.clockData enumerateObjectsUsingBlock:^(ClockModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.identifer isEqualToString:identifer] && obj.repeatStr.length == 0) {
            [self changeClockSwitchIsOn:NO WithModel:obj];
        }
        
    }];
}

+ (instancetype)readData {
    YYCache *cache = [[YYCache alloc] initWithName:@"cache"];
    ClockViewModel * viewModel = [cache objectForKey:[self keyForSaveClockData]];
    if (!viewModel) {
        viewModel = [[ClockViewModel alloc] init];
    }
    
    [UNNotificationsManager getDeliveredNotificationIdentiferBlock:^(NSArray<NSString *> *identifers) {
        [identifers enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [viewModel reciveNotificationWithIdentifer:obj];
        }];
    }];
    
    return viewModel;
}

+ (void)removeClockWithModel:(ClockModel *)model {
    [UNNotificationsManager removeNotificationWithIdentifer:model.identifer];
}

+ (NSString *)keyForSaveClockData {
    return @"SaveClovkDataKey";
}


#pragma mark -- yymodel
- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }

@end

@implementation ClockModel

#pragma mark -- private
- (void)setDateForTimeClock {
    NSDateFormatter *format = [self getFormatter];
    NSString *dateString = [format stringFromDate:_date];
    _timeText = [dateString substringToIndex:2];
    _timeClock = [dateString substringFromIndex:2];
    
}

- (NSDateFormatter *)getFormatter {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"ahh:mm";
    format.AMSymbol = @"上午";
    format.PMSymbol = @"下午";
    return format;
}

- (void)addUserNotification {
    
    if ([self.repeatStr isEqualToString:@"每天"]) {
        [UNNotificationsManager addNotificationWithContent:[UNNotificationsManager contentWithTitle:@"时钟" subTitle:nil body:nil sound:[UNNotificationSound soundNamed:self.music]] dateComponents:[UNNotificationsManager componentsEveryDayWithDate:self.date] identifer:self.identifer isRepeat:self.repeats completionHanler:^(NSError *error) {
            NSLog(@"add error %@", error);
        }];
    }else if (self.repeatStrs.count == 0) {
        [UNNotificationsManager addNotificationWithContent:[UNNotificationsManager contentWithTitle:@"时钟" subTitle:nil body:nil sound:[UNNotificationSound soundNamed:self.music]] dateComponents:[UNNotificationsManager componentsWithDate:self.date] identifer:self.identifer isRepeat:self.repeats completionHanler:^(NSError *error) {
            NSLog(@"add error %@", error);
        }];
    }else {
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
    
    
}

- (void)removeUserNotification {
    [UNNotificationsManager removeNotificationWithIdentifer:self.identifer];
    if (self.identifers.count > 0) {
        [UNNotificationsManager removeNotificationWithIdentifers:self.identifers];
    }
}

#pragma mark -- setter && getter
- (void)setDate:(NSDate *)date {
    _date = date;
    [self setDateForTimeClock];
}

- (NSDate *)date {
    if (!_date) {
        NSDateFormatter *format = [self getFormatter];
        NSString *dateStr = [NSString stringWithFormat:@"%@%@",_timeText, _timeClock];
        _date = [format dateFromString:dateStr];
    }
    return _date;
}

- (NSString *)identifer {
    if (!_identifer) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"yyyyMMddhhmmss";
        
        NSString *identifer = [format stringFromDate:[NSDate date]];
        _identifer = self.isLater ? [NSString stringWithFormat:@"isLater%@",identifer] : identifer;
    }
    return _identifer;
}

- (void)setRepeatStrs:(NSArray *)repeatStrs {
    
    _repeatStrs = repeatStrs;
    NSMutableArray *idenArray = [NSMutableArray array];
    NSMutableArray *repeatArray = [NSMutableArray array];//去掉“每“字
    [repeatStrs enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [idenArray addObject:[self.identifer stringByAppendingString:obj]];
        [repeatArray addObject:[obj substringFromIndex:1]];
    }];
    _identifers = [idenArray copy];
    
    if (_repeatStrs.count > 0) {
        NSString *str = [repeatArray componentsJoinedByString:@""];
        _repeatStr = str;
        if (str.length == 14) {
            _repeatStr = @"每天";
        }else if ([str containsString:@"周日"] && [str containsString:@"周六"] && str.length == 4) {
            _repeatStr = @"周末";
        }else if (![str containsString:@"周日"] && ![str containsString:@"周六"] && str.length == 10) {
            _repeatStr = @"工作日";
        }

    }else {
        _repeatStr = @"永不";
    }
    
}

- (BOOL)repeats {
    if (self.repeatStrs.count <= 0) {
        return NO;
    }else {
        return YES;
    }
}

#pragma mark -- yymodel
- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }



@end
