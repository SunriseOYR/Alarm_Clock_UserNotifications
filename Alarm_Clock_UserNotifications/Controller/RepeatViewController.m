//
//  RepeatViewController.m
//  Alarm_Clock_UserNotifications
//
//  Created by 欧阳荣 on 2017/5/23.
//  Copyright © 2017年 欧阳荣. All rights reserved.
//

#import "RepeatViewController.h"

@interface RepeatViewController ()

@property (nonatomic, strong) NSMutableArray *weekdays;

@end

@implementation RepeatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.title = @"重复";
    self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    
    if (self.data) {
        _weekdays = [NSMutableArray arrayWithArray:self.data];
        if ([_weekdays containsObject:@"每周日"]) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        if ([_weekdays containsObject:@"每周一"]) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        if ([_weekdays containsObject:@"每周二"]) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        if ([_weekdays containsObject:@"每周三"]) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        if ([_weekdays containsObject:@"每周四"]) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        if ([_weekdays containsObject:@"每周五"]) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        if ([_weekdays containsObject:@"每周六"]) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }

    }


}

- (void)action_backItem {
    if (self.block) {
        self.block(self.weekdays);
    }
    [super action_backItem];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.weekdays removeObject:cell.textLabel.text];
    }else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.weekdays addObject:cell.textLabel.text];
    }
}

- (NSMutableArray *)weekdays {
    if (!_weekdays) {
        _weekdays = [NSMutableArray array];
    }
    return _weekdays;
}

 

@end
