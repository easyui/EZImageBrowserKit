//
//  EZImageBrowserCell.m
//  EZImageBrowserExample
//
//  Created by Zhu yangjun on 2017/6/28.
//  Copyright © 2017年 Zhu yangjun. All rights reserved.
//



#import "EZImageBrowserCell.h"
@interface EZImageBrowserCell()<UIScrollViewDelegate>
@property (nonatomic, strong) EZImageBrowserLoading *loadingView;
@property (nonatomic, strong) UIImageView *imageView;

///cell的大小，set方法中同时设置imageView的frame和scrollView.contentSize的大小
@property (nonatomic, assign) CGSize showCellSize;
@property (nonatomic, assign) CGPoint lastContentOffset;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat offsetY;

@end

@implementation EZImageBrowserCell
#pragma mark - Life Cycle
-(instancetype)init{
    return  [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect rect = self.frame;
        rect.size = CGSizeMake(0, 0);
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

- (void)layoutSubviews {
    [super layoutSubviews];
    self.loadingView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
}


#pragma mark - public

- (void)animationShowWithFromRect:(CGRect)rect animationBlock:(void (^)())animationBlock completionBlock:(void (^)())completionBlock {
    self.imageView.frame = rect;
    [UIView animateWithDuration:0.25 animations:^{
        if (animationBlock != nil) {
            animationBlock();
        }
        self.imageView.frame = [self __updateImageViewOrigin:self.showCellSize];
    } completion:^(BOOL finished) {
        if (finished) {
            if (completionBlock) {
                completionBlock();
            }
        }
    }];
}

- (void)animationDismissWithToRect:(CGRect)rect animationBlock:(void (^)())animationBlock completionBlock:(void (^)())completionBlock {
    
    [UIView animateWithDuration:0.25 animations:^{
        if (animationBlock) {
            animationBlock();
        }
        CGRect toRect = rect;
        toRect.origin.y += self.offsetY;
        // 这一句话用于在放大的时候去关闭
        toRect.origin.x += self.contentOffset.x;
        self.imageView.frame = toRect;
    } completion:^(BOOL finished) {
        if (finished) {
            if (completionBlock) {
                completionBlock();
            }
        }
    }];
}

- (void)animationExpandDismissByAnimationBlock:(void(^)())animationBlock completionBlock:(void(^)())completionBlock{
    [UIView animateWithDuration:0.25 animations:^{
        if (animationBlock) {
            animationBlock();
        }
        self.imageView.transform = CGAffineTransformMakeScale(2, 2);
    } completion:^(BOOL finished) {
        if (finished) {
            if (completionBlock) {
                completionBlock();
            }
        }
    }];
}

- (void)animationSlideOutDismissByAnimationBlock:(void(^)())animationBlock completionBlock:(void(^)())completionBlock{
    [UIView animateWithDuration:0.3 animations:^{
        if (animationBlock) {
            animationBlock();
        }
        CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
        if (self.offsetY < 0) {
            CGFloat distance = screenH - (self.imageView.frame.origin.y + (-self.offsetY));
            self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y + distance, self.imageView.frame.size.width, self.imageView.frame.size.height);
        }else{
            CGFloat distance = self.imageView.frame.origin.y + self.imageView.frame.size.height - self.offsetY;
            self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y - distance, self.imageView.frame.size.width, self.imageView.frame.size.height);
        }
    } completion:^(BOOL finished) {
        if (finished) {
            if (completionBlock) {
                completionBlock();
            }
        }
    }];
}


- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center{
//    center = [self.superview convertPoint:center toView:self.imageView];
    CGRect zoomRect;
    zoomRect.size.height =self.frame.size.height / scale;
    zoomRect.size.width  =self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}

#pragma mark - private
- (void)__commonInit {
    self.maxDropedScale = 0.16;
    
    self.delegate = self;
    self.alwaysBounceVertical = true;
    self.backgroundColor = [UIColor clearColor];
    self.showsHorizontalScrollIndicator = false;
    self.showsVerticalScrollIndicator = false;
    self.maximumZoomScale = 2; //最大两倍
    
    // 添加 imageView
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.clipsToBounds = true;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.frame = self.bounds;
    self.imageView = imageView;
    [self addSubview:imageView];
    
    // 添加进度view
    EZImageBrowserLoading *loadingView = [[EZImageBrowserLoading alloc] init];
    [self addSubview:loadingView];
    self.loadingView = loadingView;
    self.loadingView.hidden = YES;
    
    //为了xib初始化的上面加子控件不被挡住，因为走到这个方法应该都初始化好了
    [self sendSubviewToBack:self.loadingView];
    [self sendSubviewToBack:self.imageView];
    
}

