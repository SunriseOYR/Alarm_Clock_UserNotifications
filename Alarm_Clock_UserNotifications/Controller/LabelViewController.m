//
//  LabelViewController.m
//  Alarm_Clock_UserNotifications
//
//  Created by 欧阳荣 on 2017/5/23.
//  Copyright © 2017年 欧阳荣. All rights reserved.
//

#import "LabelViewController.h"

@interface LabelViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textfield;

@end

@implementation LabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"标签";
    self.tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
    
    if (self.data) {
        self.textfield.text = self.data;
    }
    
}

#pragma mark -- override
- (void)action_backItem {
    
    if (self.block) {
        self.block(self.textfield.text);
    }
    [super action_backItem];
}

@end

