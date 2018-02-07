//
//  XTVerCode4.h
//  XTVerCode4
//
//  Created by zjwang on 2018/2/7.
//  Copyright © 2018年 summerxx.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^XTVerCodeBlock)(NSString *text);
@interface XTVerCodeInput : UIView
@property (nonatomic, copy) XTVerCodeBlock verCodeBlock;
@property (nonatomic, assign) NSInteger inputType;
- (void)initSubviews;
@end
