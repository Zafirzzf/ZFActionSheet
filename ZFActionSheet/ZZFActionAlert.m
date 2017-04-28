//
//  ZZFActionSheet.m
//  ZFActionSheet
//
//  Created by Zafir on 16/9/22.
//  Copyright © 2016年 Zafir. All rights reserved.
//

#import "ZZFActionAlert.h"
#define WIDTH_SCREEN [UIScreen mainScreen].bounds.size.width
#define HEIGHT_SCREEN [UIScreen mainScreen].bounds.size.height


@interface ZZFActionAlert() {
    int _sheetheight;
    int _rowHeight;
    int _sheetW ; //alert宽度
}
/** 提示框标题*/
@property (nonatomic, copy) NSString * alertTitle;
/** 取消文字*/
@property (nonatomic, copy) NSString * cancelTitle;
/** 提示信息*/
@property (nonatomic, copy) NSString * message;
/** 菜单文字*/
@property (nonatomic, strong) NSArray * subtitles;
/** 确认文字*/
@property (nonatomic, copy) NSString * sureTitle;
/** 弹出视图*/
@property (nonatomic, strong) UIView * sheetView;
/** titleLabel*/
@property (nonatomic, strong) UILabel * titleLabel;
/** messageLabel*/
@property (nonatomic, strong) UILabel * messageLabel;
/** 毛玻璃视图*/
@property (nonatomic, strong) UIVisualEffectView * blurView;
/** alert的确认block*/
@property (nonatomic, copy) void(^sureBlock) ();
/** sheet行高*/
@property (nonatomic, assign) int rowH;

/** 弹出方式 0是sheet 1是alert*/
@property (nonatomic, assign) BOOL style;


@end

@implementation ZZFActionAlert

+ (instancetype)actionSheetWithAlertTitle:(NSString *)alertTitle cancelTitle:(NSString *)cancelTitle subtitles:(NSArray *)titles {
    
    return [[self alloc]initWithTitle:alertTitle CancelTitle:cancelTitle sub:titles];
    
}

+ (instancetype)actionDefaultStyleWithTitle:(NSString *)alertTitle message:(NSString *)message cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle sureBlock:(void(^)())sureblock{
    
    return [[self alloc]initWithTitle:alertTitle message:message cancelTitle:cancelTitle sureTitle:sureTitle sureBlock:sureblock];
}

- (instancetype)initWithTitle:(NSString *)title CancelTitle:(NSString *)cancelTitle sub:(NSArray *)subTitles  {
    if (self = [super init]) {
        _alertTitle = title;
        _cancelTitle = cancelTitle;
        _subtitles = subTitles;
        _style = 0;
        self.frame = CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN);
        [self setupSheetStyle];
        
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle sureBlock:(void(^)())sureblock {
    if (self = [super init]) {
        _alertTitle = title;
        _message = message;
        _cancelTitle = cancelTitle;
        _sureTitle = sureTitle;
        _sureBlock = sureblock;
        _style = 1;
        self.frame = CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN);
        [self setupDefaultStyle];
    }
    return self;
}
//底部弹出
- (void)setupSheetStyle {
    
    _rowH = self.row_Height?_row_Height:50;
    //有标题的时候
    if (_alertTitle) {
        [self.sheetView addSubview:self.titleLabel];
        _sheetheight += _rowH;
    }
    //添加菜单内容
    for (NSInteger i = 0; i <_subtitles.count + 1; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, _alertTitle?_rowH+_rowH*i:_rowH*i, WIDTH_SCREEN, _rowH-1)];
        
        if (i == _subtitles.count) {
            button.frame = CGRectMake(0, _alertTitle? _rowH +_rowH*i+3:_rowH*i +3, WIDTH_SCREEN, _rowH-0.5);
            
            [button setTitle:_cancelTitle forState:(UIControlStateNormal)];
        }else {
            [button setTitle:_subtitles[i] forState:(UIControlStateNormal)];
            
        }
        [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        button.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.tag = 10+i;
        button.layer.cornerRadius = 8;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(alertItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.sheetView addSubview:button];
    }
    _sheetheight += (_subtitles.count +1) *_rowH +3;
    [self addSubview:_sheetView];
    
}
//中间弹出
- (void)setupDefaultStyle {
    [self addSubview:self.blurView];
    _sheetW = 0.8 *[UIScreen mainScreen].bounds.size.width;
    //提示标题
    if (_alertTitle) {
        
        _sheetheight += CGRectGetHeight(self.titleLabel.frame);
        [self.sheetView addSubview:self.titleLabel];
    }
    //message
    CGFloat MsgH = [_message boundingRectWithSize:CGSizeMake(_sheetW-10, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    self.messageLabel.frame = CGRectMake(5, _alertTitle?40:0, _sheetW-10, MsgH+10);
    
    [_sheetView addSubview:self.messageLabel];
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(self.messageLabel.frame)+5, _sheetW-20, 1)];
    lineLabel.backgroundColor = [UIColor colorWithRed:96/255.0 green:96/255.0 blue:96/255.0 alpha:0.2];
    [_sheetView addSubview:lineLabel];
    _sheetheight += MsgH+10;
    if (!_sureTitle||_sureTitle.length==0) {
        UILabel * cancelLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _sheetheight+5, _sheetW, 40)];
        cancelLabel.text = _cancelTitle;
        cancelLabel.font = [UIFont boldSystemFontOfSize:14];
        cancelLabel.textAlignment = NSTextAlignmentCenter;
        [_sheetView addSubview:cancelLabel];
        _sheetheight += 40;
    }else{
        UIButton * cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, _sheetheight+5 , _sheetW *0.5, 40)];
        [cancelBtn setTitle:_cancelTitle forState:(UIControlStateNormal)];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:(UIControlEventTouchUpInside)];
        [_sheetView addSubview:cancelBtn];
        UIButton *subBtn = [[UIButton alloc]initWithFrame:CGRectMake(_sheetW *0.5, _sheetheight+5 , _sheetW * 0.5, 40)];
        [subBtn setTitle:_sureTitle forState:(UIControlStateNormal)];
        [subBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        subBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        subBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [subBtn addTarget:self action:@selector(sureclick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_sheetView addSubview:subBtn];
        _sheetheight += 45;
    }
    _sheetView.frame =  CGRectMake(100, 100, WIDTH_SCREEN * 0.8, _sheetheight);
    _sheetView.layer.cornerRadius = 10;
    [self addSubview:_sheetView];
}
- (void)cancelClick {
    [self dismiss];
}

