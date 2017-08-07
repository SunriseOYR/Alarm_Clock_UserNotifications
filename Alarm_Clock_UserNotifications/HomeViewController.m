//
//  ViewController.m
//  Alarm_Clock_UserNotifications
//
//  Created by 欧阳荣 on 2017/5/12.
//  Copyright © 2017年 欧阳荣. All rights reserved.
//

#import "HomeViewController.h"
#import "AlarmClockCell.h"
#import "ClockViewModel.h"
#import "AddClockViewController.h"


@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource, AlarmClockCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) ClockViewModel *viewModel;

@end

@implementation HomeViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReciveNotification:) name:@"didReciveNotification" object:nil];
    
    self.tableView.tableFooterView = [UIView new];
//    self.tableView.allowsSelectionDuringEditing
}

- (void)didReciveNotification:(NSNotification *)notif {
    [self.viewModel reciveNotificationWithIdentifer:notif.userInfo[@"idf"]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (IBAction)action_editBtn:(UIBarButtonItem *)sender {
    sender.title = [sender.title isEqualToString:@"编辑"] ? @"完成" : @"编辑";
    BOOL edit = !self.tableView.editing;
    [self.tableView setEditing:edit animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *nav = segue.destinationViewController;
    AddClockViewController *vc = (AddClockViewController *)nav.topViewController;
    if ([segue.identifier isEqualToString:@"addPresentVCIdf"]) {
        vc.block = ^(ClockModel *model){
            [self.viewModel addClockModel:model];
            [self.tableView reloadData];
        };
    }else {
        vc.model = self.viewModel.clockData[self.tableView.indexPathForSelectedRow.row];
        vc.block = ^(ClockModel *model){
            NSLog(@"%ld", self.tableView.indexPathForSelectedRow.row);
            [self.viewModel replaceModelAtIndex:self.tableView.indexPathForSelectedRow.row withModel:model];
            [self.tableView reloadData];
        };
    }
}


#pragma mark -- UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.clockData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlarmClockCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlarmClockCell" forIndexPath:indexPath];
    cell.model = self.viewModel.clockData[indexPath.row];
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.tableView.editing) return;
    [self performSegueWithIdentifier:@"editPresentVCIdf" sender:self];
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.viewModel removeClockAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)alarmCell:(AlarmClockCell *)cell switch:(UISwitch *)switchControl didSelectedAtIndexpath:(NSIndexPath *)indexpath {
    [self.viewModel changeClockSwitchIsOn:switchControl.isOn WithModel:self.viewModel.clockData[indexpath.row]];
}

#pragma mark -- getter

- (ClockViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [ClockViewModel readData];
    }
    return _viewModel;
}

@end
