//
//  EZImageBrowserCell.h
//  EZImageBrowserExample
//
//  Created by Zhu yangjun on 2017/6/28.
//  Copyright © 2017年 Zhu yangjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZImageBrowserLoading.h"

NS_ASSUME_NONNULL_BEGIN


@class EZImageBrowserCell;
@protocol EZImageBrowserCellDelegate <NSObject>

/**
 contentSize滚动到上下超过边界值后超过scale的回调
 
 @param cell cell对象
 */
- (void)cellTouchOff:(EZImageBrowserCell *)cell;

/**
 contentSize滚动到上下超过边界值的回调
 
 @param cell cell对象
 @param scale 超过的比例
 */
- (void)cell:(EZImageBrowserCell *)cell scale:(CGFloat)scale;

@end

@interface EZImageBrowserCell : UIScrollView
@property (nonatomic, weak, nullable) id<EZImageBrowserCellDelegate> cellDelegate;
/// loading
@property (nonatomic, strong, readonly) EZImageBrowserLoading *loadingView;
/// 当前显示图片的控件
@property (nonatomic, strong, readonly) UIImageView *imageView;
/// 当前视图所在的索引
@property (nonatomic, assign) NSInteger index;
/// 图片的大小
@property (nonatomic, assign) CGSize imageViewSize;
/// default : 0.16
@property (nonatomic, assign) CGFloat maxDropedScale;

/**
 动画显示
 
 @param rect            从哪个位置开始做动画
 @param animationBlock  附带的动画信息
 @param completionBlock 结束的回调
 */
- (void)animationShowWithFromRect:(CGRect)rect animationBlock:(void(^)())animationBlock completionBlock:(void(^)())completionBlock;


/**
 动画消失，回到rect位置
 
 @param rect            回到哪个位置
 @param animationBlock  附带的动画信息
 @param completionBlock 结束的回调
 */
- (void)animationDismissWithToRect:(CGRect)rect animationBlock:(void(^)())animationBlock completionBlock:(void(^)())completionBlock;


/**
 动画消失：扩大&透明
 
 @param animationBlock 附带的动画信息
 @param completionBlock  结束的回调
 */
- (void)animationExpandDismissByAnimationBlock:(void(^)())animationBlock completionBlock:(void(^)())completionBlock;


/**
 动画消失：向上或向下滑出
 
 @param animationBlock 附带的动画信息
 @param completionBlock 结束的回调
 */
- (void)animationSlideOutDismissByAnimationBlock:(void(^)())animationBlock completionBlock:(void(^)())completionBlock;

/**
 放大缩小
 
 @param scale 超过的比例
 @param center 中心位置
 @return 缩放的大小
 */
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;

@end
NS_ASSUME_NONNULL_END
