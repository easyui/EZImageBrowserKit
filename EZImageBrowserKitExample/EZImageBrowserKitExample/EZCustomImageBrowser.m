//
//  EZCustomImageBrowser.m
//  EZImageBrowserExample
//
//  Created by Zhu yangjun on 2017/6/29.
//  Copyright © 2017年 Zhu yangjun. All rights reserved.
//

#import "EZCustomImageBrowser.h"

@implementation EZCustomImageBrowser
-(instancetype)init{
    self = [super init];
    if (self) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button setFrame:CGRectMake(0, 0, 60, 60)];
             [button setTitle:@"关闭" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}

- (void)clicked:(id)sender{
    [self dismissCompletion:nil];
}
@end
