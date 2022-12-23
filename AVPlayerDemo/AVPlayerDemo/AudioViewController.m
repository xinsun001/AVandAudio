//
//  AudioViewController.m
//  AVPlayerDemo
//
//  Created by facilityone on 2022/12/23.
//

#import "AudioViewController.h"
#import <AVFAudio/AVFAudio.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioViewController ()<AVAudioPlayerDelegate>

@property(nonatomic,strong)NSString *audioName;
@property(nonatomic,strong)AVAudioPlayer *auplayer;


@property (nonatomic,strong) AVPlayer *avplayer; // 播放器
@property (nonatomic,strong) AVPlayerItem *playerItem; // 播放器属性对象


@property(nonatomic,strong)AVAudioPlayer *musicplayer;

@end

@implementation AudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.auplayer = [AVAudioPlayer new];

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    backBtn.backgroundColor = [UIColor redColor];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
   
    [self.view addSubview:backBtn];
    
    backBtn.frame = CGRectMake(10, 50, 80, 30);

    self.audioName = @"fm1.caf";
    
    UILabel *audioLabel = [UILabel new];
    audioLabel.text = @"本地音频✅";
    audioLabel.textColor = [UIColor blackColor];
    
    UIButton *audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [audioBtn setTitle:self.audioName forState:UIControlStateNormal];
    audioBtn.backgroundColor = [UIColor redColor];
    [audioBtn addTarget:self action:@selector(audioAction) forControlEvents:UIControlEventTouchUpInside];
   
    [self.view addSubview:audioLabel];
    [self.view addSubview:audioBtn];
    
    audioLabel.frame = CGRectMake(80, 100, 120, 40);
    audioBtn.frame = CGRectMake(220, 100, 120, 40);
    
        
    UILabel *intentLabel = [UILabel new];
    intentLabel.text = @"AVaudioPlayer❎";
    intentLabel.textColor = [UIColor blackColor];
    
    UIButton *intentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [intentBtn setTitle:@"在线mp3" forState:UIControlStateNormal];
    intentBtn.backgroundColor = [UIColor redColor];
    [intentBtn addTarget:self action:@selector(intentAction) forControlEvents:UIControlEventTouchUpInside];
   
    [self.view addSubview:intentLabel];
    [self.view addSubview:intentBtn];
    
    intentLabel.frame = CGRectMake(60, 180, 150, 40);
    intentBtn.frame = CGRectMake(220, 180, 120, 40);
    
    UILabel *avLabel = [UILabel new];
    avLabel.text = @"AVPlayer✅";
    avLabel.textColor = [UIColor blackColor];
    
    UIButton *avBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [avBtn setTitle:@"在线mp3" forState:UIControlStateNormal];
    avBtn.backgroundColor = [UIColor redColor];
    [avBtn addTarget:self action:@selector(avAction) forControlEvents:UIControlEventTouchUpInside];
   
    
    [self.view addSubview:avLabel];
    [self.view addSubview:avBtn];

    avLabel.frame = CGRectMake(60, 260, 120, 40);
    avBtn.frame = CGRectMake(190, 260, 120, 40);

    [self setAudioUI];
}

