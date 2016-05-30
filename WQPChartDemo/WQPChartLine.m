//
//  WQPChartLine.m
//  仿QQ侧滑栏
//
//  Created by yunmai1 on 16/5/27.
//  Copyright © 2016年 wqp. All rights reserved.
//

#import "WQPChartLine.h"
#import "UIBezierPath+curved.h"

#define kBtnTag 1000

static const NSInteger kYEqualPaths = 5;//y轴为4等份
static const CGFloat kTopSpace = 50.f;//距离顶部y值

@interface WQPChartLine ()

@property (nonatomic, strong) CAShapeLayer * shapeLineLayer;
@property (nonatomic, strong) CAShapeLayer * shapeHeightLineLayer;
@property (nonatomic, strong) CAShapeLayer * shapeTallestLineLayer;
@property (nonatomic, strong) NSMutableArray * pointXArray;
@property (nonatomic, strong) NSMutableArray * pointYArray;
@property (nonatomic, strong) NSMutableArray * points;

@end

@implementation WQPChartLine
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.curve = NO;
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

- (void)setCurve:(BOOL)curve {
    _curve = curve;
}

- (void)setYValues:(NSArray *)yValues {
    _yValues = yValues;
    [self drawHorizontal];
}

- (void)setXValues:(NSArray *)xValues {
    _xValues = xValues;
}

- (void)drawHorizontal {
    UIBezierPath * path = [UIBezierPath bezierPath];
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    for (NSInteger i = 0; i <= kYEqualPaths; i++) {
        
        [path moveToPoint:CGPointMake(30, chartLineAxisSpanY * i + kTopSpace)];
        [path addLineToPoint:CGPointMake(chartLineStartX + (_xValues.count - 1) * 50, chartLineAxisSpanY * i + kTopSpace)];
        [path closePath];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
        shapeLayer.lineWidth = 0.3f;
        [self.layer addSublayer:shapeLayer];
    }
}

- (void)startDrawLine {

    for(NSInteger i = 0; i < _xValues.count; i++){
        [self.pointXArray addObject:@(chartLineStartX + chartLineAxisSpanX * i)];
    }
  
    for(NSInteger i = 0; i < _yValues.count; i++){
        [self.pointYArray addObject:@(chartLineAxisSpanY * kYEqualPaths - [_yValues[i] floatValue]/_yMax * chartLineAxisSpanY * kYEqualPaths + kTopSpace)];
    }
    for (NSInteger i = 0; i < self.pointXArray.count; i++) {
        CGPoint point = CGPointMake([self.pointXArray[i] floatValue], [self.pointYArray[i] floatValue]);
        NSValue * value = [NSValue valueWithCGPoint:point];
        [self.points addObject:value];
    }
    //line one
    [self loadline:0 WithShapeLayer:_shapeLineLayer];
    //line two
    [self loadline:-20 WithShapeLayer:_shapeHeightLineLayer];
    //line three
    [self loadline:-70 WithShapeLayer:_shapeTallestLineLayer];
}
//x-axis
- (void)addXLabel:(CGPoint)point andIndex:(NSInteger)index {
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, chartLineAxisSpanX, 20)];
    label.center = CGPointMake(point.x, chartLineAxisSpanY * kYEqualPaths + kTopSpace + 20);
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:10.f];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = _xValues[index];
    [self addSubview:label];
}

//draw circle
- (void)addCircle:(CGPoint)point andIndex:(NSInteger)index andStatus:(NSInteger)status{
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 10, 10);
    btn.center = point;
    [self addSubview:btn];
    btn.tag = index + kBtnTag;
    if (status == 0) {
        btn.backgroundColor = [UIColor greenColor];
    }else if(status == 1){
        btn.backgroundColor = [UIColor redColor];
    }else{
        btn.backgroundColor = [UIColor blueColor];
    }
    btn.layer.borderWidth = 3.f;
    btn.layer.borderColor = [UIColor colorWithRed:0.780f green:0.780f blue:0.804f alpha:0.5f].CGColor;
    btn.layer.cornerRadius = 7.5f;
    btn.layer.masksToBounds = YES;
    btn.enabled = NO;
}

- (void)loadline:(NSInteger)lineY WithShapeLayer:(CAShapeLayer *)ShapeLayer{
    ShapeLayer = [CAShapeLayer layer];
    ShapeLayer.lineCap = kCALineCapRound;
    ShapeLayer.lineJoin = kCALineJoinRound;
    ShapeLayer.lineWidth = 2.f;
    ShapeLayer.fillColor = [UIColor clearColor].CGColor;
    ShapeLayer.strokeEnd = 0.f;
    [self.layer addSublayer:ShapeLayer];
    
    UIBezierPath * bezierLine = [UIBezierPath bezierPath];
    for (NSInteger i = 0; i < self.points.count; i++) {
        CGPoint point = [self.points[i] CGPointValue];
        if (i == 0) {
            [bezierLine moveToPoint:CGPointMake(point.x, point.y+lineY)];
        } else {
            [bezierLine addLineToPoint:CGPointMake(point.x, point.y+lineY)];
        }
        if (lineY == 0) {
            [self addCircle:CGPointMake(point.x, point.y+lineY) andIndex:i andStatus:0];
            ShapeLayer.strokeColor = [UIColor greenColor].CGColor;
        }
        else if(lineY == -20){
            [self addCircle:CGPointMake(point.x, point.y+lineY) andIndex:i andStatus:1];
            ShapeLayer.strokeColor = [UIColor redColor].CGColor;

        }else{
            [self addCircle:CGPointMake(point.x, point.y+lineY) andIndex:i andStatus:2];
            ShapeLayer.strokeColor = [UIColor blueColor].CGColor;

        }
            [self addXLabel:point andIndex:i];
    }
    [self addYLabel];
    if (self.curve) {
//        bezierLine =[bezierLine smoothedPathWithGranularity:20];//设置曲线
    }
    ShapeLayer.path = bezierLine.CGPath;
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = self.points.count * 0.5f;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.f];
    pathAnimation.autoreverses = NO;
    [ShapeLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    ShapeLayer.strokeEnd = 1.f;
    
}

- (void)addYLabel {
    for (NSInteger i = 0; i <= kYEqualPaths; i++) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(-20, chartLineAxisSpanY * i + kTopSpace, chartLineStartX - 5, 10)];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:10.f];
        label.textAlignment = NSTextAlignmentRight;
        [self addSubview:label];
        if (i == kYEqualPaths) {
            label.text = @"0";
        } else {
            label.text = [NSString stringWithFormat:@"%.1f万",_yMax - _yMax/4.f * i];
        }
    }
}


@end
