//
//  LYTableViewCell.h
//  test
//
//  Created by LiYong on 2019/4/1.
//  Copyright © 2019 勇 李. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYTableViewCell : UIView
@property (nonatomic,strong)NSString * identify;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,strong)UILabel *titleLable;


- (instancetype) initWithIdentifiy:(NSString*)identifiy;
- (void)prepareForReuse;
@end

NS_ASSUME_NONNULL_END
