//
//  WQPChartBar.h
//  仿QQ侧滑栏
//
//  Created by yunmai1 on 16/5/27.
//  Copyright © 2016年 wqp. All rights reserved.
//

#import <UIKit/UIKit.h>
static const CGFloat chartBarStartX = 50.f;
static const CGFloat chartBarAxisSpanX = 50.f;
static const CGFloat chartBarAxisSpanY = 50.f;
@interface WQPChartBar : UIView
@property (nonatomic, strong) NSArray * xValues;
@property (nonatomic, strong) NSArray * yValues;

@property (nonatomic, assign) CGFloat yMax;

/**
 *  @author WQP, 16-05-27 16:12
 *
 *  开始绘制图表
 */
- (void)startDrawBar;
@end
