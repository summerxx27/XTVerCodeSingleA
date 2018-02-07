//
//  ViewController.m
//  XTVerCode4
//
//  Created by zjwang on 2018/2/7.
//  Copyright © 2018年 summerxx.com. All rights reserved.
//

#import "ViewController.h"
#import "XTVerCodeInput.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    /// 6
    XTVerCodeInput *verView = [[XTVerCodeInput alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 82)];
    verView.inputType = 6;
    [verView initSubviews];
    verView.verCodeBlock = ^(NSString *text){
        NSLog(@"您输入的验证码是%@",text);
    };
    [self.view addSubview:verView];
    /// 4
    XTVerCodeInput *verView4 = [[XTVerCodeInput alloc] initWithFrame:CGRectMake(0, 190, self.view.frame.size.width, 82)];
    verView4.inputType = 4;
    [verView4 initSubviews];
    verView4.verCodeBlock = ^(NSString *text){
        NSLog(@"您输入的验证码是%@",text);
    };
    [self.view addSubview:verView4];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
