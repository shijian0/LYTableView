//
//  LYTableViewCell.m
//  test
//
//  Created by LiYong on 2019/4/1.
//  Copyright © 2019 勇 李. All rights reserved.
//

#import "LYTableViewCell.h"

@implementation LYTableViewCell
{
    CAGradientLayer * sepLayer;
}
- (instancetype) initWithIdentifiy:(NSString*)identifiy{
    if (self = [super init]) {
        _identify = identifiy;
        sepLayer = [CAGradientLayer layer];
        sepLayer.colors = @[
                            (id)[[ UIColor clearColor] CGColor],
                            (id)[[ UIColor clearColor] CGColor],
                            (id)[[ UIColor colorWithWhite:0.0f alpha:0.1f] CGColor]];
        sepLayer.locations = @[@0.0f,@0.97,@1.00f];
        [self.layer insertSublayer:sepLayer above:0];
        [self addSubview:self.titleLable];
    }
    return self;
}
- (void)prepareForReuse{
    _index = NSNotFound;
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    sepLayer.frame = CGRectMake(15, 0, self.bounds.size.width, self.bounds.size.height);
    self.titleLable.frame = CGRectMake(15, 0, self.bounds.size.width, self.bounds.size.height);
}
- (UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc]init];
    }
    return _titleLable;
}

@end
