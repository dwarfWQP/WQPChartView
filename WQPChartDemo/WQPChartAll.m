//
//  WQPChartAll.m
//  SNChartView
//
//  Created by yunmai1 on 16/5/25.
//  Copyright © 2016年 wangsen. All rights reserved.
//

#import "WQPChartAll.h"
#import "UIBezierPath+curved.h"

#define kBtnTag 1000 //should set big value

static const NSInteger kYEqualPaths = 3;//y-axis is three equal
static const CGFloat kTopSpace = 50.f;//distance at the top of the y value
static const CGFloat kBarWidth = 25.f;//columnar width

@interface WQPChartAll ()
@property (nonatomic, strong) CAShapeLayer * shapeBarLayer;//columnar
@property (nonatomic, strong) CAShapeLayer * shapeLineLayer;//broken line
@property (nonatomic, strong) CAShapeLayer * shapeHeightLineLayer;
@property (nonatomic, strong) NSMutableArray * pointXArray;
@property (nonatomic, strong) NSMutableArray * pointYArray;
@property (nonatomic, strong) NSMutableArray * points;
@property (nonatomic, strong) NSMutableArray *buttonArr;

@end
@implementation WQPChartAll

//init
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        self.curve = NO;
    }
    return self;
}

//set methods
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

//drawHorizontal
- (void)drawHorizontal{
    UIBezierPath * path = [UIBezierPath bezierPath];
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    
    for (NSInteger i = 0; i <= kYEqualPaths; i++) {
        [path moveToPoint:CGPointMake(30, chartAllAxisSpanY * i + kTopSpace)];
        [path addLineToPoint:CGPointMake(_xValues.count * 50, chartAllAxisSpanY * i + kTopSpace)];
        [path closePath];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
        shapeLayer.lineWidth = 0.5f;
        [self.layer addSublayer:shapeLayer];
    }

}

- (void)startDrawBarAndLines{
    //set x-axis
    for(NSInteger i = 0; i < _xValues.count; i++){
        [self.pointXArray addObject:@(chartAllStartX + chartAllAxisSpanX * i)];
    }
    //set y-axis
    for(NSInteger i = 0; i < _yValues.count; i++){
        [self.pointYArray addObject:@(chartAllAxisSpanY * kYEqualPaths - [_yValues[i] floatValue]/_yMax * chartAllAxisSpanY * kYEqualPaths + kTopSpace)];
    }
    for (NSInteger i = 0; i < self.pointXArray.count; i++) {
        CGPoint point = CGPointMake([self.pointXArray[i] floatValue], [self.pointYArray[i] floatValue]);
        //        NSValue * value = [NSValue valueWithBytes:&point objCType:@encode(CGPoint)];
        NSValue * value = [NSValue valueWithCGPoint:point];
        [self.points addObject:value];
    }
    //draw columnar
    _shapeBarLayer = [CAShapeLayer layer];
    _shapeBarLayer.lineCap = kCALineCapButt;//Line endpoint style
    _shapeBarLayer.lineWidth = kBarWidth;
    _shapeBarLayer.fillColor = [UIColor clearColor].CGColor;
    _shapeBarLayer.strokeEnd = 0.f;
    _shapeBarLayer.strokeColor = [UIColor blueColor].CGColor;
    [self.layer addSublayer:_shapeBarLayer];
    UIBezierPath * bezierBarLine = [UIBezierPath bezierPath];
    for (NSInteger i = 0; i < self.points.count; i++) {
        CGPoint point = [self.points[i] CGPointValue];

        [bezierBarLine moveToPoint:CGPointMake(point.x/1.55+kBarWidth/5, kTopSpace + kYEqualPaths * chartAllAxisSpanY)];//postion
        [bezierBarLine addLineToPoint:CGPointMake(point.x/1.55+kBarWidth/5, point.y)];
//      [self addBatTitle:CGPointMake(point.x + kBarWidth/2 + 10, point.y) andIndex:i];//add columnar label
        [self addXLabel:point andIndex:i];
    }
    _shapeBarLayer.path = bezierBarLine.CGPath;
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = self.points.count * 0.5f;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.f];
    pathAnimation.autoreverses = NO;
    [_shapeBarLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    _shapeBarLayer.strokeEnd = 1.f;
    //add button
    [self CreateButton];
    //line one
    [self loadline:0 WithShapeLayer:_shapeLineLayer];
    //line two
    [self loadline:-10 WithShapeLayer:_shapeHeightLineLayer];
    //add label
    [self CreateLabel];
    
}