- (CGRect)__updateImageViewOrigin:(CGSize)imageSize {
    CGFloat x = 0;
    CGFloat y = 0;
    if (imageSize.height < [UIScreen mainScreen].bounds.size.height) {
        y = ([UIScreen mainScreen].bounds.size.height - imageSize.height) / 2;
    }else{
        
        
    }
    return CGRectMake(x, y, imageSize.width, imageSize.height);
}


#pragma mark - set
- (void)setContentSize:(CGSize)contentSize {
    [super setContentSize:contentSize];
    if (self.zoomScale == 1) {//双击缩回原图的时候设置回中点
        [UIView animateWithDuration:0.25 animations:^{
            CGPoint center = self.imageView.center;
            center.x = self.contentSize.width * 0.5;
            self.imageView.center = center;
        }];
    }
}

- (void)setLastContentOffset:(CGPoint)lastContentOffset {
    if (self.dragging == true || self.scale <= self.maxDropedScale) {
        _lastContentOffset = lastContentOffset;
    }
}


- (void)setImageViewSize:(CGSize)imageViewSize {
    _imageViewSize = imageViewSize;
    if (CGSizeEqualToSize(imageViewSize, CGSizeZero)) {
        return;
    }
    // 计算实际的大小
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat scale = screenW / imageViewSize.width;
    CGFloat height = scale * imageViewSize.height;
    self.showCellSize = CGSizeMake(screenW, height);
}


- (void)setShowCellSize:(CGSize)showCellSize {
    _showCellSize = showCellSize;
    self.imageView.frame = [self __updateImageViewOrigin:_showCellSize];
    self.contentSize = self.imageView.frame.size;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    NSLog(@"scrollView.contentOffset %@" ,NSStringFromCGPoint(scrollView.contentOffset));
    //    NSLog(@"image %@" ,NSStringFromCGRect(self.imageView.frame));
    
    // 保存 offsetY ,动画做准备
    self.offsetY = scrollView.contentOffset.y;
    
    self.lastContentOffset = scrollView.contentOffset;
    // 正在动画
    if ([self.imageView.layer animationForKey:@"transform"] != nil) {
        return;
    }
    // 用户正在缩放
    if (self.zoomBouncing || self.zooming) {
        return;
    }
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    // 图片长度大于屏幕长度
    if (scrollView.contentSize.height > screenH) {
        //因为当图片长度大于屏幕长度，显示图片浏览器时，图片Origin是(0,0) ，所以此处是往下滚动，没达到底部就return
        if (self.lastContentOffset.y > 0 && self.lastContentOffset.y <= scrollView.contentSize.height - screenH) {
            return;
        }
    }
    /*
     下面是contentSize滚动到上下超过边界值
     */
    
    self.scale = fabs(self.lastContentOffset.y) / screenH;
    // 如果内容高度 > 屏幕高度
    // 并且偏移量 > 内容高度 - 屏幕高度
    // 那么就代表滑动到最底，且超过底部
    
    if (scrollView.contentSize.height > screenH &&
        self.lastContentOffset.y > scrollView.contentSize.height - screenH) {
        self.scale = (self.lastContentOffset.y - (scrollView.contentSize.height - screenH)) / screenH;
    }
    
    [_cellDelegate cell:self scale:_scale];
    
    
    // 如果用户松手
    if (scrollView.dragging == false) {
        if (self.scale > self.maxDropedScale && self.scale <= 1) {
            [_cellDelegate cellTouchOff:self];
            //保持原位，准备dismiss，否则会先到中间动画然后再执行dimiss动画
            [scrollView setContentOffset:self.lastContentOffset animated:false];
        }
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGPoint center = _imageView.center;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    center.y = scrollView.contentSize.height * 0.5 + offsetY;
    _imageView.center = center;
    
    // 如果是缩小，保证在屏幕中间
    if (scrollView.zoomScale < scrollView.minimumZoomScale) {
        CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
        center.x = scrollView.contentSize.width * 0.5 + offsetX;
        _imageView.center = center;
    }
}

//指定缩放控件
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

@end
