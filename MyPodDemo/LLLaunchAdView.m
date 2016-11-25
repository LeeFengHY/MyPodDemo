//
//  LLLaunchAdView.m
//  LLLaunchAd
//
//  Created by QFWangLP on 2016/11/22.
//  Copyright © 2016年 LeeFengHY. All rights reserved.
//

#import "LLLaunchAdView.h"
#import "LLImageCache.h"
#import "UIImageView+LLWebCache.h"

#define SkipButtonHeight 30
#define SkipButtonWidth  70

static const NSTimeInterval noDataDefaultDuration = 3;
@interface LLLaunchAdView ()

@property (nonatomic, strong) UIImageView *launchImageView;
@property (nonatomic, strong) UIImageView *adImageView;
@property (nonatomic, strong) UIButton    *skipButton;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, copy) dispatch_source_t noDataTimer;
@property (nonatomic, copy) dispatch_source_t skipButtonTimer;
@property (nonatomic, copy) adImageClickBlock adImageClickBlock;
@property (nonatomic, copy) setAdImageBlock   setAdImageBlock;
@property (nonatomic, copy) showFinishBlock   showFinishBlock;
@property (nonatomic, assign) LaunchType      launchType;
@property (nonatomic, assign) BOOL isShowFinish;
@property (nonatomic, assign) BOOL isClick;
@property (nonatomic, copy)   NSString *imageUrl;
@end

@implementation LLLaunchAdView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (void)showWithAdFrame:(CGRect)frame
        setAdImageBlock:(setAdImageBlock)setAdImageBlock
             showFinish:(showFinishBlock)showFinishBlock
{
    LLLaunchAdView *launchAdView = [[LLLaunchAdView alloc] initWithFrame:frame showFinish:showFinishBlock];
    [[[UIApplication sharedApplication] delegate] window].rootViewController = launchAdView;
    if (setAdImageBlock) setAdImageBlock(launchAdView);
}

- (void)setImageUrl:(NSString *)imageUrl
           duration:(NSTimeInterval)duration
         launchType:(LaunchType)launchType
            options:(LaunchAdImageOptions)option
          completed:(LLWebImageCompletionBlock)completed
  adImageClickBlock:(adImageClickBlock)adImageClickBlock
{
    if (_isShowFinish) return;
    if ([self imageUrlError:imageUrl]) return;
    _duration = duration;
    _launchType = launchType;
    _imageUrl = imageUrl;
    [self setupAdImageViewAndSkipButton];
    [_adImageView ll_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:option completed:completed];
    _adImageClickBlock = adImageClickBlock;
}

- (void)setupAdImageViewAndSkipButton
{
    [self.view addSubview:self.adImageView];
    [self.view addSubview:self.skipButton];
    [self animationStart];
}
- (void)clearDiskCache
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *path = [LLImageCache ll_cacheImagePath];
        [fileManager removeItemAtPath:path error:nil];
        [LLImageCache ll_checkDirector:path];
    });
}

+ (float)imagesCacheSize
{
    NSString *directoryPath = [LLImageCache ll_cacheImagePath];
    BOOL isDir = NO;
    unsigned long long total = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:directoryPath isDirectory:&isDir]) {
        if (isDir) {
            NSError *error = nil;
            NSArray *array = [fileManager contentsOfDirectoryAtPath:directoryPath error:&error];
            if (error == nil) {
                for (NSString *subpath in array) {
                    NSString *path = [directoryPath stringByAppendingPathComponent:subpath];
                    NSDictionary *dict = [fileManager attributesOfItemAtPath:path error:&error];
                    if (!error) {
                        total += [dict[NSFileSize] unsignedLongLongValue];
                    }
                }
            }
        }
    }
    return total/(1024 * 1024); //单位:MB
}

#pragma mark private
- (instancetype)initWithFrame:(CGRect)frame showFinish:(void(^)())showFinish
{
    self = [super init];
    if (self) {
        _adFrame = frame;
        _noDataDuration = noDataDefaultDuration;
        _showFinishBlock = [showFinish copy];
        [self.view addSubview:self.launchImageView];
    }
    return self;
}
- (BOOL)imageUrlError:(NSString *)imageUrl
{
    if (imageUrl == nil || imageUrl.length == 0 || ![imageUrl hasPrefix:@"http"]) {
        NSLog(@"图片URL地址为nil,或者有误!");
        return YES;
    }
    
    return NO;
}
- (void)animationStart
{
    NSTimeInterval duration = _duration;
    duration = duration/4.0;
    if(duration > 1.0) duration = 1.0;
    [UIView animateWithDuration:duration animations:^{
        self.adImageView.alpha = 1;
    }];
}
- (void)startNoDataDispath_tiemr
{
    NSTimeInterval period = 1.0;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _noDataTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_noDataTimer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
    
    __block NSTimeInterval duration = _noDataDuration;
    dispatch_source_set_event_handler(_noDataTimer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (duration == 0) {
                dispatch_source_cancel(_noDataTimer);
                [self remove];
            }
            duration--;
        });
    });
    dispatch_resume(_noDataTimer);
}

