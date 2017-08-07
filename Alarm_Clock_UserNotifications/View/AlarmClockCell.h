//
//  AlarmClockCell.h
//  Alarm_Clock_UserNotifications
//
//  Created by 欧阳荣 on 2017/5/22.
//  Copyright © 2017年 欧阳荣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockViewModel.h"

@class AlarmClockCell;
@protocol AlarmClockCellDelegate <NSObject>

- (void)alarmCell:(AlarmClockCell *)cell switch:(UISwitch *)switchControl didSelectedAtIndexpath:(NSIndexPath *)indexpath;

@end

@interface AlarmClockCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeTextLabel; //上午 、下午
@property (weak, nonatomic) IBOutlet UILabel *timeLabel; // 时间
@property (weak, nonatomic) IBOutlet UILabel *timeTagLabel; //标签
@property (weak, nonatomic) IBOutlet UISwitch *timeSwitch;

@property (nonatomic, copy) NSIndexPath *indexPath;
@property (nonatomic, strong) ClockModel *model;

@property (nonatomic, assign) id<AlarmClockCellDelegate> delegate;

@end
