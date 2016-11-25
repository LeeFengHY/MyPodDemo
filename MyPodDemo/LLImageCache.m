
//
//  LLImageCache.m
//  LLLaunchAd
//
//  Created by QFWangLP on 2016/11/22.
//  Copyright © 2016年 LeeFengHY. All rights reserved.
//

#import "LLImageCache.h"
#import <CommonCrypto/CommonDigest.h>
#import "UIImage+LLGIF.h"

@implementation LLImageCache

+ (UIImage *)ll_getCacheImageWithURL:(NSURL *)url
{
    if (!url) return nil;
    NSString *directoryPath = [self ll_cacheImagePath];
    NSString *path = [NSString stringWithFormat:@"%@/%@",directoryPath,[self ll_md5String:url.absoluteString]];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [UIImage ll_animatedGIFWithData:data];
}

+ (void)ll_saveImageData:(NSData *)data imageURL:(NSURL *)url
{
    NSString *directoryPath = [self ll_cacheImagePath];
    NSString *path = [NSString stringWithFormat:@"%@/%@",directoryPath,[self ll_md5String:url.absoluteString]];
    if (data) {
        BOOL isOk = [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
        if (!isOk) NSLog(@"cache file error for URL: %@", url);
    }else{
        NSLog(@"save image error");
    }
}

+ (NSString *)ll_cacheImagePath
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/LaunchAdCache"];
    [self ll_checkDirector:path];
    return path;
}

+ (void)ll_checkDirector:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        [self ll_createBaseDirectoryPath:path];
    }else{
        if (!isDir) {
            NSError *error = nil;
            [fileManager removeItemAtPath:path error:&error];
            [self ll_createBaseDirectoryPath:path];
        }
    }
}
+ (void)ll_createBaseDirectoryPath:(NSString *)path
{
    __autoreleasing NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (error) {
        NSLog(@"create cache directory failed, error = %@", error);
    }else{
        NSLog(@"LaunchAdCachePath:%@",path);
        //iTunes不被备份
        [self ll_addDoNotBackupAttribute:path];
    }
    
}
+ (void)ll_addDoNotBackupAttribute:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (error) {
        NSLog(@"error to set do not backup attribute, error = %@", error);
    }
}
+ (NSString *)ll_md5String:(NSString *)string
{
    if (string == nil || string.length == 0) return nil;
    const char *value = [string UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    NSMutableString *outputString = [NSMutableString new];
    for (NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++) {
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    return outputString;
}
@end
