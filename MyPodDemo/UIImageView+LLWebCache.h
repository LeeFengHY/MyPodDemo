//
//  UIImageView+LLWebCache.h
//  LLLaunchAd
//
//  Created by QFWangLP on 2016/11/22.
//  Copyright © 2016年 LeeFengHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLLaunchAdImageDownload.h"

@interface UIImageView (LLWebCache)


/**
 异步加载网络图片/带本地缓存

 @param url 图片url
 */
- (void)ll_setImageWithURL:(NSURL *)url;

/**
 异步加载网络图片/带本地缓存

 @param url         图片url
 @param placeholder 默认占位图
 */
- (void)ll_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

/**
 异步加载网络图片/带本地缓存

 @param url         图片url
 @param placeholder 默认占位图
 @param completed   加载完成回调
 */
- (void)ll_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(LLWebImageCompletionBlock)completed;

/**
 异步加载网络图片/带本地缓存

 @param url         图片url
 @param placeholder 默认占位图
 @param options     缓存机制
 @param completed   加载完成回调
 */
- (void)ll_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(LaunchAdImageOptions)options completed:(LLWebImageCompletionBlock)completed;

@end
