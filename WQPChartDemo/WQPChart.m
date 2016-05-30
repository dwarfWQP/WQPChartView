//
//  WQPChart.m
//  SNChartView
//
//  Created by yunmai1 on 16/5/25.
//  Copyright © 2016年 wangsen. All rights reserved.
//

#import "WQPChart.h"
#import "WQPChartAll.h"
#import "WQPChartLine.h"
#import "WQPChartBar.h"
@interface WQPChart ()
@property (nonatomic, strong) UIView *MyView;//also set ScrollerView
@property (nonatomic, assign) WQPChartStyle *chartStyle;//chart style
@property (nonatomic, weak) id<WQPChartDataSource>dataSource;//datasource
@property (nonatomic, strong) WQPChartAll *chartAll;
@property (nonatomic, strong) WQPChartLine *chartLine;
@property (nonatomic, strong) WQPChartBar *chartBar;
@property (nonatomic, strong) UIScrollView *ScrollView;//to line
@end
@implementation WQPChart

- (instancetype)initWithFrame:(CGRect)frame withDataSource:(id<WQPChartDataSource>)dataSource andChatStyle:(WQPChartStyle)chartStyle{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.dataSource = dataSource;
        self.chartStyle = (WQPChartStyle *)chartStyle;
        self.curve = NO;
    }
    return self;
}

- (void)startDraw{
    if (_chartStyle == WQPChartStyleAll) {
        
        self.MyView.frame = self.bounds;
        self.chartAll = [[WQPChartAll alloc] initWithFrame:self.bounds];
        [self.MyView addSubview:self.chartAll];
        
        NSMutableArray * yArray = [NSMutableArray arrayWithArray:[self.dataSource chatConfigYValue:self]];
        NSArray * xArray = [self.dataSource chatConfigXValue:self];
        NSInteger count = xArray.count - yArray.count;
        if (count > 0) {
            
            for (NSInteger i = 0; i < count; i++) {
                [yArray addObject:@(0).stringValue];
                
            }
        }
        
        //sort an array
//        NSArray * sourtArray = [yArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//            
//            return [obj2 floatValue] > [obj1 floatValue];
//        }];
        
        self.chartAll.yMax = 5.1;
        self.chartAll.curve = self.curve;
        [self.chartAll setXValues:xArray];
        [self.chartAll setYValues:yArray];
        
        [self.chartAll startDrawBarAndLines];
        
        CGRect frame = self.chartAll.frame;
        frame.size.width = xArray.count * chartAllAxisSpanX;
        self.chartAll.frame = frame;
        
    }else if(_chartStyle == (WQPChartStyle *)WQPChartStyleline){
        
        self.ScrollView.frame = self.bounds;
        self.chartLine = [[WQPChartLine alloc] initWithFrame:self.bounds];
        [self.ScrollView addSubview:self.chartLine];
        
        NSMutableArray * yArray = [NSMutableArray arrayWithArray:[self.dataSource chatConfigYValue:self]];
        NSArray * xArray = [self.dataSource chatConfigXValue:self];
        NSInteger count = xArray.count - yArray.count;
        if (count > 0) {
            for (NSInteger i = 0; i < count; i++) {
                [yArray addObject:@(0).stringValue];
                
            }
        }
        self.chartLine.yMax = 4.1;
        self.chartLine.curve = self.curve;
        [self.chartLine setXValues:xArray];
        [self.chartLine setYValues:yArray];
        [self.chartLine startDrawLine];
        
        self.ScrollView.contentSize = CGSizeMake(chartLineAxisSpanX * xArray.count + chartLineStartX, 0);
        CGRect frame = self.chartLine.frame;
        frame.size.width = xArray.count * chartAllAxisSpanX;
        self.chartLine.frame = frame;
        
    } else {
        self.MyView.frame = self.bounds;
        self.chartBar = [[WQPChartBar alloc] initWithFrame:self.bounds];
        [self.MyView addSubview:self.chartBar];
        
        NSMutableArray * yArray = [NSMutableArray arrayWithArray:[self.dataSource chatConfigYValue:self]];
        NSArray * xArray = [self.dataSource chatConfigXValue:self];
        NSInteger count = xArray.count - yArray.count;
        if (count > 0) {
            
            for (NSInteger i = 0; i < count; i++) {
                [yArray addObject:@(0).stringValue];
                
            }
        }
        
        self.chartBar.yMax = 5.1;
        [self.chartBar setXValues:xArray];
        [self.chartBar setYValues:yArray];
        [self.chartBar startDrawBar];
        
        CGRect frame = self.chartBar.frame;
        frame.size.width =  xArray.count * chartAllAxisSpanX;
        self.chartBar.frame = frame;
    }
    
}

- (void)showInView:(UIView *)view{
    [self startDraw];
    [view addSubview:self];
}

- (UIView *)MyView {
    if (!_MyView) {
        _MyView = [[UIScrollView alloc] init];
        [self addSubview:_MyView];
    }
    return _MyView;
}

- (UIScrollView *)ScrollView {
    if (!_ScrollView) {
        _ScrollView = [[UIScrollView alloc] init];
        [self addSubview:_ScrollView];
    }
    return _ScrollView;
}
@end
