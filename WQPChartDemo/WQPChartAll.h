//
//  WQPChartAll.h
//  SNChartView
//
//  Created by yunmai1 on 16/5/25.
//  Copyright © 2016年 wangsen. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat chartAllStartX = 50.f;//起始位置
static const CGFloat chartAllAxisSpanX = 50.f;//X轴跨度
static const CGFloat chartAllAxisSpanY = 50.f;//Y轴跨度
@interface WQPChartAll : UIView

@property (nonatomic, strong) NSArray * xValues;
@property (nonatomic, strong) NSArray * yValues;
@property (nonatomic, assign) CGFloat yMax;
@property (nonatomic, assign) BOOL curve;//曲线的判断标记

- (void)startDrawBarAndLines;
@end
