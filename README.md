# EZImageBrowserKit
[![Support](https://img.shields.io/badge/support-iOS%208.0%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
<a href="https://img.shields.io/cocoapods/v/EZImageBrowserKit.svg"><img src="https://img.shields.io/cocoapods/v/EZImageBrowserKit.svg"></a>
[![Platform](https://img.shields.io/cocoapods/p/EZImageBrowserKit.svg?style=flat)](http://cocoadocs.org/docsets/EZImageBrowserKit)
![License](https://img.shields.io/cocoapods/l/EZImageBrowserKit.svg?style=flat)

## 预览
![EZImageBrowserKit](EZImageBrowserKit.gif)

## 介绍
一款轻量级的图片浏览器，快速集成，简单易用（类似于UITableView的使用方法）可定制性强。

## 要求
- iOS 8.0+ （源码测试了是支持iOS7的，这里是动态库，所以支持iOS8+了）
- Xcode 8.3.3 (8E3004b)+

## 特性
- 图片复用
- 图片显示/消失的多种动画
- 长按，单击，双击手势
- 图片浏览器和图片cell自定义（支持xib）
- 本地图片和远程图片完全自定义数据源，类似于cellForRowAtIndexPath代理
- 缓存自定义，这样可以使用你系统的一套缓存机制，低侵占性
- 支持长图显示

## 安装 
### ExportFramework
执行项目中的ExportFramework脚本自动生成framework
### [Carthage](https://github.com/Carthage/Carthage) 
1. 创建一个 `Cartfile` ，在这个文件中列出你想使用的 frameworks

   ```ogdl
   github "easyui/EZImageBrowserKit" 
   ```
   
2. 运行 `carthage update` ，获取依赖到 Carthage/Checkouts 文件夹，逐个构建
3. 在工程的 target－> General 选项下，拖拽 Carthage/Build 文件夹内想要添加的 framework 到 “Linked Frameworks and Libraries” 选项下。
   (如果不想拖动这个操作的话，可以设置Xcode自动搜索Framework的目录 Target—>Build Setting—>Framework Search Path—>添加路径＂$(SRCROOT)/Carthage/Build/iOS＂)
4. 在工程的 target－> Build Phases 选项下，点击 “+” 按钮，选择 “New Run Script Phase” ，填入如下内容：

   ```
   /usr/local/bin/carthage copy-frameworks
   ```

   并在 “Input Files” 选项里添加 framework 路径
   
   ```
   $(SRCROOT)/Carthage/Build/iOS/EZImageBrowserKit.framework
   ```

### [CocoaPods](http://cocoapods.org)
1. 创建一个 `Podfile` ，在这个文件中列出你想使用的 frameworks

   ```ruby
   project '<Your Project Name>.xcodeproj'
   platform :ios, '8.0'

   target '<Your Target Name>' do
     use_frameworks!
     pod 'EZImageBrowserKit' 
   end
   ```
   
2. 在 `Podfile` 文件目录下执行

   ```bash
   $ pod install
   ```


## 使用 
- 初始化图片浏览器并且显示

```
  EZImageBrowser *browser = [[EZImageBrowser alloc] init];
    [browser setDelegate:self];
    [browser showWithCurrentIndex:indexPath.row completion:nil];
```

- 图片浏览器支持配置属性

```
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
```

- 图片浏览器支持的代理

```
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
 获取对应cell原空间的回调，dimmiss的时候可以动画返回对应位置
 
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
```

- 复用性

```
- (EZImageBrowserCell *)imageBrowser:(EZImageBrowser *)imageBrowser cellForRowAtIndex:(NSInteger )index{
        EZImageBrowserCell *cell = [imageBrowser dequeueReusableCell];
        if (!cell) {
            cell = [[EZImageBrowserCell alloc] init];
        }
        cell.imageView.image =  [UIImage imageNamed:self.imageUrlStringArray[index]];
        return cell;
}
```

## Todo
- todo

## License
EZImageBrowserKit遵守MIT协议，具体请参考MIT




