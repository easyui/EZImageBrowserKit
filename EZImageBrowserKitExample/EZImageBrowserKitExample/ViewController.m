//
//  ViewController.m
//  EZImageBrowserKitExample
//
//  Created by IQIYI on 2017/6/30.
//  Copyright © 2017年 Zhu yangjun. All rights reserved.
//

#import "ViewController.h"
#import "EZLocalImageTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"custom"]) {
        EZLocalImageTableViewController *receive = segue.destinationViewController;
        receive.type = @"custom";
    }else if ([segue.identifier isEqualToString:@"customXib"]) {
        EZLocalImageTableViewController *receive = segue.destinationViewController;
        receive.type = @"customXib";
    }
}


@end
