//
//  LLImageCache.h
//  LLLaunchAd
//
//  Created by QFWangLP on 2016/11/22.
//  Copyright © 2016年 LeeFengHY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LLImageCache : NSObject

/**
 获取缓存图片

 @param url 图片url

 @return image
 */
+ (UIImage *)ll_getCacheImageWithURL:(NSURL *)url;

/**
 缓存图片

 @param data image data i
 @param url  mage url
 */
+ (void)ll_saveImageData:(NSData *)data imageURL:(NSURL *)url;


/**
 获取图片缓存路径

 @return path
 */
+ (NSString *)ll_cacheImagePath;

/**
 check路径

 @param path 路径
 */
+ (void)ll_checkDirector:(NSString *)path;
@end
