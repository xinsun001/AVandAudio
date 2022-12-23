//
//  AVPlayerViewController.m
//  AVPlayerDemo
//
//  Created by facilityone on 2022/12/22.
//

#import "AVPlayerViewController.h"
#import "XSVideoView.h"
#import <AVFoundation/AVFoundation.h>
#import "Masonry.h"

#define screeHeight  [UIScreen mainScreen].bounds.size.height
#define screeWidth  [UIScreen mainScreen].bounds.size.width


@interface AVPlayerViewController ()


@property(nonatomic,strong)UIView *bgBlackView;

@property(nonatomic,strong)XSVideoView *xsVideoView;

@property (nonatomic,strong) AVPlayer *player; // 播放器
@property (nonatomic,strong) AVPlayerItem *playerItem; // 播放器属性对象
@property (nonatomic,strong) AVPlayerLayer *playerLayer; // 播放器需要的layer
@property (nonatomic,assign) BOOL isDragSlider; // 是否拖动Slider

@property (nonatomic,strong) NSTimer *autoDismissTimer;



@end

@implementation AVPlayerViewController

-(void)dealloc{
    
}

- (void)didMoveToParentViewController:(UIViewController *)paren{
    if (!paren) {
        
    }
}


-(UIView *)bgBlackView{
    if (!_bgBlackView) {
        _bgBlackView=[UIView new];
        _bgBlackView.backgroundColor=[UIColor blackColor];
    }
    return _bgBlackView;
}

-(XSVideoView *)xsVideoView{
    if (!_xsVideoView) {
        _xsVideoView=[XSVideoView new];
    }
    return _xsVideoView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf=self;
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    self.bgBlackView.alpha=0.0;
    
    [self.view addSubview:self.bgBlackView];
    [self.bgBlackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    self.xsVideoView.backgroundColor=[UIColor blackColor];
    
    [self.view addSubview:self.xsVideoView];
    [self.xsVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(weakSelf.view);
        make.centerY.equalTo(weakSelf.view);
        make.height.mas_equalTo(screeHeight/3);
    }];
    
    
    [self.view layoutIfNeeded];
      
    
    UITapGestureRecognizer *tapSlider = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchSlider:)];
    [self.xsVideoView.scheduleSlider addGestureRecognizer:tapSlider];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self.xsVideoView addGestureRecognizer:tap];
    
    
    // 初始化播放器item
//
//    //本地视频播放
//    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"chenyifaer" ofType:@"mp4"];
//    NSURL *url = [NSURL fileURLWithPath:audioPath];
    
  
////    网络播放
    NSString *playString = @"https://cloud.video.taobao.com/play/u/1723456468/p/2/e/6/t/1/244497031401.mp4?appKey=38829";
    
//    NSString *playString = @"http://downsc.chinaz.net/Files/DownLoad/sound1/201906/11582.mp3";
    NSURL *url = [NSURL URLWithString:playString];
  
    self.playerItem = [AVPlayerItem playerItemWithURL:url];

    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    // 初始化播放器的Layer
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    // layer的frame
    self.playerLayer.frame = self.xsVideoView.videoBgView.bounds;
    
    // layer的填充属性 和UIImageView的填充属性类似
    // AVLayerVideoGravityResizeAspect 等比例拉伸，会留白
    // AVLayerVideoGravityResizeAspectFill // 等比例拉伸，会裁剪
    // AVLayerVideoGravityResize // 保持原有大小拉伸
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    // 把Layer加到底部View上
    [self.xsVideoView.videoBgView.layer addSublayer:self.playerLayer];
    
    // 监听播放器状态变化
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    // 监听缓冲
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    
    [self videoBlock];
}

-(void)playToEnd:(NSNotification *)nottification{
    //进度条归零
    [self.playerItem seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        
    }];
}


