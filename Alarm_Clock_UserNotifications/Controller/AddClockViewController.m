//
//  AddClockViewController.m
//  Alarm_Clock_UserNotifications
//
//  Created by 欧阳荣 on 2017/5/23.
//  Copyright © 2017年 欧阳荣. All rights reserved.
//

#import "AddClockViewController.h"
#import "BaseTableViewController.h"

@interface AddClockViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *dataPicker;
@property (weak, nonatomic) IBOutlet UILabel *repeatLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *musicLabel;
@property (weak, nonatomic) IBOutlet UISwitch *laterSwitch;

@end

@implementation AddClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.tableFooterView = [UIView new];
    
    [self.dataPicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    self.dataPicker.backgroundColor = [UIColor blackColor];
    
    if (_model) {
        self.dataPicker.date = _model.date;
        self.repeatLabel.text = _model.repeatStr;
        self.tagLabel.text = _model.tagStr;
        self.musicLabel.text = _model.music;
        self.laterSwitch.on = _model.isLater;
    }
    
}

- (IBAction)action_backBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)action_saveBtn:(id)sender {
    
    self.model.date = _dataPicker.date;
    _model.music = _musicLabel.text;
    _model.tagStr = _tagLabel.text;
    _model.isLater = _laterSwitch.isOn;
//    _model.repeatStr = _repeatLabel.text;
    _model.isOn = YES;
    _model.isLater = self.laterSwitch.isOn;
    if (self.block) {
        self.block(_model);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    BaseTableViewController *baseVC = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"musicListVC"]) {
        baseVC.block = ^(NSString *text) {
            self.model.music = text;
            self.musicLabel.text = text;
        };
        baseVC.data = self.model.music;
    }else if ([segue.identifier isEqualToString:@"repeatVC"]) {
        baseVC.block = ^(NSArray *repeats) {
            self.model.repeatStrs = repeats;
            self.repeatLabel.text = self.model.repeatStr;
        };
        baseVC.data = self.model.repeatStrs;
    }else if ([segue.identifier isEqualToString:@"labelVC"]) {
        baseVC.block = ^(NSString *text) {
            self.model.tagStr = text;
            self.tagLabel.text = text;
        };
        baseVC.data = self.model.tagStr;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (ClockModel *)model {
    if (!_model) {
        _model = [ClockModel new];
    }
    return _model;
}

@end