#pragma mark - multiple lines
- (void)loadline:(NSInteger)lineY WithShapeLayer:(CAShapeLayer *)ShapeLayer{
    ShapeLayer = [CAShapeLayer layer];
    ShapeLayer.lineCap = kCALineCapRound;
    ShapeLayer.lineJoin = kCALineJoinRound;
    ShapeLayer.lineWidth = 2.f;
    ShapeLayer.fillColor = [UIColor clearColor].CGColor;
    ShapeLayer.strokeEnd = 0.f;
    [self.layer addSublayer:ShapeLayer];
    //draw content of chart
    UIBezierPath * bezierLine = [UIBezierPath bezierPath];
    for (NSInteger i = 0; i < self.points.count; i++) {
        CGPoint point = [self.points[i] CGPointValue];
        if (i == 0) {
            //point
            [bezierLine moveToPoint:CGPointMake(point.x/1.55+kBarWidth/5, point.y+lineY)];
            
        } else {
            //attachment
            [bezierLine addLineToPoint:CGPointMake(point.x/1.55+kBarWidth/5, point.y+lineY)];
        }
        //There are two types of round
        if (lineY == 0) {
            [self addCircle:CGPointMake(point.x/1.55+kBarWidth/5, point.y+lineY) andIndex:i andStatus:0];
            ShapeLayer.strokeColor = [UIColor redColor].CGColor;
        }
        else{
            [self addCircle:CGPointMake(point.x/1.55+kBarWidth/5, point.y+lineY) andIndex:i andStatus:1];
            ShapeLayer.strokeColor = [UIColor orangeColor].CGColor;
        }
    }
    [self addYLabel];
    
    //sets the curve
    if (self.curve) {
        bezierLine =[bezierLine smoothedPathWithGranularity:20];
    }
    //Graphics trajectory
    ShapeLayer.path = bezierLine.CGPath;
    //shape animation  PS:In the last period of time,animation from fromValue to toValue
    //you can reference http://blog.sina.com.cn/s/blog_51a995b70102vdfe.html
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = self.points.count * 0.5f;//runtime
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];//keyPath start value
    pathAnimation.toValue = [NSNumber numberWithFloat:1.f];//keyPath end value
    pathAnimation.autoreverses = NO;
    [ShapeLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    ShapeLayer.strokeEnd = 1.f;
}
#pragma mark - divide y-axis
- (void)addYLabel {
    for (NSInteger i = 0; i <= kYEqualPaths; i++) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(-20, chartAllAxisSpanY * i + kTopSpace, chartAllStartX - 5, 10)];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:10.f];
        label.textAlignment = NSTextAlignmentRight;
        [self addSubview:label];
        if (i == kYEqualPaths) {
            label.text = @"0";
        } else {
            label.text = [NSString stringWithFormat:@"%.1f万",_yMax - _yMax/3.f * i];
        }
    }
}

#pragma mark - draw circle
- (void)addCircle:(CGPoint)point andIndex:(NSInteger)index andStatus:(NSInteger)status{

    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 10, 10);
    btn.center = point;
    [self addSubview:btn];
    btn.tag = index + kBtnTag;
    if (status == 0) {
       btn.backgroundColor = [UIColor redColor];
    }else{
       btn.backgroundColor = [UIColor orangeColor];
    }
    //button style
    btn.layer.borderWidth = 3.f;
    btn.layer.borderColor = [UIColor colorWithRed:0.780f green:0.780f blue:0.804f alpha:0.5f].CGColor;
    btn.layer.cornerRadius = 7.5f;
    btn.layer.masksToBounds = YES;
    btn.enabled = NO;
}

