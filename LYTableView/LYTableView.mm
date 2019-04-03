//
//  LYTableView.m
//  test
//
//  Created by LiYong on 2019/4/1.
//  Copyright © 2019 勇 李. All rights reserved.
//

const float Row_Height = 50.0f;

#import "LYTableView.h"
#import <vector>
#import <map>
#import "LYTableViewCell.h"
typedef std::map<int, float> LYCellOffsetMap;
typedef std::vector<float> LYCellHeight;

@interface LYTableView(){
    Class _cellClass;
    LYCellOffsetMap _cellYOffsets;
    LYCellHeight _cellHeights;
    NSUInteger _cellNumbers;
    NSMutableDictionary * _visibleCellsMap;
}

@property (nonatomic,strong)NSMutableSet *reuseCells;

@end

@implementation LYTableView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _visibleCellsMap = [NSMutableDictionary dictionary];
        _reuseCells = [NSMutableSet set];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)reloadData{
    
    [self reduceContentSize];
    [self layoutNeedDisplayCells];
}
- (NSRange)displayRange{
    if (_cellNumbers == 0) {
        return NSMakeRange(0, 0);
    }
    int  beginIndex = 0;
    float beiginHeight = self.contentOffset.y;
    float displayBeginHeight = -0.00000001f;
    
    for (int i = 0 ; i < _cellNumbers; i++) {
        float cellHeight = _cellHeights.at(i);
        displayBeginHeight += cellHeight;
        if (displayBeginHeight > beiginHeight) {
            beginIndex = i;
            break;
        }
    }
    
    int endIndex = beginIndex;
    float displayEndHeight = self.contentOffset.y + CGRectGetHeight(self.frame);
    for (int i = beginIndex; i < _cellNumbers; i ++) {
        float cellYoffset = _cellYOffsets.at(i);
        if (cellYoffset > displayEndHeight) {
            endIndex = i;
            break;
        }
        if (i == _cellNumbers - 1) {
            endIndex = i;
            break;
        }
    }
    return NSMakeRange(beginIndex, endIndex - beginIndex + 1);
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self layoutNeedDisplayCells];
}
- (void)tap:(UITapGestureRecognizer*)tap{
    CGPoint point = [tap locationInView:self];
    NSArray* cells = _visibleCellsMap.allValues;

    for (LYTableViewCell *cell in cells) {
        CGRect rect = cell.frame;
        if (CGRectContainsPoint(rect, point)) {
            if ([self.TableViewDelegate respondsToSelector:@selector(LYTableView:didSelectRow:)]) {
                [self.TableViewDelegate LYTableView:self didSelectRow:cell.index];
            }
        }
    }
}
- (void)reduceContentSize{
    _cellNumbers = [self.TableViewDataSource LYTableViewNumberOfRows];
    _cellYOffsets = LYCellOffsetMap();
    _cellHeights = LYCellHeight();
    CGFloat height = 0;
    for (int i = 0; i<_cellNumbers; i++) {
        CGFloat cellHeight = [self.TableViewDataSource LYTableView:self heightForRow:i];
        _cellYOffsets.insert(std::pair<int,float>(i,height));

        _cellHeights.push_back(cellHeight);
        height += cellHeight;
    }
    CGSize size = CGSizeMake(self.frame.size.width, height);
    [self setContentSize:size];
}
- (void)layoutNeedDisplayCells{
    
    NSRange displayRange = [self displayRange];
    for (int i = (int)displayRange.location; i<displayRange.length+displayRange.location; i++) {
        LYTableViewCell * cell = [self _cellForRow:i];
        [self addCell:cell row:i];
        cell.frame = [self _cellRectForRow:i];
    }
    [self cleanUnusedCellsWithDispalyRange:displayRange];

}

- (LYTableViewCell *)_cellForRow:(NSUInteger)row{
    LYTableViewCell * cell = [_visibleCellsMap objectForKey:@(row)];
    if (!cell) {
        cell = [self.TableViewDataSource LYTableView:self cellForRow:row];
    }
    return cell;
}
- (void)addCell:(LYTableViewCell*)cell row:(NSUInteger)row{
    [self addSubview:cell];
    cell.index = row;
    [self updateVisibleCell:cell row:row];
}
- (void)updateVisibleCell:(LYTableViewCell*)cell row:(NSUInteger)index{
    _visibleCellsMap[@(index)] = cell;
}
- (CGRect)_cellRectForRow:(NSUInteger)row{
    if (row<0 || row>_cellNumbers) {
        return CGRectZero;
    }
    float yOffset = _cellYOffsets.at(row);
    float height = _cellHeights.at(row);
    return CGRectMake(0, yOffset, self.frame.size.width, height);
}
- (void)cleanUnusedCellsWithDispalyRange:(NSRange)range{
    NSDictionary* dic = [_visibleCellsMap copy];
    NSArray* keys = dic.allKeys;
    for (NSNumber* rowIndex  in keys) {
        int row = [rowIndex intValue];
        if (!NSLocationInRange(row, range)) {
            LYTableViewCell* cell = [_visibleCellsMap objectForKey:rowIndex];
            [_visibleCellsMap removeObjectForKey:rowIndex];
            [self enqueueTableViewCell:cell];
        }
    }
}
- (void) enqueueTableViewCell:(LYTableViewCell*)cell{
    if (cell) {
        [cell prepareForReuse];
        [_reuseCells addObject:cell];
        [cell removeFromSuperview];
    }
}


- (LYTableViewCell *)dequeueReusableCellWithIdentify:(NSString *)identify{
    LYTableViewCell * cell= nil;
    for (LYTableViewCell *tempCell in _reuseCells) {
        if ([tempCell.identify isEqualToString:identify]) {
            cell = tempCell;
            break;
        }
    }
    if (cell) {
        [_reuseCells removeObject:cell];
    }else{
        NSLog(@"not found");
    }
    return cell;
}

@end
