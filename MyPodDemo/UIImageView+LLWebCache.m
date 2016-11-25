//
//  UIImageView+LLWebCache.m
//  LLLaunchAd
//
//  Created by QFWangLP on 2016/11/22.
//  Copyright © 2016年 LeeFengHY. All rights reserved.
//

#import "UIImageView+LLWebCache.h"

@implementation UIImageView (LLWebCache)


- (void)ll_setImageWithURL:(NSURL *)url
{
    [self ll_setImageWithURL:url placeholderImage:nil];
}


- (void)ll_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self ll_setImageWithURL:url placeholderImage:placeholder completed:nil];
}

- (void)ll_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(LLWebImageCompletionBlock)completed
{
    [self ll_setImageWithURL:url placeholderImage:placeholder options:LaunchAdImageDefault completed:completed];
}


- (void)ll_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(LaunchAdImageOptions)options completed:(LLWebImageCompletionBlock)completed
{
    if(placeholder) self.image = placeholder;
    if (url) {
        __weak __typeof(self)weakSelf = self;
        [LLLaunchAdImageDownload ll_downloadWebImageAsyncWithURL:url options:options completed:^(UIImage *image, NSURL *URL) {
            if (!weakSelf) return;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.image = image;
                if (image && completed) {
                    completed(image,url);
                }
            });
        }];
    }
}
@end
