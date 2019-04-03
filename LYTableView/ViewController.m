//
//  ViewController.m
//  LYTableView
//
//  Created by LiYong on 2019/4/3.
//  Copyright © 2019 勇 李. All rights reserved.
//

#import "ViewController.h"
#import "LYTableView.h"
#import "LYTableViewCell.h"
@interface ViewController ()<LYTableViewDataSource,LYTableViewDelegate>
@property (nonatomic,strong)LYTableView * tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[LYTableView alloc]initWithFrame:self.view.bounds];
    self.tableView.TableViewDelegate = self;
    self.tableView.TableViewDataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    // Do any additional setup after loading the view.
}

- (nonnull LYTableViewCell *)LYTableView:(nonnull LYTableView *)tableView cellForRow:(NSInteger)row {
    LYTableViewCell * cell = (LYTableViewCell*)[tableView dequeueReusableCellWithIdentify:@"haha"];
    if (!cell) {
        cell = [[LYTableViewCell alloc]initWithIdentifiy:@"haha"];
    }
    NSLog(@"%ld",(long)row);
    cell.titleLable.text = [NSString stringWithFormat:@"ceshi %ld",(long)row];
    
    return cell;
}

- (CGFloat)LYTableView:(nonnull LYTableView *)tableView heightForRow:(NSInteger)row {
    if (row%3 == 0) {
        return 60;
    }
    if (row%2 == 0) {
        return 90;
    }
    return 30;
}

- (NSInteger)LYTableViewNumberOfRows {
    return 30;
}


- (void)LYTableView:(nonnull LYTableView *)tableview didSelectRow:(NSInteger)row {
    NSLog(@"%ld",(long)row);
}
@end
