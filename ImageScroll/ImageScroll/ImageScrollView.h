//
//  ImageScrollView.h
//  fdsdfd
//
//  Created by Alan on 16/10/31.
//  Copyright © 2016年 Alan. All rights reserved.
//

/*****************************   轮播图  *****************************/

#import <UIKit/UIKit.h>

@interface ImageScrollView : UIView

// imageName 是占位图 本地图片
- (instancetype) initWithFrame:(CGRect)frame PlaceHoldImage:(NSString *)imageName;

/// 定时器默认为3秒
@property (nonatomic, assign) NSTimeInterval timeInterval;

///数组内可为UIImage对象  本地图片名  远程图片URL
@property (nonatomic, strong) NSArray *imageArray;

// 点击视图响应  返回此时图片在数组中的index (数组必须赋值有数据)
@property (nonatomic, copy) void(^touchImageBlock)(NSInteger currentImageIndex);

@end
