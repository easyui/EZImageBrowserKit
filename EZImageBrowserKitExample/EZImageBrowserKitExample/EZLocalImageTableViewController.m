//
//  EZImageTableViewController.m
//  EZImageBrowserExample
//
//  Created by Zhu yangjun on 2017/6/28.
//  Copyright © 2017年 Zhu yangjun. All rights reserved.
//

#import "EZLocalImageTableViewController.h"
#import <EZImageBrowserKit/EZImageBrowserKit.h>

#import "EZCustomImageBrowser.h"
#import "EZCustomImageBrowserCell.h"
#import "EZCustomXibImageBrowser.h"
#import "EZCustomXibImageBrowserCell.h"

@interface EZLocalImageTableViewController ()<EZImageBrowserDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *imageUrlStringArray;

@end

@implementation EZLocalImageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:19];
    for (int i  = 1; i <= 19; i++) {
        [arr addObject:[NSString stringWithFormat:@"%d.jpeg",i]];
    }
    self.imageUrlStringArray = [arr copy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.imageUrlStringArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCellIdentifier" forIndexPath:indexPath];
    UIImageView *imageView = [cell viewWithTag:9988];
    imageView.image = [UIImage imageNamed:self.imageUrlStringArray[indexPath.row]];
    return cell;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =   [tableView cellForRowAtIndexPath:indexPath];
    if ([self.type isEqualToString:@"custom"]) {
        EZCustomImageBrowser *browser = [[EZCustomImageBrowser alloc] init];
        browser.pageTextPosition = EZImageBrowserPageTextPositionTop;
        [browser setDelegate:self];
        [browser showFromView:cell currentIndex:indexPath.row completion:nil];
    }else if ([self.type isEqualToString:@"customXib"]) {
        EZCustomXibImageBrowser *browser = [[UINib nibWithNibName:@"EZCustomXibImageBrowser" bundle:nil] instantiateWithOwner:nil options:nil][0];
        
        browser.pageControl.numberOfPages = self.imageUrlStringArray.count;
        browser.pageControl.currentPage = indexPath.row;

        [browser setDelegate:self];
        [browser showFromView:cell currentIndex:indexPath.row completion:nil];
    }else{
    EZImageBrowser *browser = [[EZImageBrowser alloc] init];
    [browser setDelegate:self];
    [browser showFromView:cell currentIndex:indexPath.row completion:nil];
    }
}

#pragma mark - EZImageBrowserDelegate
- (NSInteger)numberOfCellsInImageBrowser:(EZImageBrowser *)imageBrowser{
    return self.imageUrlStringArray.count;
}

- (EZImageBrowserCell *)imageBrowser:(EZImageBrowser *)imageBrowser cellForRowAtIndex:(NSInteger )index{
    if ([self.type isEqualToString:@"custom"]) {
        EZCustomImageBrowserCell *cell = [imageBrowser dequeueReusableCell];
        if (!cell) {
            cell = [[EZCustomImageBrowserCell alloc] init];
        }
        cell.imageView.image =  [UIImage imageNamed:self.imageUrlStringArray[index]];
        return cell;
    }else if ([self.type isEqualToString:@"customXib"]) {
        EZCustomXibImageBrowserCell *cell = [imageBrowser dequeueReusableCell];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"EZCustomXibImageBrowserCell" bundle:nil] instantiateWithOwner:nil options:nil][0];
        }
        cell.imageView.image =  [UIImage imageNamed:self.imageUrlStringArray[index]];
//        cell.loadingView.hidden = NO;
//        [cell.loadingView showError];
        return cell;
    }else{
        EZImageBrowserCell *cell = [imageBrowser dequeueReusableCell];
        if (!cell) {
            cell = [[EZImageBrowserCell alloc] init];
        }
        cell.imageView.image =  [UIImage imageNamed:self.imageUrlStringArray[index]];
        return cell;
    }

}


//不实现这个代理可让图片展示真实大小尺寸
//- (CGSize)imageBrowser:(EZImageBrowser *)imageBrowser  imageViewSizeForItemAtIndex:(NSInteger)index{
//    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
//    return size;
//}

//- (void)imageBrowser:(EZImageBrowser *)imageBrowser didClickCellAtIndex:(NSInteger)index{
//}

//- (void)imageBrowser:(EZImageBrowser *)imageBrowser didDoubleClickCellAtIndex:(NSInteger)index{
//}

- (void)imageBrowser:(EZImageBrowser *)imageBrowser didDisplayingCell:(EZImageBrowserCell *)cell atIndex:(NSInteger)index{
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [[self tableView] scrollToRowAtIndexPath:scrollIndexPath
                            atScrollPosition:UITableViewScrollPositionTop animated:NO];
    NSLog(@"didDisplayingCell index = %ld", (long)index);
    if ([self.type isEqualToString:@"customXib"]) {
        EZCustomXibImageBrowser *customXibImageBrowser = imageBrowser;
        customXibImageBrowser.pageControl.currentPage = index;
    }
}

//- (UIView *)imageBrowser:(EZImageBrowser *)imageBrowser fromViewForItemAtIndex:(NSInteger)index{
//    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
//    UITableViewCell *cell =   [self.tableView cellForRowAtIndexPath:scrollIndexPath];
//    return cell;
//}

@end
