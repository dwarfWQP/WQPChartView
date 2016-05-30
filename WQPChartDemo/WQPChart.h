//
//  WQPChart.h
//  SNChartView
//
//  Created by yunmai1 on 16/5/25.
//  Copyright © 2016年 wangsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQPChart;

typedef NS_ENUM(NSInteger, WQPChartStyle){
    WQPChartStyleAll = 0,
    WQPChartStyleline = 1,
    WQPChartStyleBar
    
};
@protocol WQPChartDataSource <NSObject>

@required

//configuration y-axis
- (NSMutableArray *)chatConfigYValue:(WQPChart *)chart;
//configuration x-axis
- (NSMutableArray *)chatConfigXValue:(WQPChart *)chart;

@end

@interface WQPChart : UIView
/**
 *  @author wqp, 16-05-25 17:20:30
 *
 *  line  是否曲线
 */
@property (nonatomic, assign) BOOL curve;

- (instancetype)initWithFrame:(CGRect)frame withDataSource:(id<WQPChartDataSource>)dataSource andChatStyle:(WQPChartStyle)chartStyle;

- (void)showInView:(UIView *)view;


@end
