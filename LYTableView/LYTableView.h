//
//  LYTableView.h
//  test
//
//  Created by LiYong on 2019/4/1.
//  Copyright © 2019 勇 李. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LYTableView;
@class LYTableViewCell;

@protocol LYTableViewDataSource <NSObject>
- (LYTableViewCell *)LYTableView:(LYTableView *)tableView cellForRow:(NSInteger)row;
- (NSInteger)LYTableViewNumberOfRows;
- (CGFloat)LYTableView:(LYTableView *)tableView heightForRow:(NSInteger)row;
@end

@protocol LYTableViewDelegate <NSObject>

- (void)LYTableView:(LYTableView *)tableview didSelectRow:(NSInteger)row;

@end

@interface LYTableView : UIScrollView
@property (assign,nonatomic)id <LYTableViewDataSource> TableViewDataSource;
@property (assign,nonatomic)id <LYTableViewDelegate> TableViewDelegate;

- (UITableViewCell *)dequeueReusableCellWithIdentify:(NSString *)identify;
- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
