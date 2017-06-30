//
//  EZImageBrowserLoading.m
//  EZImageBrowserExample
//
//  Created by Zhu yangjun on 2017/6/28.
//  Copyright © 2017年 Zhu yangjun. All rights reserved.
//


#import "EZImageBrowserLoading.h"

@interface EZImageBrowserLoading()

// 外界圆形
@property (nonatomic, strong) CAShapeLayer *circleLayer;
// 内部扇形
@property (nonatomic, strong) CAShapeLayer *fanshapedLayer;
// 错误
@property (nonatomic, strong) CAShapeLayer *errorLayer;

@end

@implementation EZImageBrowserLoading
#pragma mark - Life Cycle
-(instancetype)init{
    return  [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect rect = self.frame;
        rect.size = CGSizeMake(50, 50);
        self.frame = rect;
        [self __commonInit];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self __commonInit];
}

-(void)dealloc{
}



#pragma mark - set
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self __updateProgressLayer];
}

#pragma mark - public
- (void)showError {
    self.errorLayer.hidden = false;
    self.fanshapedLayer.hidden = true;
}

- (void)showAnimateByPropress:(CGFloat)progress{
    self.hidden = false;
    self.progress = progress;
}

#pragma mark - private
- (void)__commonInit {
    self.backgroundColor = [UIColor clearColor];
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.strokeColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8].CGColor;
    circleLayer.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    circleLayer.path = [self __circlePath].CGPath;
    [self.layer addSublayer:circleLayer];
    self.circleLayer = circleLayer;
    
    CAShapeLayer *fanshapedLayer = [CAShapeLayer layer];
    fanshapedLayer.fillColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8].CGColor;
    [self.layer addSublayer:fanshapedLayer];
    self.fanshapedLayer = fanshapedLayer;
    
    CAShapeLayer *errorLayer = [CAShapeLayer layer];
    errorLayer.frame = self.bounds;
    // 旋转 45 度
    errorLayer.affineTransform = CGAffineTransformMakeRotation(M_PI_4);
    errorLayer.fillColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8].CGColor;
    errorLayer.path = [self __errorPath].CGPath;
    [self.layer addSublayer:errorLayer];
    self.errorLayer = errorLayer;
}

- (void)__updateProgressLayer {
    self.errorLayer.hidden = true;
    self.fanshapedLayer.hidden = false;
    
    self.fanshapedLayer.path = [self __pathForProgress:self.progress].CGPath;
}

- (UIBezierPath *)__errorPath {
    CGFloat width = 30;
    CGFloat height = 5;
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRect:CGRectMake(self.frame.size.width * 0.5 - height * 0.5, (self.frame.size.width - width) * 0.5, height, width)];
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRect:CGRectMake((self.frame.size.width - width) * 0.5, self.frame.size.width * 0.5 - height * 0.5, width, height)];
    [path2 appendPath:path1];
    return path2;
}

- (UIBezierPath *)__circlePath {
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5) radius:25 startAngle:0 endAngle:M_PI * 2 clockwise:true];
    path.lineWidth = 1;
    return path;
}

- (UIBezierPath *)__pathForProgress:(CGFloat)progress {
    CGPoint center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    CGFloat radius = self.frame.size.height * 0.5 - 2.5;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: center];
    [path addLineToPoint:CGPointMake(self.frame.size.width * 0.5, center.y - radius)];
    [path addArcWithCenter:center radius: radius startAngle: -M_PI / 2 endAngle: -M_PI / 2 + M_PI * 2 * progress clockwise:true];
    [path closePath];
    path.lineWidth = 1;
    return path;
}

@end