- (void)sureclick:(UIButton *)btn {
    self.sureBlock();
    [self dismiss];
}
- (void)alertItemClick:(UIButton *)btn {
    if (_SheetItemClick) {
        self.SheetItemClick(btn.tag - 10);
    }
    
    [self dismiss];
    
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    if (_style) {
        [self alertShow];
    }else {
        [self actionSheetShow];
    }
    
}
//中间弹出框的动画
- (void)alertShow {
    _sheetView.center = self.center;
    _messageLabel.alpha = 0.2;
    _titleLabel.alpha = 0.2;
    _blurView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    _sheetView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.12 animations:^{
        
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        _messageLabel.alpha = 0.5;
        _titleLabel.alpha = 0.5;
        _sheetView.transform = CGAffineTransformMakeScale(1.1,1.1);
        
        
    } completion:^(BOOL finished) {
        _blurView.transform = CGAffineTransformMakeScale(1, 1);
        [UIView animateWithDuration:0.1 animations:^{
            _messageLabel.alpha = 1;
            _titleLabel.alpha = 1;
            _sheetView.transform = CGAffineTransformMakeScale(1, 1);
        }];
        
    }];
}
//底部弹出框的动画
- (void)actionSheetShow {
    self.sheetView.frame = CGRectMake(0, HEIGHT_SCREEN, WIDTH_SCREEN, _sheetheight);
    
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        _sheetView.transform = CGAffineTransformMakeTranslation(0, -_sheetView.frame.size.height-10);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            _sheetView.transform = CGAffineTransformMakeTranslation(0, -_sheetView.frame.size.height);
        }];
    }];
    
}
- (void)dismiss {
    if (_style) {
        [UIView animateWithDuration:0.08 animations:^{
            _sheetView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                _sheetView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            } completion:^(BOOL finished) {
                if (finished) {
                    [self removeFromSuperview];
                }
            }];
        }];
    }else {
        
        [UIView animateWithDuration:0.22 animations:^{
            self.alpha = 0;
            _sheetView.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            if (finished) {
                [self removeFromSuperview];
            }
        }];
    }
    
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        if (_style) {
            _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _sheetW, 40)];
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.text = _alertTitle;
            
        }else {
            _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, _rowH-1)];
            _titleLabel.textColor = [UIColor darkGrayColor];
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
            _titleLabel.text = _alertTitle;
            _titleLabel.layer.cornerRadius = 8;
            _titleLabel.layer.masksToBounds = YES;
        }
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc]init];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont systemFontOfSize:14];
        _messageLabel.numberOfLines = 0;
        _messageLabel.text =_message;
    }
    return _messageLabel;
}

- (UIView *)sheetView {
    if (!_sheetView) {
        _sheetView = [[UIView alloc]init];
        if (_style) { //中间弹出
            
            _sheetView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
            _sheetView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
            _sheetView.layer.shadowOffset = CGSizeMake(1, 3);
            _sheetView.layer.shadowOpacity = 0.3;
            _sheetView.layer.shadowRadius = 8;
            _sheetView.layer.cornerRadius = 20;
            
        }else { //底部弹出
            _sheetView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
        }
    }
    return _sheetView;
    
}

- (UIView *)blurView {
    if (!_blurView) {
        //blur效果
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _blurView = [[UIVisualEffectView alloc]initWithEffect:effect];
        _blurView.frame = self.bounds;
    }
    return _blurView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}

@end
