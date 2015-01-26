//
//  ImageScrollView.m
//  ScrollViewTest
//
//  Created by wangsl-iMac on 14/11/12.
//  Copyright (c) 2014年 chengtz-iMac. All rights reserved.
//

#import "ImageScrollView.h"

@implementation ImageScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//-(id)ImageScrollViewForImage:(UIImage * )image
//{
//    [ImageScrollViewForImage alloc]
//}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.maximumZoomScale = 4.0;
        self.minimumZoomScale = 1.0;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        self.imageView.userInteractionEnabled = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imageView];
        
        // 单击的 Recognizer
        UITapGestureRecognizer* singleRecognizer;
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
        //点击的次数
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [self.imageView addGestureRecognizer:singleRecognizer];
        
        self.delegate = self;
    }
    
    return self;
}

-(void)SingleTap:(UITapGestureRecognizer*)recognizer
{
    //处理单击操作
    NSLog(@"SingleTap %d", recognizer.view.tag);
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


@end
