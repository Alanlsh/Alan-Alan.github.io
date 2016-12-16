//
//  ImageScrollView.m
//  fdsdfd
//
//  Created by Alan on 16/10/31.
//  Copyright © 2016年 Alan. All rights reserved.
//

#define KViewWidth    self.frame.size.width
#define KViewHeight   self.frame.size.height

#import "ImageScrollView.h"

@interface ImageScrollView ()<UIScrollViewDelegate>



@property (nonatomic, copy)   NSString *placeHoldImageNamel; ///占位图
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger index;  // 当前显示图片index


@end

@implementation ImageScrollView

- (instancetype) initWithFrame:(CGRect)frame PlaceHoldImage:(NSString *)imageName
{
    if (self = [super initWithFrame:frame]) {
        self.placeHoldImageNamel = imageName;
        [self addSubview:self.scrollView];
    }
    return self;

}

#pragma mark - 定时器滚动视图   向左滑动
- (void)leftRoll:(id)sender
{
    self.index += 1;
    
    if (self.index > self.imageArray.count - 1) {
        self.index = 0;
    }
    

    [UIView animateWithDuration:0.7 animations:^{
        [self.scrollView setContentOffset:CGPointMake(2 * KViewWidth, 0)];
    } completion:^(BOOL finished) {
        
        UIImageView *imageView3 = [self.scrollView viewWithTag:3];
        imageView3.frame = CGRectMake(KViewWidth, 0, KViewWidth, KViewHeight);
        [self.scrollView setContentOffset:CGPointMake(KViewWidth, 0)];
        
        UIImageView *imageView2 = [self.scrollView viewWithTag:2];
        imageView2.frame = CGRectMake(KViewWidth * 2, 0, KViewWidth, KViewHeight);
        
        UIImageView *imageView1 = [self.scrollView viewWithTag:1];
        
        NSInteger leftIndex = self.index - 1;
        NSInteger rightIndex = self.index + 1;
        
        
        if (leftIndex < 0) {
            leftIndex = self.imageArray.count - 1;
        }
        if (rightIndex > self.imageArray.count - 1) {
            rightIndex = 0;
        }

        
        [self loadImage:leftIndex withImageView:imageView1];
        [self loadImage:rightIndex withImageView:imageView2];
        
        imageView3.tag = 2;
        imageView2.tag = 3;
        
        
    }];
}

#pragma mark -  右滑
- (void)rightRoll:(id)sender
{
    self.index -= 1;
    
    if (self.index < 0) {
        self.index = self.imageArray.count - 1;
    }
    
        UIImageView *imageView1 = [self.scrollView viewWithTag:1];
        imageView1.frame = CGRectMake(KViewWidth, 0, KViewWidth, KViewHeight);
        [self.scrollView setContentOffset:CGPointMake(KViewWidth, 0)];
        
        UIImageView *imageView2 = [self.scrollView viewWithTag:2];
        imageView2.frame = CGRectMake(0, 0, KViewWidth, KViewHeight);
    
        UIImageView *imageView3 = [self.scrollView viewWithTag:3];
    
    NSInteger leftIndex = self.index - 1;
    NSInteger rightIndex = self.index + 1;
    
    
    if (leftIndex < 0) {
        leftIndex = self.imageArray.count - 1;
    }
    if (rightIndex > self.imageArray.count - 1) {
        rightIndex = 0;
    }

    
    [self loadImage:leftIndex withImageView:imageView2];
    [self loadImage:rightIndex withImageView:imageView3];
        
        imageView1.tag = 2;
        imageView2.tag = 1;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    CGFloat contentOffsetX = scrollView.contentOffset.x;
    if (contentOffsetX < KViewWidth) {
        
        [self rightRoll:nil];
        
        [self.timer setFireDate:[NSDate dateWithTimeInterval:3 sinceDate:[NSDate date]]];
        
    }else if (contentOffsetX > KViewWidth){
    
        [self leftRoll:nil];
        
         [self.timer setFireDate:[NSDate dateWithTimeInterval:3 sinceDate:[NSDate date]]];
        
        
    }

}

