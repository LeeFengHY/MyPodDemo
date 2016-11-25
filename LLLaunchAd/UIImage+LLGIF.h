//
//  UIImage+LLGIF.h
//  LLLaunchAd
//
//  Created by QFWangLP on 2016/11/22.
//  Copyright © 2016年 LeeFengHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LLGIF)

/**
 web请求回来的image data 生成静态或者动态图

 @param data web image data

 @return image
 */
+ (UIImage *)ll_animatedGIFWithData:(NSData *)data;

@end
