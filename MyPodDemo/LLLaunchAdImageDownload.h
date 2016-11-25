//
//  LLLaunchAdImageDownload.h
//  LLLaunchAd
//
//  Created by QFWangLP on 2016/11/22.
//  Copyright © 2016年 LeeFengHY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, LaunchAdImageOptions){
    /**
     *  有缓存,读取缓存,不重新加载,没缓存先加载,并缓存
     */
    LaunchAdImageDefault       = 1 << 0,
    /**
     *  只加载,不缓存
     */
    LaunchAdImageOnlyLoad      = 1 << 1,
    
    /**
     *  先读缓存,再加载刷新图片和缓存
     */
    LaunchAdImageRefreshCache  = 1 << 2
};

typedef void(^LLWebImageCompletionBlock)(UIImage *image,NSURL *URL);

@interface LLLaunchAdImageDownload : NSObject


/**
 异步下载图片

 @param url       图片url
 @param options   图片缓存机制
 @param completed 下载完成回调
 */
+ (void)ll_downloadWebImageAsyncWithURL:(NSURL *)url options:(LaunchAdImageOptions)options completed:(LLWebImageCompletionBlock)completed;

@end