- (void)startSkipButtonTimer
{
    if(_noDataTimer) dispatch_source_cancel(_noDataTimer);
    
    NSTimeInterval period = 1.0;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _skipButtonTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_skipButtonTimer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(_skipButtonTimer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self skipButtonTitleWithDuration:_duration];
            if(_duration==0)
            {
                dispatch_source_cancel(_skipButtonTimer);
                
                [self remove];
            }
            _duration--;
        });
    });
    dispatch_resume(_skipButtonTimer);
}

-(void)skipButtonTitleWithDuration:(NSTimeInterval)duration{
    
    switch (_launchType) {
        case LaunchTypeNone:
            
            _skipButton.hidden = YES;
            
            break;
        case LaunchTypeTime:
            
            [_skipButton setTitle:[NSString stringWithFormat:@"%ld S",(long)duration] forState:UIControlStateNormal];
            
            break;
        case LaunchTypeText:
            
            [_skipButton setTitle:@"跳過" forState:UIControlStateNormal];
            
            break;
            
        case LaunchTypeTimeText:
            
            [_skipButton setTitle:[NSString stringWithFormat:@"%ld 跳過",(long)duration] forState:UIControlStateNormal];
            
            break;
            
        default:
            break;
    }
}
#pragma mark 懒加载
- (UIImageView *)launchImageView
{
    if (!_launchImageView) {
        _launchImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _launchImageView.image = [self getLaunchImage];
    }
    return _launchImageView;
}

- (UIImage *)getLaunchImage
{
    UIImage *imageP = [self launchImageWithType:@"Portrait"];
    if (imageP) return imageP;
    UIImage *imageL = [self launchImageWithType:@"Landscape"];
    if (imageL) return imageL;
    NSLog(@"获取LaunchImage失败!请检查是否添加启动图,或者规格是否有误.");
    return nil;
}
- (UIImage *)launchImageWithType:(NSString *)type
{
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = type;
    NSString *launchImageName = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if([viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            if([dict[@"UILaunchImageOrientation"] isEqualToString:@"Landscape"])
            {
                imageSize = CGSizeMake(imageSize.height, imageSize.width);
            }
            if(CGSizeEqualToSize(imageSize, viewSize))
            {
                launchImageName = dict[@"UILaunchImageName"];
                UIImage *image = [UIImage imageNamed:launchImageName];
                return image;
            }
        }
    }
    return nil;
}
- (UIImageView *)adImageView
{
    if (!_adImageView) {
        _adImageView = [[UIImageView alloc] initWithFrame:_adFrame];
        _adImageView.userInteractionEnabled = YES;
        _adImageView.alpha = 0.0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchedAdImageView:)];
        [_adImageView addGestureRecognizer:tap];
    }
    return _adImageView;
}
- (void)didTouchedAdImageView:(UITapGestureRecognizer *)tap
{
    if (_duration > 0) {
        self.isClick = YES;
        [self remove];
        if (_adImageClickBlock) {
            _adImageClickBlock(_imageUrl);
        }
    }
}

- (UIButton *)skipButton
{
    if (!_skipButton) {
        _skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - SkipButtonWidth - 10, SkipButtonHeight, SkipButtonWidth, SkipButtonHeight);
        _skipButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _skipButton.layer.cornerRadius = SkipButtonHeight / 2;
        _skipButton.layer.masksToBounds = YES;
        _skipButton.titleLabel.font = [UIFont systemFontOfSize:13.5];
        [_skipButton addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
        if(!_duration || _duration <= 0) _duration = 5.0;
        if(!_launchType) _launchType = LaunchTypeTimeText;
        [self skipButtonTitleWithDuration:_duration];
        [self startSkipButtonTimer];
    }
    return _skipButton;
}
- (void)skipAction
{
    if (_launchType != LaunchTypeTime) {
        self.isClick = NO;
        if (_skipButtonTimer) dispatch_source_cancel(_skipButtonTimer);
        [self remove];
    }
}

- (void)setAdFrame:(CGRect)adFrame
{
    _adFrame = adFrame;
    _adImageView.frame = _adFrame;
}

- (void)setNoDataDuration:(NSTimeInterval)noDataDuration
{
    if(noDataDuration < 1) noDataDuration = 1;
    _noDataDuration = noDataDuration;
    dispatch_source_cancel(_noDataTimer);
    [self startNoDataDispath_tiemr];
}

- (void)remove
{
    [UIView transitionWithView:[[UIApplication sharedApplication].delegate window] duration:0.3 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionTransitionCrossDissolve  animations:^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        _isShowFinish = YES;
        [self.view removeFromSuperview];
        if(_showFinishBlock) _showFinishBlock();
        [UIView setAnimationsEnabled:oldState];
    } completion:^(BOOL finished) {
        
    }];
}

@end
