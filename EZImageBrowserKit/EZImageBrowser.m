//
//  EZImageBrowser.m
//  EZImageBrowserExample
//
//  Created by Zhu yangjun on 2017/6/28.
//  Copyright © 2017年 Zhu yangjun. All rights reserved.
//


#import "EZImageBrowser.h"
#import "EZImageBrowserCell.h"

@interface EZImageBrowser()<UIScrollViewDelegate, EZImageBrowserCellDelegate>
/// 界面子控件
@property (nonatomic, strong) UIScrollView *scrollView;
/// cell的索引label
@property (nonatomic, strong) UILabel *pageTextLabel;
/// cell数组，3个 EZImageBrowserCell。进行复用
@property (nonatomic, strong) NSMutableArray<EZImageBrowserCell *> *cells;
/// 准备待用的cell视图（缓存）
@property (nonatomic, strong) NSMutableArray<EZImageBrowserCell *> *readyToUseCells;
/// cell总数
@property (nonatomic, assign, readonly) NSInteger cellCount;
/// 当前cell索引
@property (nonatomic, assign) NSInteger currentIndex;
/// 长按手势
@property (nullable, nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;


@end

@implementation EZImageBrowser
#pragma mark - Life Cycle
-(instancetype)init{
    return  [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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


#pragma mark - public
- (void)showFromView:(UIView *)fromView currentIndex:(NSInteger)currentIndex completion:(void (^ __nullable)(void))completion {
    
    NSAssert(self.delegate != nil, @"Please set up delegate for EZImageBrowser");
    
    // 记录值并设置位置
    _currentIndex = currentIndex;
    NSInteger cellCount = self.cellCount;
    // 添加到 window 上
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    // 更新page text
    [self __updatePageText:_currentIndex];
    // 计算 scrollView 的 contentSize
    self.scrollView.contentSize = CGSizeMake(cellCount * self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    // 滚动到指定位置
    [self.scrollView setContentOffset:CGPointMake(self.currentIndex * self.scrollView.frame.size.width, 0) animated:false];
    // 设置第1个 view 的位置以及大小
    EZImageBrowserCell *cell = [self __cellForIndex:_currentIndex];
    // 获取来源图片在屏幕上的位置
    CGRect rect = [fromView convertRect:fromView.bounds toView:nil];
    if ([self.delegate respondsToSelector:@selector(imageBrowserWillAppear:)]) {
        [self.delegate imageBrowserWillAppear:self];
    }
    [cell animationShowWithFromRect:rect animationBlock:^{
        self.backgroundColor = [UIColor blackColor];
        self.pageTextLabel.alpha = 1;
    } completionBlock:^{
        // 设置左边与右边的 cell
        if (_currentIndex != 0 && cellCount > 1) {
            // 设置左边
            [self __cellForIndex:_currentIndex - 1 ];
        }
        
        if (_currentIndex + 1 < cellCount) {
            // 设置右边
            [self __cellForIndex:_currentIndex + 1 ];
        }
        if (completion) {
            completion();
        }
        if ([self.delegate respondsToSelector:@selector(imageBrowserDidAppear:)]) {
            [self.delegate imageBrowserDidAppear:self];
        }
    }];
}

- (void)dismissCompletion: (void (^ __nullable)(void))completion{
    if ([self.delegate respondsToSelector:@selector(imageBrowserWillDisappear:)]) {
        [self.delegate imageBrowserWillDisappear:self];
    }
    // 取到当前显示的 cell
    EZImageBrowserCell *cell = [[self.cells filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"index == %d", _currentIndex]] firstObject];

    CGFloat x = [UIScreen mainScreen].bounds.size.width * 0.5;
    CGFloat y = [UIScreen mainScreen].bounds.size.height * 0.5;
    CGRect rect = CGRectMake(x, y, 0, 0);
    if ([self.delegate respondsToSelector:@selector(imageBrowser:fromViewForItemAtIndex:)]) {
        UIView *endView = [self.delegate imageBrowser:self fromViewForItemAtIndex:_currentIndex];
        if (endView.superview != nil) {
            rect = [endView convertRect:endView.bounds toView:nil];
            // 执行关闭动画
            [cell animationDismissWithToRect:rect animationBlock:^{
                self.backgroundColor = [UIColor clearColor];
                self.pageTextLabel.alpha = 0;
            } completionBlock:^{
                [self removeFromSuperview];
                if (completion) {
                    completion();
                }
                if ([self.delegate respondsToSelector:@selector(imageBrowserDidDisappear:)]) {
                    [self.delegate imageBrowserDidDisappear:self];
                }
            }];

            return;
        }
    }
    
    // 执行关闭动画
    [cell animationExpandDismissByAnimationBlock:^{
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
        self.pageTextLabel.alpha = 0;
    } completionBlock:^{
        [self removeFromSuperview];
        if (completion) {
            completion();
        }
        if ([self.delegate respondsToSelector:@selector(imageBrowserDidDisappear:)]) {
            [self.delegate imageBrowserDidDisappear:self];
        }
    }];
}


- (nullable __kindof EZImageBrowserCell *)dequeueReusableCell{
    if (self.readyToUseCells.count > 0) {
       EZImageBrowserCell * view = [self.readyToUseCells firstObject];
        [self.readyToUseCells removeObjectAtIndex:0];
        return view;
    }
    return nil;
}

#pragma mark - GestureRecognizer
- (void)longPressGesAction:(UILongPressGestureRecognizer *)ges {
    if (ges.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(imageBrowser:didLongPressCellAtIndex:)]) {
            [self.delegate imageBrowser:self didLongPressCellAtIndex:self.currentIndex];
        }
    }
}

- (void)singleTapGesAction:(UITapGestureRecognizer *)ges {
    if ([self.delegate respondsToSelector:@selector(imageBrowser:didClickCellAtIndex:)]) {
        [self.delegate imageBrowser:self didClickCellAtIndex:self.currentIndex];
    }else{
        [self dismissCompletion:nil];
    }
}

- (void)doubleTapGesAction:(UITapGestureRecognizer *)ges {
    if ([self.delegate respondsToSelector:@selector(imageBrowser:didDoubleClickCellAtIndex:)]) {
        [self.delegate imageBrowser:self didDoubleClickCellAtIndex:self.currentIndex];
    }else{
        CGFloat newScale = 2;
        EZImageBrowserCell *cell = [[self.cells filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"index == %d", _currentIndex]] firstObject];
        if (cell.zoomScale != 1) {
            newScale = 1;
        }
        CGRect zoomRect = [cell zoomRectForScale:newScale withCenter:[ges locationInView:ges.view]];
        [cell zoomToRect:zoomRect animated:YES];
    }
    
}

