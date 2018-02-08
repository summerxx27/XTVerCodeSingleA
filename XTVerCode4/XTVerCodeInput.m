//
//  XTVerCode4.m
//  XTVerCode4
//
//  Created by zjwang on 2018/2/7.
//  Copyright © 2018年 summerxx.com. All rights reserved.
//

#import "XTVerCodeInput.h"
#define WIDTH         [UIScreen mainScreen].bounds.size.width
#define HEIGHT        [UIScreen mainScreen].bounds.size.height
#define K_W 59.5
#define K_H 82
#define PADDING 2
#define XTUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define CHANGETYPE
@interface XTVerCodeInput ()<UITextViewDelegate>
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSMutableArray *lines;
@property (nonatomic, strong) NSMutableArray *labels;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *hlColor;
@property (nonatomic, assign) NSInteger inputT;
@property (nonatomic, assign) CGRect setFrame;

@end

@implementation XTVerCodeInput

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        /// 配置颜色
        _normalColor = XTUIColorFromRGB(0xe7e7e7);
        _hlColor = XTUIColorFromRGB(0x777777);
        _inputT = 4;
        self.setFrame = frame;
    }
    return self;
}
- (void)setInputType:(NSInteger)inputType {
    _inputT = inputType;
}
- (void)initSubviews {
    /// 优先初始化textView
    [self addSubview:self.textView];
    if (_inputT == 4) {
        _textView.frame = CGRectMake((WIDTH - (4 * K_W) - (3 * PADDING)) / 2, 0, (4 * K_W) + (3 * PADDING), self.setFrame.size.height);
    }else {
        _textView.frame = CGRectMake(10, 0, WIDTH - 20, self.setFrame.size.height);
    }
    /// 默认编辑第一个.
    [self beginEdit];
    /// 初始化一个输入框
    /// 初始化四个号码框
    for (int i = 0; i < _inputT; i ++) {
        ///
        UIView *subView = [UIView new];
        float sizeW = (WIDTH - 20 - 5 * PADDING) / 6;
        if (_inputT == 4) {
            float left = (WIDTH - (4 * K_W) - (3 * PADDING)) / 2;
            subView.frame = CGRectMake(left + (K_W + PADDING) * i, 0, K_W, K_H);
        }else if (_inputT == 6){
            float left = 10;
            subView.frame = CGRectMake(left + (sizeW + PADDING) * i, 0, sizeW, K_H);
        }
        subView.userInteractionEnabled = NO;
        [self addSubview:subView];
        /// 4 Label
        UILabel *label = [UILabel new];
        if (_inputType == 4) {
            label.frame = CGRectMake(0, 0, K_W, K_H);
        }else {
            label.frame = CGRectMake(0, 0, sizeW, K_H);
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:38];
        [subView addSubview:label];
        /// 4 光标
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(K_W / 2, 15, 2, K_H - 30)];
        CAShapeLayer *line = [CAShapeLayer layer];
        line.path = path.CGPath;
        line.fillColor =  XTUIColorFromRGB(0xd6d6d6).CGColor;
        [subView.layer addSublayer:line];
        if (i == 0) {
            [line addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
            /// 高亮颜色
            label.backgroundColor = _hlColor;
            line.hidden = NO;
        }else {
            label.backgroundColor = _normalColor;
            line.hidden = YES;
        }
        /// 把光标对象和label对象装进数组
        [self.lines addObject:line];
        [self.labels addObject:label];
    }
}
/// textView Delegate
- (void)textViewDidChange:(UITextView *)textView {
    NSString *verStr = textView.text;
    
    if (verStr.length > _inputT) {
        textView.text = [textView.text substringToIndex:_inputT];
    }
    /// 大于等于4时, 结束编辑
    if (verStr.length >= _inputT) {
        [self endEdit];
    }
    if (self.verCodeBlock) {
        self.verCodeBlock(textView.text);
    }
    for (int i = 0; i < _labels.count; i ++) {
        UILabel *bgLabel = _labels[i];
        
        if (i < verStr.length) {
            [self changeViewLayerIndex:i linesHidden:YES];
            bgLabel.text = [verStr substringWithRange:NSMakeRange(i, 1)];
        }else {
            [self changeViewLayerIndex:i linesHidden:i == verStr.length ? NO : YES];
            /// textView的text为空的时候
            if (!verStr && verStr.length == 0) {
                [self changeViewLayerIndex:0 linesHidden:NO];
            }
            bgLabel.text = @"";
        }
    }
}
/// 光标 和 背景 显示或者隐藏
- (void)changeViewLayerIndex:(NSInteger)index linesHidden:(BOOL)hidden {
    UILabel *label = self.labels[index];
    [UIView animateWithDuration:0.8 animations:^{
        label.backgroundColor = hidden ? _normalColor : _hlColor;
    }];
    CAShapeLayer *line = self.lines[index];
    if (hidden) {
        [line removeAnimationForKey:@"kOpacityAnimation"];
    }else{
        [line addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
    }
    [UIView animateWithDuration:0.25 animations:^{
        line.hidden = hidden;
    }];
}
/// 开始编辑
- (void)beginEdit{
    [self.textView becomeFirstResponder];
}
/// 结束编辑
- (void)endEdit{
    [self.textView resignFirstResponder];
}
/// 闪动动画
- (CABasicAnimation *)opacityAnimation {
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(1.0);
    opacityAnimation.toValue = @(0.0);
    opacityAnimation.duration = 0.9;
    opacityAnimation.repeatCount = HUGE_VALF;
    opacityAnimation.removedOnCompletion = YES;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return opacityAnimation;
}
/// 对象初始化
- (NSMutableArray *)lines {
    if (!_lines) {
        _lines = [NSMutableArray array];
    }
    return _lines;
}
- (NSMutableArray *)labels {
    if (!_labels) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}
- (UITextView *)textView {
    if (!_textView) {
        _textView = [UITextView new];
        _textView.tintColor = [UIColor clearColor];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textColor = [UIColor clearColor];
        _textView.delegate = self;
        _textView.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _textView;
}
@end


