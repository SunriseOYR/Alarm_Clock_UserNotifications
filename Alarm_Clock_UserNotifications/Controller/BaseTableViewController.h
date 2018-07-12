//
//  BaseTableViewController.h
//  Alarm_Clock_UserNotifications
//
//  Created by 欧阳荣 on 2017/5/31.
//  Copyright © 2017年 欧阳荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewController : UITableViewController

@property (nonatomic, copy) void(^block)(id data);

@property (nonatomic, copy) id data;

- (void)action_backItem;

@end