#pragma mark - set
- (void)setCellMarginForLandscape:(CGFloat)cellMarginForLandscape {
    _cellMarginForLandscape = cellMarginForLandscape;
    self.scrollView.frame = CGRectMake(-_cellMarginForLandscape * 0.5, 0, self.frame.size.width + _cellMarginForLandscape, self.frame.size.height);
}

-(void)setSupportLongPress:(BOOL)supportLongPress{
    _supportLongPress = supportLongPress;
    if (self.longPressGestureRecognizer) {
        [self removeGestureRecognizer:self.longPressGestureRecognizer];
    }
    if (_supportLongPress) {
        self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesAction:)];
        [self addGestureRecognizer:self.longPressGestureRecognizer];
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    if (_currentIndex == currentIndex) {
        return;
    }
    NSUInteger oldValue = _currentIndex;
    _currentIndex = currentIndex;
    [self __removeViewToReUse];
    [self __updatePageText:currentIndex];
    // 如果新值大于旧值
    if (currentIndex > oldValue) {
        // 往右滑，设置右边的视图
        if (currentIndex + 1 < self.cellCount) {
            [self __cellForIndex:currentIndex + 1];
        }
    }else {
        // 往左滑，设置左边的视图
        if (currentIndex > 0) {
            [self __cellForIndex:currentIndex - 1 ];
        }
    }
}

- (void)setPageTextPosition:(EZImageBrowserPageTextPosition)pageTextPosition{
    _pageTextPosition = pageTextPosition;
    switch (_pageTextPosition) {
        case EZImageBrowserPageTextPositionTop:
            self.pageTextLabel.center = CGPointMake(self.bounds.size.width * 0.5,  [UIApplication sharedApplication].statusBarFrame.size.height + 20);
            break;
        case EZImageBrowserPageTextPositionBottom:
            self.pageTextLabel.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height - 20);
            break;
        default:
            break;
    }
}

#pragma mark -  get
-(NSInteger)cellCount{
    return  [self.delegate numberOfCellsInImageBrowser:self];
}

#pragma mark - private
- (void)__commonInit{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor clearColor];
    
    // 初始化label
    UILabel *label = [[UILabel alloc] init];
    label.alpha = 0;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16];
    [self addSubview:label];
    self.pageTextLabel = label;
    self.pageTextPosition = EZImageBrowserPageTextPositionBottom;
    
    // 初始化 scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    scrollView.showsVerticalScrollIndicator = false;
    scrollView.showsHorizontalScrollIndicator = false;
    scrollView.pagingEnabled = true;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    self.cellMarginForLandscape = 20;
    
    // 初始化数组
    self.cells = [NSMutableArray array];
    self.readyToUseCells = [NSMutableArray array];
    
    // 添加手势事件
    UITapGestureRecognizer *singleTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesAction:)];
    singleTapGes.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleTapGes];
    
    UITapGestureRecognizer *doubleTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGesAction:)];
    doubleTapGes.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTapGes];
    
    [singleTapGes requireGestureRecognizerToFail:doubleTapGes];
}

