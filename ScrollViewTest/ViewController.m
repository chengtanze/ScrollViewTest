//
//  ViewController.m
//  ScrollViewTest
//
//  Created by wangsl-iMac on 14/11/11.
//  Copyright (c) 2014年 chengtz-iMac. All rights reserved.
//

#import "ViewController.h"
#import "ImageScrollView.h"




@interface ViewController ()
{
    NSInteger maxPicCount;
    NSInteger currIndex;
    
    float MainScreenWidth;
    float MainScreenHeight;

    CGSize MainScreenSize;
    UIScrollView * scrollview;
    NSMutableArray * picViewArray;
    
    NSMutableArray * imageViewArray;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    MainScreenSize = [UIScreen mainScreen].bounds.size;
    MainScreenWidth = MainScreenSize.width;
    
    
    currIndex = 1;
    
    NSLog(@"MainScreenSize width:%f, height:%f", MainScreenSize.width, MainScreenSize.height);
    scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MainScreenSize.width, MainScreenSize.height)];
    scrollview.backgroundColor = [UIColor grayColor];
    
    picViewArray = [[NSMutableArray alloc] initWithCapacity:5];
    imageViewArray = [[NSMutableArray alloc]initWithCapacity:3];
    
    scrollview.delegate = self;
    //翻页效果
    scrollview.pagingEnabled = YES;
    //是否可以滚动
    //scrollview.scrollEnabled = NO;
    
    //放大，缩小最大最小倍数
    scrollview.maximumZoomScale = 4.0;
    scrollview.minimumZoomScale = 1.0;
    
    //滚动时是否显示水平，垂直滚动条
    //scrollview.showsHorizontalScrollIndicator = NO;
    //scrollview.showsVerticalScrollIndicator = NO;
    
    //超过边界是否有反弹效果
    //scrollview.bounces = NO;
    
    maxPicCount = 7;
    
    for (int nIndex = 0; nIndex < maxPicCount; nIndex++) {
        NSString *str = [NSString stringWithFormat:@"%d.JPG", nIndex + 1];
        UIImage * image = [UIImage imageNamed:str];
       
        [picViewArray addObject:image];
/*
        // 为了实现在scrollview中可以放大缩小图片 不能直接将iamgeview插入scrollview中 而是将一个scrollview封装后插入scrollview
        ImageScrollView * imageSV = [[ImageScrollView alloc]initWithFrame:CGRectMake(40 + MainScreenSize.width * nIndex, 50, 300, 400)];
        
        imageSV.imageView.image = image;
        [scrollview addSubview:imageSV];
*/
   
        
/*
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(40 + MainScreenSize.width * nIndex, 50, 300, 400)];
        imageView.userInteractionEnabled = YES;
        imageView.backgroundColor = [UIColor blackColor];
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag = nIndex;
        
        // 单击的 Recognizer
        UITapGestureRecognizer* singleRecognizer;
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
        //点击的次数
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [imageView addGestureRecognizer:singleRecognizer];
        
        [scrollview addSubview:imageView];
 */
        
    }
    
    //要实现scrollview的滚动需要2个条件：1设置每个子view的坐标 2 设置contentsize
    scrollview.contentSize =  CGSizeMake(MainScreenSize.width * 3, MainScreenSize.height);
   
   
    [self.view addSubview:scrollview];
    
    
    // 实现循环切换图片，创建3个imageview即可。每次翻页的时候清除之前scrollview中的图片，重新加载资源
    [self upDataScrollViewPoint:currIndex];

}

-(void)SingleTap:(UITapGestureRecognizer*)recognizer
{
    //处理单击操作
    NSLog(@"SingleTap %ld", recognizer.view.tag);
}

-(void)upDataScrollViewPoint:(NSInteger)index
{
    [self reLoadItem:index];
    
    CGPoint point = scrollview.contentOffset;
    
    point.x = MainScreenSize.width;
    scrollview.contentOffset = point;
}

-(void)clearPreItem
{
    NSArray * subViews = [scrollview subviews];
    if (subViews.count != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        NSLog(@"scroll view subviews :%ld", subViews.count);
    }
}

-(void)reLoadItem:(NSInteger)index
{
    
    // 清除之前的数据
    [self clearPreItem];
    
    NSInteger cur = [self adjustCurrentIndex:index];
    NSInteger pre = [self adjustCurrentIndex:cur - 1];
    NSInteger next = [self adjustCurrentIndex:cur + 1];
    
    NSInteger count[3] = {pre, cur, next};
    
    NSLog(@"reLoadItem pre:%ld, cur:%ld, next:%ld", pre, cur, next);
    
    for (int nIndex = 0; nIndex < 3; nIndex++) {
        UIImage * image = picViewArray[count[nIndex]];
        
        
        //CGRect rect = CGRectOffset(self.view.bounds, MainScreenSize.width * nIndex, 0);
        
        CGRect rect = CGRectMake(MainScreenSize.width * nIndex, 0, 300, 400);
        
        NSLog(@"reLoadItem View%d point.x = %f", nIndex, MainScreenSize.width * nIndex);
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:rect];
        
        imageView.userInteractionEnabled = YES;
        imageView.backgroundColor = [UIColor blackColor];
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = nIndex;
        [imageViewArray addObject:imageView];
        
        [scrollview addSubview:imageView];
        
        
    }
    
    NSLog(@"scrollview subview count:%ld",scrollview.subviews.count);
}


-(NSInteger)adjustCurrentIndex:(NSInteger)index
{
    NSInteger adjustIndex = index;
    if (index >= maxPicCount) {
        adjustIndex = 0;
    }
    else if(index < 0)
    {
        adjustIndex = maxPicCount - 1;
    }
    
    currIndex = adjustIndex;
    
    NSLog(@"adjustCurrentIndex %ld", currIndex);
    return adjustIndex;
}

//scrollview已经滑动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger x = scrollview.contentOffset.x;
    
    if (x >= MainScreenWidth * 2) {
        
        NSLog(@"scrollViewDidScroll");
        [self upDataScrollViewPoint:currIndex];
    }
    
    //NSLog(@"scrollViewDidScroll");
}

//开始拖动
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewWillBeginDragging");
}

//结束拖动
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //NSLog(@"scrollViewDidEndDragging");
}

// 开始减速
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewWillBeginDecelerating");
}

//减速停止
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    NSLog(@"scrollViewDidEndDecelerating");
    
    NSLog(@"scroll Fream x:%f, y:%f", scrollview.contentOffset.x, scrollview.contentOffset.y);

//
//    if (scrollview.contentOffset.x == MainScreenSize.width * 3) {
//        NSLog(@"Last");
//        [UIView animateWithDuration:0.5 animations:^{
//            CGPoint point = scrollview.contentOffset;
//            point.x = 0.0;
//            scrollview.contentOffset = point;
//        } completion:^(BOOL finished) {
//            
//        }];
//    }
    
}


//-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
//{
//    int nIndex = (int)scrollview.contentOffset.x / MainScreenSize.width;
//    NSLog(@"viewForZoomingInScrollView %d", nIndex);
//    UIImageView * imageview = picViewArray[nIndex];
//    return (UIView *)imageview;
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
