//
//  ZZFActionSheet.h
//  ZFActionSheet
//
//  Created by Zafir on 16/9/22.
//  Copyright © 2016年 Zafir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZFActionAlert : UIView

//初始化方法
/** 从下往上弹出提示框*/
+ (instancetype)actionSheetWithAlertTitle:(NSString *)alertTitle cancelTitle:(NSString *)cancelTitle subtitles:(NSArray *)titles;
/** 从中间弹出提示框*/
+ (instancetype)actionDefaultStyleWithTitle:(NSString *)alertTitle message:(NSString *)message cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle sureBlock:(void(^)())sureblock;

- (void)show;

/** 提示框每一行的高度*/
@property (nonatomic, assign) int row_Height;

/** 触发的block*/
@property (nonatomic, copy) void(^SheetItemClick)(NSInteger index);
@end
