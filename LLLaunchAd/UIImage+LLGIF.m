//
//  UIImage+LLGIF.m
//  LLLaunchAd
//
//  Created by QFWangLP on 2016/11/22.
//  Copyright © 2016年 LeeFengHY. All rights reserved.
//

#import "UIImage+LLGIF.h"
#import <ImageIO/ImageIO.h>

@implementation UIImage (LLGIF)
+ (UIImage *)ll_animatedGIFWithData:(NSData *)data
{
    if (data == nil) return nil;
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(source);
    UIImage *animationImage;
    if (count <= 1) {
        //静态图
        animationImage = [[UIImage alloc] initWithData:data];
    }else {
        //GIF图
        NSMutableArray *images = [NSMutableArray new];
        NSTimeInterval duration = 0.0f;
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            duration += [self ll_frameDurationAtIndex:i source:source];
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            CGImageRelease(image);
        }
        
        if (!duration) {
            duration = (1.0f / 10.f) *count;
        }
        animationImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    CFRelease(source);
    return animationImage;
}

+ (float)ll_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source
{
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, NULL);
    NSDictionary *frameProperties = (__bridge NSDictionary *)(cfFrameProperties);
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = delayTimeUnclampedProp.floatValue;
    }else{
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = delayTimeProp.floatValue;
        }
    }
    
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    CFRelease(cfFrameProperties);
    return frameDuration;
}
@end
