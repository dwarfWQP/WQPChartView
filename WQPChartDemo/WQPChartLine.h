//
//  WQPChartLine.h
//  仿QQ侧滑栏
//
//  Created by yunmai1 on 16/5/27.
//  Copyright © 2016年 wqp. All rights reserved.
//

#import <UIKit/UIKit.h>
static const CGFloat chartLineStartX = 50.f;
static const CGFloat chartLineAxisSpanX = 50.f;
static const CGFloat chartLineAxisSpanY = 50.f;
@interface WQPChartLine : UIView
@property (nonatomic, strong) NSArray * xValues;
@property (nonatomic, strong) NSArray * yValues;
@property (nonatomic, assign) CGFloat yMax;
@property (nonatomic, assign) BOOL curve;

- (void)startDrawLine;
@end