-(void)videoBlock{
    
    __weak typeof(self)  weakSelf=self;
    
  
    [self.xsVideoView setSliderChangeBlock:^{
        
        weakSelf.isDragSlider = YES;
    }];
    
    [self.xsVideoView setSliderInsideBlock:^{
        weakSelf.isDragSlider = NO;
        // CMTimeMake(帧数（slider.value * timeScale）, 帧/sec)
        // 直接用秒来获取CMTime
        [weakSelf.player seekToTime:CMTimeMakeWithSeconds(weakSelf.xsVideoView.scheduleSlider.value, weakSelf.playerItem.currentTime.timescale)];
    }];
    
    
    [self.xsVideoView setVideoBackButtonBlock:^{
                
        [weakSelf xsVideoStop];
        
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
    
    [self.xsVideoView setPlayerButtonBlock:^{
        
        if (weakSelf.player.rate != 1.0f)
        {
            
            [weakSelf.player play];
        }
        else
        {
            [weakSelf.player pause];
        }
        
        if (weakSelf.xsVideoView.playerButton.isSelected==YES) {
            
            weakSelf.xsVideoView.playerButton.selected=NO;
            
            [weakSelf.xsVideoView.playerButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];

        }else{
            weakSelf.xsVideoView.playerButton.selected=YES;

            [weakSelf.xsVideoView.playerButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];

        }
    }];
    
    
    [self.xsVideoView setScreenButtonBlock:^{
        
        if (weakSelf.xsVideoView.screenButton.isSelected==YES) {
            
            weakSelf.xsVideoView.screenButton.selected=NO;
            
            [weakSelf.xsVideoView.screenButton setImage:[UIImage imageNamed:@"fullscreen"] forState:UIControlStateNormal];
            [weakSelf touchSmallScreen];


        }else{
            weakSelf.xsVideoView.screenButton.selected=YES;
            
            [weakSelf.xsVideoView.screenButton setImage:[UIImage imageNamed:@"nonfullscreen"] forState:UIControlStateNormal];
           
            [weakSelf touchScreen];


        }
    }];
    
    
    
    
    
}


// 点击事件的Slider
- (void)touchSlider:(UITapGestureRecognizer *)tap
{
    // 根据点击的坐标计算对应的比例
    CGPoint touch = [tap locationInView:self.xsVideoView.scheduleSlider];
    CGFloat scale = touch.x / self.xsVideoView.scheduleSlider.bounds.size.width;
    
    self.xsVideoView.scheduleSlider.value = CMTimeGetSeconds(self.playerItem.duration) * scale;
    [self.player seekToTime:CMTimeMakeWithSeconds(self.xsVideoView.scheduleSlider.value, self.playerItem.currentTime.timescale)];

    if (self.player.rate != 1)
    {
        [self.xsVideoView.playerButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [self.player play];
    }
}



#pragma mark - 单击手势
- (void)singleTap:(UITapGestureRecognizer *)tap
{
    
    __weak typeof(self)  weakSelf=self;

    // 和即时搜索一样，删除之前未执行的操作
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoDismissView:) object:nil];
    
    // 这里点击会隐藏对应的View，那么之前的定时还开着，如果不关掉，就会可能重复
    [self.autoDismissTimer invalidate];
    self.autoDismissTimer = nil;
    self.autoDismissTimer = [NSTimer timerWithTimeInterval:8.0 target:self selector:@selector(autoDismissView:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.autoDismissTimer forMode:NSDefaultRunLoopMode];
    
    [UIView animateWithDuration:1.0 animations:^{
        if (weakSelf.xsVideoView.bottomView.alpha == 1)
        {
            weakSelf.xsVideoView.bottomView.alpha = 0;
            weakSelf.xsVideoView.playerButton.alpha = 0;
        }
        else if (weakSelf.xsVideoView.bottomView.alpha == 0)
        {
            weakSelf.xsVideoView.bottomView.alpha = 1.0f;
            weakSelf.xsVideoView.playerButton.alpha = 1.0f;
        }
        
        
    }];
}



// 监听播放器的变化属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"])
    {
        AVPlayerItemStatus statues = [change[NSKeyValueChangeNewKey] integerValue];
        switch (statues) {
            case AVPlayerItemStatusReadyToPlay:
                
                [self initTimer];
                
                // 启动定时器 5秒自动隐藏
                if (!self.autoDismissTimer)
                {
                    self.autoDismissTimer = [NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(autoDismissView:) userInfo:nil repeats:YES];
                    [[NSRunLoop currentRunLoop] addTimer:self.autoDismissTimer forMode:NSDefaultRunLoopMode];
                }
                break;
            case AVPlayerItemStatusUnknown:
                
                break;
            case AVPlayerItemStatusFailed:
                
                
                break;
                
            default:
                break;
        }
    }
    else if ([keyPath isEqualToString:@"loadedTimeRanges"]) // 监听缓存进度的属性
    {
        
        // 计算缓存进度
        NSTimeInterval timeInterval = [self availableDuration];
        // 获取总长度
        CMTime duration = self.playerItem.duration;
        
        CGFloat durationTime = CMTimeGetSeconds(duration);
        // 监听到了给进度条赋值
        [self.xsVideoView.cacheProgress setProgress:timeInterval / durationTime animated:NO];

    }
    
    
}

/**
 *  计算缓冲进度
 *
 *  @return 缓冲进度
 */
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [self.playerItem loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds        = CMTimeGetSeconds(timeRange.start); // 开始的点
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration); // 已缓存的时间点
    NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

// 调用plaer的对象进行UI更新
- (void)initTimer
{
    // player的定时器
    __weak typeof(self)weakSelf = self;
    // 每秒更新一次UI Slider
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        // 当前时间
        CGFloat nowTime = CMTimeGetSeconds(weakSelf.playerItem.currentTime);
        // 总时间
        CGFloat duration = CMTimeGetSeconds(weakSelf.playerItem.duration);
        // sec 转换成时间点
        weakSelf.xsVideoView.leftTimeLabel.text = [weakSelf convertToTime:nowTime];
        weakSelf.xsVideoView.rightTimeLabel.text = [weakSelf convertToTime:(duration - nowTime)];
        
        // 不是拖拽中的话更新UI
        if (!weakSelf.isDragSlider)
        {
            weakSelf.xsVideoView.scheduleSlider.value = nowTime/duration;
        }
        
    }];
}

