//
//  EZRemoteImageTableViewController.m
//  EZImageBrowserExample
//
//  Created by Zhu yangjun on 2017/6/28.
//  Copyright © 2017年 Zhu yangjun. All rights reserved.
//

#import "EZRemoteImageTableViewController.h"
#import <EZImageBrowserKit/EZImageBrowserKit.h>

#import "UIImageView+WebCache.h"

@interface EZRemoteImageTableViewController ()<EZImageBrowserDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *imageUrlStringArray;

@end

@implementation EZRemoteImageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.imageUrlStringArray = @[@"http://img4.duitang.com/uploads/item/201210/15/20121015100554_X4xBV.jpeg",
                                 @"http://pic15.nipic.com/20110630/6322714_105943746342_2.jpg",
                                 @"http://wenwen.soso.com/p/20110718/20110718210301-2022177829.jpg",
                                 @"http://img1.2345.com/duoteimg/qqTxImg/2/3fe0dde3d40afd23c0c83258be8c6a4a.jpg",
                                 @"http://file.popoho.com/2016-04-06/0f4205d9a9e971f87ca5ee86172b4eb0.jpg",
                                 @"http://img4.duitang.com/uploads/item/201306/25/20130625154432_yEedM.jpeg",
                                 @"http://www.szbridal.com/pic/qdhc_f.jpg",
                                 @"http://www.qq745.com/uploads/allimg/150104/1-150104153429-50.jpg",
                                 @"http://cdnq.duitang.com/uploads/item/201504/15/20150415H0546_YGatC.thumb.224_0.jpeg",
                                 @"http://www.fuhaodq.com/d/file/201706/16/2uucyj1vlhyvjjr2779.jpg",
                                 @"http://k2.jsqq.net/uploads/allimg/1705/7_170524143440_5.jpg",
                                 @"http://www.bz55.com/uploads/allimg/150616/139-150616141150-50.jpg",
                                 @"http://gexing.edujq.com/img/2013/04/25/201304250954541566.jpg",
                                 @"http://www.yesky.com/uploadImages/2015/204/39/9A79NJCBUZ4V.jpg",
                                 @"http://image.fvideo.cn/uploadfile/2015/05/28/img36122439811247.jpg",
                                 @"http://image.tianjimedia.com/uploadImages/2015/285/24/586K2UOWHG9D.jpg",
                                 @"http://pic19.nipic.com/20120218/2062411_135331254146_2.jpg"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clearCache)];

}

- (void)clearCache {
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
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
    [imageView sd_setImageWithURL:[[NSURL alloc] initWithString:self.imageUrlStringArray[indexPath.row]] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    return cell;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =   [tableView cellForRowAtIndexPath:indexPath];
    EZImageBrowser *browser = [[EZImageBrowser alloc] init];
    [browser setDelegate:self];
    [browser showFromView:cell currentIndex:indexPath.row  completion:nil];
    
}

#pragma mark - EZImageBrowserDelegate
- (NSInteger)numberOfCellsInImageBrowser:(EZImageBrowser *)imageBrowser{
    return self.imageUrlStringArray.count;
}

- (EZImageBrowserCell *)imageBrowser:(EZImageBrowser *)imageBrowser cellForRowAtIndex:(NSInteger )index{
    EZImageBrowserCell *cell = [imageBrowser dequeueReusableCell];
    if (!cell) {
        cell = [[EZImageBrowserCell alloc] init];
    }
    cell.loadingView.hidden = YES ;
    [cell.imageView sd_setImageWithURL:[[NSURL alloc] initWithString:self.imageUrlStringArray[index]] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        CGFloat progress = (CGFloat)receivedSize / expectedSize ;
        [cell.loadingView showAnimateByPropress:progress];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cell.loadingView.hidden = YES ;
//        cell.imageViewSize = image.size;//可以显示图片大小
    }];
    return cell;
}

- (CGSize)imageBrowser:(EZImageBrowser *)imageBrowser  imageViewSizeForItemAtIndex:(NSInteger)index{
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
    return size;
}

- (void)imageBrowser:(EZImageBrowser *)imageBrowser didDisplayingCell:(EZImageBrowserCell *)cell atIndex:(NSInteger)index{
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [[self tableView] scrollToRowAtIndexPath:scrollIndexPath
                            atScrollPosition:UITableViewScrollPositionTop animated:NO];
    NSLog(@"didDisplayingCell index = %ld", (long)index);
}

- (UIView *)imageBrowser:(EZImageBrowser *)imageBrowser fromViewForItemAtIndex:(NSInteger)index{
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell =   [self.tableView cellForRowAtIndexPath:scrollIndexPath];
    return cell;
}

@end

