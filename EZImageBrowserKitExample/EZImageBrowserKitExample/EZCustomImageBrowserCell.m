//
//  EZCustomImageBrowserCell.m
//  EZImageBrowserExample
//
//  Created by Zhu yangjun on 2017/6/29.
//  Copyright © 2017年 Zhu yangjun. All rights reserved.
//

#import "EZCustomImageBrowserCell.h"

@implementation EZCustomImageBrowserCell

-(instancetype)init{
    self = [super init];
    if (self) {
        self.imageView.layer.cornerRadius = [UIScreen mainScreen].bounds.size.width;
    }
    return self;
}

@end
