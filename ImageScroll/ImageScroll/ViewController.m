//
//  ViewController.m
//  ImageScroll
//
//  Created by Alan on 16/11/2.
//  Copyright © 2016年 Alan. All rights reserved.
//

#import "ViewController.h"
#import "ImageScrollView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ImageScrollView *imageScrollView = [[ImageScrollView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200) PlaceHoldImage:nil];
    imageScrollView.imageArray = @[@"2",@"3",@"4"];
    [self.view addSubview:imageScrollView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
