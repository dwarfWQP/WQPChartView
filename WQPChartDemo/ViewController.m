//
//  ViewController.m
//  WQPChartDemo
//
//  Created by yunmai1 on 16/5/30.
//  Copyright © 2016年 wqp. All rights reserved.
//

#import "ViewController.h"
#import "WQPChart.h"
@interface ViewController ()<WQPChartDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    //单个柱状图
//    WQPChart *chart = [[WQPChart alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 100) withDataSource:self andChatStyle:WQPChartStyleBar];
   //单个折线图
//    WQPChart *chart = [[WQPChart alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 100) withDataSource:self andChatStyle:WQPChartStyleline];
    //柱状折线图
    WQPChart *chart = [[WQPChart alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 100) withDataSource:self andChatStyle:WQPChartStyleAll];
    chart.curve = YES;
    [chart showInView:self.view];
}

- (NSMutableArray *)chatConfigYValue:(WQPChart *)chart {
    NSMutableArray *chartArray = [NSMutableArray arrayWithArray:@[@"2.1",@"3.4",@"1.7",@"2.5",@"1.5",@"2.8",@"3.0",@"2.8",@"2.3",@"1.0",@"3.6",@"1.7"]];
    return chartArray;
    //    return @[@"100",@"50",@"70",@"30",@"50",@"14",@"5",@"14",@"5",@"14"];
}

- (NSMutableArray *)chatConfigXValue:(WQPChart *)chart {
    NSMutableArray *axisArr = [NSMutableArray arrayWithArray:@[@"10月",@"11月",@"12月",@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月"]];
    return axisArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
