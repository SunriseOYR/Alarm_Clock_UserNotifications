//
//  AddClockViewController.h
//  Alarm_Clock_UserNotifications
//
//  Created by 欧阳荣 on 2017/5/23.
//  Copyright © 2017年 欧阳荣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockViewModel.h"

@interface AddClockViewController : UITableViewController

@property (nonatomic, copy) void(^block)(ClockModel *model);

@property (nonatomic, copy) ClockModel *model;

@end
