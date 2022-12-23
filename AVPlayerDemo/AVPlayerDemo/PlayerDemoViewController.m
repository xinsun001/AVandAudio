//
//  PlayerDemoViewController.m
//  AVPlayerDemo
//
//  Created by facilityone on 2022/12/22.
//

#import "PlayerDemoViewController.h"
#import "AVPlayerViewController.h"
#import "AudioViewController.h"

@interface PlayerDemoViewController ()

@end

@implementation PlayerDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [videoBtn setTitle:@"播放视频" forState:UIControlStateNormal];
    videoBtn.backgroundColor = [UIColor redColor];
    [videoBtn addTarget:self action:@selector(videoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:videoBtn];
    
    videoBtn.frame = CGRectMake(100, 100, 120, 40);
    
    
    UIButton *audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [audioBtn setTitle:@"播放音频" forState:UIControlStateNormal];
    audioBtn.backgroundColor = [UIColor redColor];
    [audioBtn addTarget:self action:@selector(audioAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:audioBtn];
    
    audioBtn.frame = CGRectMake(100, 180, 120, 40);
}

-(void)videoAction{
    
    AVPlayerViewController *vc = [AVPlayerViewController new];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:^{
        
    }];
    
    
}


-(void)audioAction{
    AudioViewController *vc = [AudioViewController new];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

@end