#pragma mark - the x-axis for the assignment
- (void)addXLabel:(CGPoint)point andIndex:(NSInteger)index {
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, chartAllAxisSpanX, 20)];
    label.center = CGPointMake(point.x/1.55+kBarWidth/5, chartAllAxisSpanY * kYEqualPaths + kTopSpace + 20);
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:10.f];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = _xValues[index];
    [self addSubview:label];
}

#pragma mark - create label   PS:chart labels
- (void)CreateLabel{
    //圆点1
    UILabel * cirlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    cirlabel.center = CGPointMake(25, chartAllAxisSpanY * kYEqualPaths + kTopSpace + 50);
    cirlabel.backgroundColor = [UIColor orangeColor];
    cirlabel.layer.masksToBounds = YES;
    cirlabel.layer.cornerRadius = 6.f;
    [self addSubview:cirlabel];
    
    UILabel * marklabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    marklabel.center = CGPointMake(75, chartAllAxisSpanY * kYEqualPaths + kTopSpace + 50);
    marklabel.text = @"参考均价";
    marklabel.textColor = [UIColor blackColor];
    [self addSubview:marklabel];
    //圆点2
    UILabel * cirlabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    cirlabel2.center = CGPointMake(CGRectGetMaxX(marklabel.frame)+10, chartAllAxisSpanY * kYEqualPaths + kTopSpace + 50);
    cirlabel2.backgroundColor = [UIColor redColor];
    cirlabel2.layer.masksToBounds = YES;
    cirlabel2.layer.cornerRadius = 6.f;
    [self addSubview:cirlabel2];
    
    UILabel * marklabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    marklabel2.center = CGPointMake(CGRectGetMaxX(cirlabel2.frame)+45, chartAllAxisSpanY * kYEqualPaths + kTopSpace + 50);
    marklabel2.text = @"挂牌均价";
    marklabel2.textColor = [UIColor blackColor];
    [self addSubview:marklabel2];
    
    //圆点3
    UILabel * cirlabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    cirlabel3.center = CGPointMake(CGRectGetMaxX(marklabel2.frame)+10, chartAllAxisSpanY * kYEqualPaths + kTopSpace + 50);
    cirlabel3.backgroundColor = [UIColor blueColor];
    cirlabel3.layer.masksToBounds = YES;
    cirlabel3.layer.cornerRadius = 6.f;
    [self addSubview:cirlabel3];
    
    UILabel * marklabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    marklabel3.center = CGPointMake(CGRectGetMaxX(cirlabel3.frame)+45, chartAllAxisSpanY * kYEqualPaths + kTopSpace + 50);
    marklabel3.text = @"成交量/套";
    marklabel3.textColor = [UIColor blackColor];
    [self addSubview:marklabel3];
}

#pragma mark - create chart button
- (void)CreateButton{
    NSMutableArray *title = [NSMutableArray arrayWithObjects:@"全部",@"一居",@"两居",@"三居",nil];
    _buttonArr = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 65, 25)];
        button.center = CGPointMake(60 + 100 * i, kTopSpace - 25);//顶部button
        button.tag = i + 100;
        button.layer.cornerRadius = 5.0f;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.borderWidth = 1.f;
        [button setTitle:[title objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.backgroundColor = [UIColor clearColor];
        if (button.tag == 100) {
            button.backgroundColor = [UIColor orangeColor];
        }
        else{
            button.backgroundColor = [UIColor whiteColor];
        }
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.masksToBounds = YES;
        [self addSubview:button];
        [_buttonArr addObject:button];
    }

}
//click on the button to change button background
- (void)buttonClick:(UIButton *)btn{

    for (UIButton *button in _buttonArr){
        
        if (button.tag == btn.tag) {
            
            button.backgroundColor =[UIColor orangeColor];
            
        } else {
            
            button.backgroundColor =[UIColor whiteColor];
            
        }

    }
    
}

#pragma mark - histogram title  PS:numbers
- (void)addBatTitle:(CGPoint)point andIndex:(NSInteger)index {
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kBarWidth, 10)];
    label.center = CGPointMake(point.x, point.y - 10.f);
    label.font = [UIFont systemFontOfSize:10.f];
    label.text = _yValues[index];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blueColor];//这个改柱状label的颜色
    [self addSubview:label];
}
#pragma mark - lazy load
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

@end
