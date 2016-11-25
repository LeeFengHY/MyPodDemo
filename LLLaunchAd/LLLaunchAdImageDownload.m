//
//  LLLaunchAdImageDownload.m
//  LLLaunchAd
//
//  Created by QFWangLP on 2016/11/22.
//  Copyright © 2016年 LeeFengHY. All rights reserved.
//

#import "LLLaunchAdImageDownload.h"
#import "UIImage+LLGIF.h"
#import "LLImageCache.h"

@implementation LLLaunchAdImageDownload

+ (void)ll_downloadWebImageAsyncWithURL:(NSURL *)url
                                options:(LaunchAdImageOptions)options
                              completed:(LLWebImageCompletionBlock)completed
{
    if(!options) options = LaunchAdImageDefault;
    if (options&LaunchAdImageOnlyLoad) {
        [self ll_downloadImageWithURL:url completed:completed];
        return;
    }
    
    UIImage *cacheImage = [LLImageCache ll_getCacheImageWithURL:url];
    if (cacheImage && completed) {
        completed(cacheImage,url);
        if (options&LaunchAdImageDefault) return;
    }
    
    [self ll_downloadImageAndCacheWithURL:url completed:completed];

    
}

//不缓存
+ (void)ll_downloadImageWithURL:(NSURL *)url completed:(LLWebImageCompletionBlock)completed
{
    if(url == nil) return;
    __block NSData *imageData = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLSession *dataSession = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [dataSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                imageData = data;
                UIImage *image = [UIImage ll_animatedGIFWithData:imageData];
                completed(image,url);
            });
        }];
        // 启动任务
        [task resume];
    });
}
//缓存+下载
+ (void)ll_downloadImageAndCacheWithURL:(NSURL *)url completed:(LLWebImageCompletionBlock)completed
{
    if (url == nil) return;
    __block NSData *imageData = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLSession *dataSession = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [dataSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                imageData = data;
                UIImage *image = [UIImage ll_animatedGIFWithData:imageData];
                [LLImageCache ll_saveImageData:imageData imageURL:url];
                completed(image,url);
            });
        }];
        // 启动任务
        [task resume];
    });
}
@end