-(void)backBtnAction{
    [self  xsVideoStop];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


-(void)audioAction{
    
    NSString *playAudio = [[NSBundle mainBundle] pathForResource:self.audioName ofType:nil];
    NSURL *url = [NSURL URLWithString:playAudio];
    self.auplayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.auplayer.volume = 0.8;    //音量
    self.auplayer.delegate = self;
    [self.auplayer prepareToPlay]; //预加载
    [self.auplayer play];
    
    
}

-(void)intentAction{

    NSString *playAudio = [[NSBundle mainBundle] pathForResource:@"http://downsc.chinaz.net/Files/DownLoad/sound1/201906/11582.mp3" ofType:nil];
    NSURL *url = [NSURL URLWithString:playAudio];
    self.auplayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.auplayer.volume = 0.8;    //音量
    self.auplayer.delegate = self;
    [self.auplayer prepareToPlay]; //预加载
    [self.auplayer play];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    
}


-(void)avAction{
    NSURL *url = [NSURL URLWithString:@"http://downsc.chinaz.net/Files/DownLoad/sound1/201906/11582.mp3"];
    self.playerItem = [AVPlayerItem playerItemWithURL:url];

    self.avplayer = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    // 监听播放器状态变化
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    // 监听缓存大小
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    
}

-(void)playToEnd:(NSNotification *)nottification{
    //进度条归零
    [self.playerItem seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        
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
                
                [self.avplayer play];
                
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
       
        UILabel *tiemLabel = [UILabel new];
        tiemLabel.text = [NSString stringWithFormat:@"%.2f秒",durationTime];
        tiemLabel.textColor = [UIColor blackColor];
        [self.view addSubview:tiemLabel];
        tiemLabel.frame = CGRectMake(320, 260, 120, 40);

        NSLog(@"缓冲进度%.2f",durationTime);
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



-(void)xsVideoStop{
    
        
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    
    //    加上这句话，避免反复进入视频播放时，后面导致视频不加载的情况，
        [self.avplayer replaceCurrentItemWithPlayerItem:nil];

    
    if (self.avplayer) {
        [self.avplayer pause];
        self.playerItem = nil;
        self.avplayer = nil;
    }
    
  
//    可用于重复播放时，进度条归零
//    [_playerItem seekToTime:kCMTimeZero];

    
}


-(void)setAudioUI{
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setTitle:@"播放" forState:UIControlStateNormal];
    playBtn.backgroundColor = [UIColor redColor];
    [playBtn addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
   
    UIButton *puseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [puseBtn setTitle:@"暂停" forState:UIControlStateNormal];
    puseBtn.backgroundColor = [UIColor redColor];
    [puseBtn addTarget:self action:@selector(puseAction) forControlEvents:UIControlEventTouchUpInside];
   
    UIButton *endBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [endBtn setTitle:@"结束" forState:UIControlStateNormal];
    endBtn.backgroundColor = [UIColor redColor];
    [endBtn addTarget:self action:@selector(endAction) forControlEvents:UIControlEventTouchUpInside];
   
    
    [self.view addSubview:playBtn];
    [self.view addSubview:puseBtn];
    [self.view addSubview:endBtn];

    playBtn.frame = CGRectMake(60, 340, 100, 40);
    puseBtn.frame = CGRectMake(170, 340, 100, 40);
    endBtn.frame = CGRectMake(280, 340, 100, 40);

}

-(void)playAction{
    
    NSString *playAudio = [[NSBundle mainBundle] pathForResource:@"Ice.mp3" ofType:nil];
    NSURL *url = [NSURL URLWithString:playAudio];
    self.musicplayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.musicplayer.volume = 0.8;    //音量
    self.musicplayer.numberOfLoops = 0;  //循环次数，-1表示无限循环，0不循环

    self.musicplayer.delegate = self;
    [self.musicplayer prepareToPlay]; //预加载
    
//    self.musicplayer.currentTime = 18;  //从18秒开始播放
    [self.musicplayer play];
    
    
    
    
    NSTimeInterval time = self.musicplayer.duration;
    UILabel *tiemLabel = [UILabel new];
    tiemLabel.text = [NSString stringWithFormat:@"%.2f秒",time];
    tiemLabel.textColor = [UIColor blackColor];
    [self.view addSubview:tiemLabel];
    tiemLabel.frame = CGRectMake(170, 400, 120, 40);
    NSLog(@"总时长%f",time);
    
}

-(void)puseAction{
    if (self.musicplayer.isPlaying) {
        [self.musicplayer pause];
    }else{
        [self.musicplayer play];
    }
    
}

-(void)endAction{
    
    [self.musicplayer stop];
    
}


@end