/**
 设置文字
 */
- (void)__updatePageText:(NSUInteger)index {
    if ([self.delegate respondsToSelector:@selector(imageBrowser:pageTextForItemAtIndex:count:)]) {
        self.pageTextLabel.text = [self.delegate imageBrowser:self pageTextForItemAtIndex:index count:self.cellCount];
    }else{
        self.pageTextLabel.text = [NSString stringWithFormat:@"%zd / %zd", index + 1, self.cellCount];
    }
    CGPoint oldCenter = self.pageTextLabel.center;
    [self.pageTextLabel sizeToFit];
    _pageTextLabel.center = oldCenter;
}

/**
 设置cell到指定位置
 
 @param index 索引
 
 @return 当前设置的控件
 */
- (EZImageBrowserCell *)__cellForIndex:(NSInteger)index{
    [self __removeViewToReUse];
    
    EZImageBrowserCell *cell  = [self.delegate imageBrowser:self cellForRowAtIndex:index];
    NSAssert(cell != nil, @"EZImageBrowserCell object can not be nil！");
    cell.cellDelegate = self;
    [_scrollView addSubview:cell];
    [self.cells addObject:cell];
    cell.index = index;
    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, self.frame.size.width, self.frame.size.height);//大小等于图片浏览器的大小
    CGPoint center = cell.center;
    center.x = index * _scrollView.frame.size.width + _scrollView.frame.size.width * 0.5;
    cell.center = center;
    if ([self.delegate respondsToSelector:@selector(imageBrowser:imageViewSizeForItemAtIndex:)]) {
        cell.imageViewSize = [self.delegate imageBrowser:self imageViewSizeForItemAtIndex:index];
    }else if ( cell.imageView.image){
        cell.imageViewSize =  cell.imageView.image.size;
    }else{
        cell.imageViewSize =  CGSizeMake(1, 1);//给个默认值吧，设置imageViewSize，在set方法里会根据(1, 1)计算出正方形大小
    }

    return cell;
}


/**
 移动到超出屏幕的视图到可重用数组里面去
 */
- (void)__removeViewToReUse {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (EZImageBrowserCell *view in self.cells) {
        // 判断某个view的页数与当前页数相差值为2的话，那么让这个view从视图上移除
        if (abs((int)view.index - (int)self.currentIndex) >= 2){
            [tempArray addObject:view];
            [view removeFromSuperview];
            [self.readyToUseCells addObject:view];
        }
    }
    [self.cells removeObjectsInArray:tempArray];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSUInteger page = (scrollView.contentOffset.x / scrollView.frame.size.width + 0.5);
    NSInteger oldPage = self.currentIndex;
    self.currentIndex = page;
    if (self.currentIndex != oldPage) {
        if ([self.delegate respondsToSelector:@selector(imageBrowser:didDisplayingCell:atIndex:)]) {
            EZImageBrowserCell *currentCell = [[self.cells filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"index == %d", self.currentIndex]] firstObject];
            [self.delegate imageBrowser:self didDisplayingCell: currentCell atIndex: self.currentIndex];
        }
    }
    
}

#pragma mark - EZImageBrowserDelegate
- (void)cellTouchOff:(EZImageBrowserCell *)cell {
    if ([self.delegate respondsToSelector:@selector(imageBrowserWillDisappear:)]) {
        [self.delegate imageBrowserWillDisappear:self];
    }
    if ([self.delegate respondsToSelector:@selector(imageBrowser:fromViewForItemAtIndex:)]) {
        UIView *endView = [self.delegate imageBrowser:self fromViewForItemAtIndex:_currentIndex];
        if (endView.superview != nil) {
            // 执行关闭动画
            [cell animationDismissWithToRect:[endView convertRect:endView.bounds toView:nil] animationBlock:^{
            } completionBlock:^{
                [self removeFromSuperview];
                if ([self.delegate respondsToSelector:@selector(imageBrowserDidDisappear:)]) {
                    [self.delegate imageBrowserDidDisappear:self];
                }
            }];
            
            return;
        }
    }
    
    // 执行关闭动画
    [cell animationSlideOutDismissByAnimationBlock:^{
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
        self.pageTextLabel.alpha = 0;
    } completionBlock:^{
        [self removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(imageBrowserDidDisappear:)]) {
            [self.delegate imageBrowserDidDisappear:self];
        }
    }];
}

- (void)cell:(EZImageBrowserCell *)cell scale:(CGFloat)scale {
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1 - scale];
}

@end