// sec 转换成指定的格式
- (NSString *)convertToTime:(CGFloat)time
{
    // 初始化格式对象
    NSDateFormatter *fotmmatter = [[NSDateFormatter alloc] init];
    // 根据是否大于1H，进行格式赋值
    if (time >= 3600)
    {
        [fotmmatter setDateFormat:@"HH:mm:ss"];
    }
    else
    {
        [fotmmatter setDateFormat:@"mm:ss"];
    }
    // 秒数转换成NSDate类型
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    // date转字符串
    return [fotmmatter stringFromDate:date];
}


#pragma mark - 自动隐藏bottom和top
- (void)autoDismissView:(NSTimer *)timer
{
    
    __weak typeof(self) weakSelf=self;
    
    if (self.player.rate == 0)
    {
        // 暂停状态就不隐藏
    }
    else if (self.player.rate == 1)
    {
        if (self.xsVideoView.bottomView.alpha == 1)
        {
            [UIView animateWithDuration:1.0 animations:^{
                
                weakSelf.xsVideoView.bottomView.alpha = 0;
                weakSelf.xsVideoView.playerButton.alpha = 0;
                
            }];
        }
    }
}



-(void)touchScreen{
    
    __weak typeof(self) weakSelf=self;

    self.bgBlackView.alpha=1.0;

    self.xsVideoView.screenButton.selected=YES;
    
    [self.xsVideoView.screenButton setImage:[UIImage imageNamed:@"nonfullscreen"] forState:UIControlStateNormal];
    
    [self.xsVideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.centerY.equalTo(weakSelf.view.mas_top);
        make.width.mas_equalTo(screeHeight);
        make.height.mas_equalTo(screeWidth);
    }];
    
    self.xsVideoView.transform = CGAffineTransformMakeRotation(M_PI_2);

    [self.view layoutIfNeeded];

    // layer的frame
    self.playerLayer.frame = self.xsVideoView.videoBgView.bounds;
    
}




-(void)touchSmallScreen{
    
    __weak typeof(self)  weakSelf=self;
    
    self.bgBlackView.alpha=1.0;
    
    self.xsVideoView.screenButton.selected=NO;
    
    [self.xsVideoView.screenButton setImage:[UIImage imageNamed:@"fullscreen"] forState:UIControlStateNormal];
    
    [self.xsVideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.centerY.equalTo(weakSelf.view);
        make.width.mas_offset(screeWidth);
        make.height.mas_offset(screeHeight/3);
    }];
    
    
//    旋转角度
    self.xsVideoView.transform = CGAffineTransformMakeRotation(0);
    
    [self.view layoutIfNeeded];

    // layer的frame
    self.playerLayer.frame = self.xsVideoView.videoBgView.bounds;
}




-(void)xsVideoStop{
    
    
    [self.xsVideoView playerButtonAction];
    
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
    
    //    加上这句话，避免反复进入视频播放时，后面导致视频不加载的情况，
    [self.player replaceCurrentItemWithPlayerItem:nil];
        
    if (self.player) {
        [self.player pause];
        self.playerItem = nil;
        self.xsVideoView.scheduleSlider.value = 0;
        self.player = nil;
    }
    
    [self.autoDismissTimer invalidate];
    self.autoDismissTimer=nil;
    
}


@end
