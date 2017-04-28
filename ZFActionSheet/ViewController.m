//
//  ViewController.m
//  ZFActionSheet
//
//  Created by Zafir on 16/9/22.
//  Copyright © 2016年 Zafir. All rights reserved.
//

#import "ViewController.h"
#import "ZZFActionAlert.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [[UIView alloc]initWithFrame:self.view.bounds];
    
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    [self.view addSubview:view];
    
    [self setupView];
    
    
}

- (void)setupView {
    UIButton * button1 = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 30)];
    CGPoint center = button1.center;
    center.x = self.view.center.x;
    button1.center = center;
    [button1 setTitle:@"alertSheet" forState:(UIControlStateNormal)];
    [button1 setBackgroundColor:[UIColor darkGrayColor]];
    [button1 addTarget:self action:@selector(ShowSheet) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(100, 300,100, 30)];
    CGPoint center2 = button2.center;
    center2.x = self.view.center.x;
    button2.center = center2;
    [button2 setTitle:@"alert" forState:(UIControlStateNormal)];
    [button2 setBackgroundColor:[UIColor darkGrayColor]];
    [button2 addTarget:self action:@selector(ShowAlert) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:button2];

}

- (void)ShowSheet {
    ZZFActionAlert *actionSheet = [ZZFActionAlert actionSheetWithAlertTitle:@"请选择" cancelTitle:@"取消" subtitles:@[@"选择图片",@"照相",@"哈哈",@"嗯嗯"]];
    [actionSheet setSheetItemClick:^(NSInteger index) {
        switch (index) {
            case 0:
                 NSLog(@"选择图片");
                break;
            case 1:
                NSLog(@"照相");
                break;
            case 2:
                NSLog(@"哈哈");
                break;
            case 3:
                NSLog(@"嗯嗯");
                break;
            default:
                break;
        }
        
    }];
    [actionSheet show];
}

- (void)ShowAlert {
    ZZFActionAlert *action = [ZZFActionAlert actionDefaultStyleWithTitle:@"提示" message:@"学习使我感到快乐..." cancelTitle:@"取消" sureTitle:@"确定" sureBlock:^{
        
         NSLog(@"222");
    }];
    
    [action show];
}

@end
