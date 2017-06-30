//
//  EZImageBrowserLoading.h
//  EZImageBrowserExample
//
//  Created by Zhu yangjun on 2017/6/28.
//  Copyright © 2017年 Zhu yangjun. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface EZImageBrowserLoading : UIView
@property (nonatomic, assign) CGFloat progress;

- (void)showError;
- (void)showAnimateByPropress:(CGFloat)progress;
@end
NS_ASSUME_NONNULL_END
