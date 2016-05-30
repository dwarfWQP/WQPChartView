//
//  WQPChartBar.m
//  仿QQ侧滑栏
//
//  Created by yunmai1 on 16/5/27.
//  Copyright © 2016年 wqp. All rights reserved.
//

#import "WQPChartBar.h"
#import "UIBezierPath+curved.h"
#define kBtnTag 1000
#define kBarLineColor [UIColor colorWithRed:1.000f green:0.769f blue:0.000f alpha:1.00f]
#define kCirCleColor [UIColor colorWithRed:0.859f green:0.871f blue:0.882f alpha:1.00f]
#define kHVLineColor [UIColor colorWithRed:0.918f green:0.929f blue:0.949f alpha:1.00f]
#define kBulldesFont [UIFont systemFontOfSize:10]

static const NSInteger kYEqualPaths = 3;//y轴为3等份
static const CGFloat kTopSpace = 50.f;//距离顶部y值
static const CGFloat kBarWidth = 25.f;//柱状的宽度
@interface WQPChartBar ()
@property (nonatomic, strong) CAShapeLayer * shapeLayer;
@property (nonatomic, strong) NSMutableArray * pointXArray;
@property (nonatomic, strong) NSMutableArray * pointYArray;
@property (nonatomic, strong) NSMutableArray * points;

@end

@implementation WQPChartBar
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (NSMutableArray *)pointYArray {
    if (!_pointYArray) {
        _pointYArray = [NSMutableArray array];
    }
    return _pointYArray;
}

- (NSMutableArray *)points {
    if (!_points) {
        _points = [NSMutableArray array];
    }
    return _points;
}

- (NSMutableArray *)pointXArray {
    if (!_pointXArray) {
        _pointXArray = [NSMutableArray array];
    }
    return _pointXArray;
}

- (void)setYMax:(CGFloat)yMax {
    _yMax = yMax;
}

- (void)setYValues:(NSArray *)yValues {
    _yValues = yValues;
    [self drawHorizontal];
}

- (void)setXValues:(NSArray *)xValues {
    _xValues = xValues;
    //    [self drawVertical];
}
//x轴
- (void)drawHorizontal{
    UIBezierPath * path = [UIBezierPath bezierPath];
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    for (NSInteger i = 0; i <= kYEqualPaths; i++) {
        [path moveToPoint:CGPointMake(30, chartBarAxisSpanY * i + kTopSpace)];
        [path addLineToPoint:CGPointMake(chartBarStartX + (_xValues.count) * 50,chartBarAxisSpanY * i + kTopSpace)];
        [path closePath];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
        shapeLayer.lineWidth = 0.5f;
        [self.layer addSublayer:shapeLayer];
    }
}
- (void)startDrawBar{
    //设置X轴
    for(NSInteger i = 0; i < _xValues.count; i++){
        [self.pointXArray addObject:@(chartBarStartX + chartBarAxisSpanX * i)];
    }
    //    //设置Y轴
    for(NSInteger i = 0; i < _yValues.count; i++){
        [self.pointYArray addObject:@(chartBarAxisSpanY * kYEqualPaths - [_yValues[i] floatValue]/_yMax * chartBarAxisSpanY * kYEqualPaths + kTopSpace)];
    }
    for (NSInteger i = 0; i < self.pointXArray.count; i++) {
        CGPoint point = CGPointMake([self.pointXArray[i] floatValue], [self.pointYArray[i] floatValue]);
        //        NSValue * value = [NSValue valueWithBytes:&point objCType:@encode(CGPoint)];
        NSValue * value = [NSValue valueWithCGPoint:point];
        [self.points addObject:value];
    }
    //画柱状
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.lineCap = kCALineCapButt;//线端点样式
    //    _shapeLayer.lineJoin = kCALineJoinMiter;//线的连接点样式
    _shapeLayer.lineWidth = kBarWidth;
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    _shapeLayer.strokeEnd = 0.f;
    _shapeLayer.strokeColor = kBarLineColor.CGColor;
    [self.layer addSublayer:_shapeLayer];
    UIBezierPath * bezierBarLine = [UIBezierPath bezierPath];
    for (NSInteger i = 0; i < self.points.count; i++) {
        CGPoint point = [self.points[i] CGPointValue];
        
        [bezierBarLine moveToPoint:CGPointMake(point.x/1.55+kBarWidth/5, kTopSpace + kYEqualPaths * chartBarAxisSpanY)];//位置
        [bezierBarLine addLineToPoint:CGPointMake(point.x/1.55+kBarWidth/5, point.y)];
        //      [self addBatTitle:CGPointMake(point.x + kBarWidth/2 + 10, point.y) andIndex:i];//加柱状label
        [self addXLabel:point andIndex:i];
    }
    [self addYLabel];
    _shapeLayer.path = bezierBarLine.CGPath;
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = self.points.count * 0.5f;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.f];
    pathAnimation.autoreverses = NO;
    [_shapeLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    _shapeLayer.strokeEnd = 1.f;
    
}
//标记x轴label 以及标签
- (void)addXLabel:(CGPoint)point andIndex:(NSInteger)index {
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, chartBarAxisSpanX, 20)];
    label.center = CGPointMake(point.x/1.55+kBarWidth/5, chartBarAxisSpanY * kYEqualPaths + kTopSpace + 20);
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:10.f];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = _xValues[index];
    [self addSubview:label];
}

- (void)addYLabel {
    for (NSInteger i = 0; i <= kYEqualPaths; i++) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(-20, chartBarAxisSpanY * i + kTopSpace, chartBarStartX - 5, 10)];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:10.f];
        label.textAlignment = NSTextAlignmentRight;
        [self addSubview:label];
        if (i == kYEqualPaths) {
            label.text = @"0";
        } else {
            NSLog(@"%f",_yMax);
            label.text = [NSString stringWithFormat:@"%.2f",_yMax - _yMax/3.f * i];
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