#pragma mark - 加载数组中图片
- (void)loadImage:(NSInteger)imageIndex withImageView:(UIImageView *)imageView
{
    id obj = self.imageArray[imageIndex];
    if ([obj isKindOfClass:[UIImage class]]) { // UIImage对象
        imageView.image = obj;
    } else if ([obj isKindOfClass:[NSString class]]) { // 本地图片名
        imageView.image = [UIImage imageNamed:obj];
    } else if ([obj isKindOfClass:[NSURL class]]) { // 远程图片URL
        
        imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:obj]];
//        [imageView sd_setImageWithURL:obj placeholderImage:nil];
    }
}

#pragma mark - initializing
-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KViewWidth, KViewHeight)];
        _scrollView.contentSize = _scrollView.frame.size;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KViewWidth, KViewHeight)];
        imageView.tag = 2 ;
        
        if (self.placeHoldImageNamel.length != 0) {
            imageView.image = [UIImage imageNamed:self.placeHoldImageNamel];
        }
        
        [self.scrollView addSubview:imageView];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_scrollView addGestureRecognizer:tap];
        
    }
    
    return _scrollView;
}

- (void)tap:(id)sender
{
    if (self.imageArray > 0) {
        if (self.touchImageBlock) {
            self.touchImageBlock(self.index);
        }
    }
    
}

/**
 *  设置图片数据才打开定时器 图片数量超过2张
 *
 */
// 设置轮播图片数组
- (void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;
    
    // 多张图片
    if (imageArray.count > 1) {
        
        for (UIView *imageView in self.scrollView.subviews) {
            [imageView removeFromSuperview];
        }
        
        self.scrollView.contentSize = CGSizeMake(KViewWidth * imageArray.count, KViewHeight);
        for (NSInteger i = 0; i < 3; i ++ ) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(KViewWidth * i, 0, KViewWidth, KViewHeight)];
            imageView.tag = i + 1;
            
            switch (i) {
                case 0:
                    [self loadImage:self.imageArray.count - 1 withImageView:imageView];
                    break;
                case 1:
                    [self loadImage:0 withImageView:imageView];
                    break;
                case 2:
                    [self loadImage:1 withImageView:imageView];
                    break;
                default:
                    break;
                    
            }
            
            [self.scrollView setContentOffset:CGPointMake(KViewWidth, 0)];
            [self.scrollView addSubview:imageView];
            
        }
        
        // 设置初始图片为数组第一个
        self.index = 0;
        
        //已设置数组且数组数量满足打开定时器开启条件  （定时器打开条件必须满足数组内图片数须大于1）
        [self.timer setFireDate:[NSDate dateWithTimeInterval:self.timeInterval sinceDate:[NSDate date]]];
        
        
    }else if(imageArray.count == 1){   // 一张图片
    
        UIImageView *imageView = [self. scrollView viewWithTag:2];
        imageView.image = [UIImage imageNamed:imageArray[0]];
        
    }
}

// 定时器
- (NSTimer *)timer
{
    if (!_timer) {
        
        if (self.timeInterval <= 0) {
            _timeInterval = 3;   //默认3s
        }
        _timer = [[NSTimer alloc] initWithFireDate:[NSDate distantFuture] interval:self.timeInterval target:self selector:@selector(leftRoll:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

// 会重置定时器
- (void)setTimeInterval:(NSTimeInterval)timeInterval
{
    _timeInterval = timeInterval;
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    //设置时间需要更换定时器 此时图片数组已经赋值 可以打开
    if (self.imageArray.count > 1) {
        [self.timer setFireDate:[NSDate dateWithTimeInterval:timeInterval sinceDate:[NSDate date]]];
    }
}

@end
