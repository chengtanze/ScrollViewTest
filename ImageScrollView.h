//
//  ImageScrollView.h
//  ScrollViewTest
//
//  Created by wangsl-iMac on 14/11/12.
//  Copyright (c) 2014年 chengtz-iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageScrollView : UIScrollView<UIScrollViewDelegate>

//-(id)ImageScrollViewForImage:(UIImage * )image;


-(id)initWithFrame:(CGRect)frame;

@property(nonatomic, retain) UIImageView * imageView;
@end
