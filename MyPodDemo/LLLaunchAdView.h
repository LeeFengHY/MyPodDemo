//
//  LLLaunchAdView.h
//  LLLaunchAd
//
//  Created by QFWangLP on 2016/11/22.
//  Copyright © 2016年 LeeFengHY. All rights reserved.

//  特性:
//  1.支持全屏/半屏广告.
//  2.支持静态/动态广告.
//  3.兼容iPhone和iPad.
//  4.支持广告点击事件
//  5.自带图片下载,缓存功能.
//  6.支持设置未检测到广告数据,启动页停留时间
//  7.无依赖其他第三方框架.


#import <UIKit/UIKit.h>
#import "LLLaunchAdImageDownload.h"

@class LLLaunchAdView;

typedef NS_ENUM(NSInteger, LaunchType)
{
    LaunchTypeNone           = 1,  //无
    LaunchTypeTime           = 2,  //只显示倒计时
    LaunchTypeText           = 3,  //只显示文字(跳过)
    LaunchTypeTimeText       = 4,  //显示倒计时和文字(秒数+跳过)
};

@protocol LaunchAdDelegate <NSObject>

- (void)didTouchAdImage:(NSString *)url launchAdView:(LLLaunchAdView *)launchAdView;
- (void)setLaunchAdImage:(LLLaunchAdView *)launchAd;
- (void)launchAdFinishShow;

@end

typedef void(^adImageClickBlock)(NSString *url);
typedef void(^setAdImageBlock)(LLLaunchAdView *launchAdView);
typedef void(^showFinishBlock)();

@interface LLLaunchAdView : UIViewController
/**
 *  未检测到广告数据,启动页停留时间(默认3s)(最小1s)
 *  请在向服务器请求广告数据前,设置此属性
 */
@property (nonatomic, assign) NSTimeInterval noDataDuration;


/**
 重置广告页面的frame
 */
@property (nonatomic, assign) CGRect adFrame;


/**
 初始启动广告

 @param frame    ad frame
 */
+ (void)showWithAdFrame:(CGRect)frame setAdImageBlock:(setAdImageBlock)setAdImageBlock showFinish:(showFinishBlock)showFinishBlock;


/**
 设置广告数据

 @param imageUrl   image url
 @param duration   广告停留时间(小于等于0s,默认按5s处理)
 @param launchType 广告显示和关闭type
 @param option     图片环境机制
 */
- (void)setImageUrl:(NSString *)imageUrl duration:(NSTimeInterval)duration launchType:(LaunchType)launchType options:(LaunchAdImageOptions)option completed:(LLWebImageCompletionBlock)completed adImageClickBlock:(adImageClickBlock)adImageClickBlock;

- (void)clearDiskCache;

+ (float)imagesCacheSize;

@end
