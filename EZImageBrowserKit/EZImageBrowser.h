//
//  EZImageBrowser.h
//  EZImageBrowserExample
//
//  Created by Zhu yangjun on 2017/6/28.
//  Copyright © 2017年 Zhu yangjun. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 page text 位置
 
 - EZImageBrowserPageTextPositionTop: 上边 x = center，y = to top 20
 - EZImageBrowserPageTextPositionBottom: 下边 x = center，y = to bottm 20
 */
typedef NS_ENUM(NSInteger, EZImageBrowserPageTextPosition) {
    EZImageBrowserPageTextPositionTop = 0,
    EZImageBrowserPageTextPositionBottom,
};

@class EZImageBrowser;
@class EZImageBrowserCell;
@protocol EZImageBrowserDelegate <NSObject>

@required
/**
 每个cell的回调
 
 @param imageBrowser 图片浏览器
 @param index 当前cell索引
 @return 返回cell，不能为nil，nil会crash
 */
- (EZImageBrowserCell *)imageBrowser:(EZImageBrowser *)imageBrowser cellForRowAtIndex:(NSInteger )index;

/**
 cell总数的回调
 
 @param imageBrowser 图片浏览器
 @return cell总数
 */
- (NSInteger)numberOfCellsInImageBrowser:(EZImageBrowser *)imageBrowser;

@optional
/**
 cell中图片默认大小的回调，不实现这个代理，会使用image的大小
 
 @param imageBrowser 图片浏览器
 @param index 当前cell索引
 @return cell中图片大小
 */
- (CGSize)imageBrowser:(EZImageBrowser *)imageBrowser  imageViewSizeForItemAtIndex:(NSInteger)index;

/**
 显示cell后的回调
 
 @param imageBrowser 图片浏览器
 @param cell 当前cell
 @param index 当前cell索引
 */
- (void)imageBrowser:(EZImageBrowser *)imageBrowser didDisplayingCell:(EZImageBrowserCell *)cell atIndex:(NSInteger)index;

/**
 获取对应cell原空间的回调，显示的时候，如果返回非空就从原空间动画显示，否则从中间显示出来；dimmiss的时候如果返回非空则可以返回原空间位置，为空的话则变大消失，上下滑出的话就继续滑动消失
 
 @param imageBrowser 图片浏览器
 @param index 当前cell索引
 @return 对应cell原控件
 */
- (nullable UIView *)imageBrowser:(EZImageBrowser *)imageBrowser fromViewForItemAtIndex:(NSInteger)index;

/**
 获取page text的文本的回调，实现此代理可自定义
 
 @param imageBrowser 图片浏览器
 @param index 当前cell索引
 @param count cell总数
 @return page text 自定义文本
 */
- (NSString *)imageBrowser:(EZImageBrowser *)imageBrowser  pageTextForItemAtIndex:(NSInteger)index count:(NSInteger)count;

/**
 长按事件触发回掉，必须supportLongPress = YES来启动
 
 @param imageBrowser 图片浏览器
 @param index 当前cell索引
 */
- (void)imageBrowser:(EZImageBrowser *)imageBrowser didLongPressCellAtIndex:(NSInteger)index;

/**
 单机事件触发，实现后默认dismiss不起作用
 
 @param imageBrowser 图片浏览器
 @param index 当前cell索引
 */
- (void)imageBrowser:(EZImageBrowser *)imageBrowser didClickCellAtIndex:(NSInteger)index;

/**
 双击事件触发，实现后默认双击放大不起作用
 
 
 @param imageBrowser 图片浏览器
 @param index 当前cell索引
 */
- (void)imageBrowser:(EZImageBrowser *)imageBrowser didDoubleClickCellAtIndex:(NSInteger)index;

/**
 图片浏览器将显示的回调
 
 @param imageBrowser 图片浏览器
 */
- (void)imageBrowserWillAppear:(EZImageBrowser *)imageBrowser;

/**
 图片浏览器已显示的回调
 
 @param imageBrowser 图片浏览器
 */
- (void)imageBrowserDidAppear:(EZImageBrowser *)imageBrowser;

/**
 图片浏览器将消失的回调
 
 @param imageBrowser 图片浏览器
 */
- (void)imageBrowserWillDisappear:(EZImageBrowser *)imageBrowser;

/**
 图片浏览器已消失的回调
 
 @param imageBrowser 图片浏览器
 */
- (void)imageBrowserDidDisappear:(EZImageBrowser *)imageBrowser;


@end

@interface EZImageBrowser : UIView

@property (nonatomic, weak, nullable) id<EZImageBrowserDelegate> delegate;

///cell的左右边距 default： 20
@property (nonatomic, assign) CGFloat cellMarginForLandscape;

/**
 cneter default：x = center，y = to bottm 20 （EZImageBrowserPageTextPositionBottom）
 fonr  default: [UIFont systemFontOfSize:16]
 text color: default：white
 */
@property (nonatomic, strong, readonly) UILabel *pageTextLabel;

//default: EZImageBrowserPageTextPositionBottom
@property (nonatomic, assign) EZImageBrowserPageTextPosition pageTextPosition;

/// default： NO
@property (nonatomic, assign) BOOL supportLongPress;

/**
 显示图片浏览器，显示前，必须先设置delegate，否则crash
 
 @param fromView     clicked view
 @param currentIndex current cell index
 */
- (void)showFromView:(UIView *)fromView currentIndex:(NSInteger)currentIndex completion:(void (^ __nullable)(void))completion;


/**
 关闭图片浏览器
 
 @param completion block
 */
- (void)dismissCompletion: (void (^ __nullable)(void))completion;


/**
 获取cell，重用池中有可以获取到，没有返回nil
 
 @return 重用的cell或nil
 */
- (nullable __kindof EZImageBrowserCell *)dequeueReusableCell;

@end
NS_ASSUME_NONNULL_END
