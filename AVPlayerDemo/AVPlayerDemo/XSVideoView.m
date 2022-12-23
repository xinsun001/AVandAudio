//
//  XSVideoView.m
//  mineDemo
//
//  Created by xin sun on 2018/11/7.
//  Copyright © 2018年 xin sun. All rights reserved.
//

#import "XSVideoView.h"
#import "Masonry.h"

@implementation XSVideoView


-(UIView *)videoBgView{
    if (!_videoBgView) {
        _videoBgView=[UIView new];
    }
    return _videoBgView;
}

-(UIView *)topBgview{
    if (!_topBgview) {
        _topBgview=[UIView new];
        _topBgview.alpha=0.3;
        _topBgview.backgroundColor=[UIColor grayColor];
    }
    return _topBgview;
}

-(UIButton *)videoBackButton{
    if (!_videoBackButton) {
        _videoBackButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_videoBackButton setImage:[UIImage imageNamed:@"videoBack"] forState:UIControlStateNormal];
        [_videoBackButton addTarget:self action:@selector(videoBackButtonAvtion) forControlEvents:UIControlEventTouchUpInside];
    }
    return _videoBackButton;
}

-(void)videoBackButtonAvtion{
    if (self.videoBackButtonBlock) {
        self.videoBackButtonBlock();
    }
    
}

-(UILabel *)topTitleLabel{
    if (!_topTitleLabel) {
        _topTitleLabel=[UILabel new];
        _topTitleLabel.textColor=[UIColor whiteColor];
        _topTitleLabel.font=[UIFont systemFontOfSize:15];
        _topTitleLabel.text=@"视频标题";
    }
    return _topTitleLabel;
}


-(UIButton *)playerButton{
    if (!_playerButton) {
        _playerButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_playerButton setImage:[UIImage imageNamed:@"play" ]forState:UIControlStateNormal];
        
        [_playerButton addTarget:self action:@selector(playerButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playerButton;
}

-(void)playerButtonAction{
    
    if (self.playerButtonBlock) {
        self.playerButtonBlock();
    }
    
}


-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView=[UIView new];
        _bottomView.backgroundColor=[UIColor clearColor];
    }
    return _bottomView;
}


-(UIButton *)screenButton{
    if (!_screenButton) {
        _screenButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_screenButton setImage:[UIImage imageNamed:@"fullscreen"] forState:UIControlStateNormal];
        
        [_screenButton addTarget:self action:@selector(screenButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _screenButton;
}

-(void)screenButtonAction{
    
    if (self.screenButtonBlock) {
        self.screenButtonBlock();
    }
    
}


-(UILabel *)leftTimeLabel{
    if (!_leftTimeLabel) {
        _leftTimeLabel=[UILabel new];
        _leftTimeLabel.textColor=[UIColor whiteColor];
        _leftTimeLabel.text=@"00:00";
        _leftTimeLabel.font=[UIFont systemFontOfSize:11];
        
    }
    return _leftTimeLabel;
}

-(UILabel *)rightTimeLabel{
    if (!_rightTimeLabel) {
        _rightTimeLabel=[UILabel new];
        _rightTimeLabel.textColor=[UIColor whiteColor];
        _rightTimeLabel.text=@"00:00";
        _rightTimeLabel.font=[UIFont systemFontOfSize:11];
        
    }
    return _rightTimeLabel;
}


-(UISlider *)scheduleSlider{
    if (!_scheduleSlider) {
        _scheduleSlider=[UISlider new];
        _scheduleSlider.minimumValue=0.0;
        _scheduleSlider.maximumTrackTintColor=[UIColor clearColor];
        _scheduleSlider.minimumTrackTintColor=[UIColor greenColor];
        [_scheduleSlider setThumbImage:[UIImage imageNamed:@"dot"] forState:UIControlStateNormal];
        [_scheduleSlider addTarget:self action:@selector(scheduleSliderChange:) forControlEvents:UIControlEventValueChanged];
        [_scheduleSlider addTarget:self action:@selector(scheduleSliderInside:) forControlEvents:UIControlEventTouchUpInside];
    
        
    }
    return _scheduleSlider;
}



-(void)scheduleSliderChange:(UISlider *)slider{
    
    if (self.sliderChangeBlock) {
        self.sliderChangeBlock();
    }
    
    
}


-(void)scheduleSliderInside:(UISlider *)slider{
    
    if (self.sliderInsideBlock) {
        self.sliderInsideBlock();
    }
    
}



-(UIProgressView *)cacheProgress{
    if (!_cacheProgress) {
        _cacheProgress=[UIProgressView new];
        _cacheProgress.progressTintColor=[UIColor blueColor];
        _cacheProgress.trackTintColor=[UIColor lightGrayColor];
//        _cacheProgress.progress=0.4;
    }
    return _cacheProgress;
}






-(instancetype)init{
    
    self=[super init];
    
    if (self) {
        
        __weak typeof(self)  weakSelf=self;
        
        
        [self addSubview:self.videoBgView];
        [self.videoBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf);
        }];
        
        [self addSubview:self.topBgview];
        [self.topBgview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.trailing.equalTo(weakSelf);
            make.height.mas_equalTo(30);
        }];
        
        [self addSubview:self.videoBackButton];
        [self addSubview:self.topTitleLabel];
        
        [self.videoBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.equalTo(weakSelf);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(25);
        }];
        
        [self.topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.height.mas_equalTo(weakSelf.videoBackButton);
            make.leading.equalTo(weakSelf.videoBackButton.mas_trailing);
        }];
        
        
        [self addSubview:self.playerButton];
        
        [self.playerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(weakSelf);
            make.width.height.mas_equalTo(50);
        }];
        
        
        [self addSubview:self.bottomView];
        
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(weakSelf);
            make.height.mas_equalTo(45);
            
        }];
        
        [self.bottomView addSubview:self.screenButton];
        [self.bottomView addSubview:self.leftTimeLabel];
        [self.bottomView addSubview:self.rightTimeLabel];
        
        [self.screenButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.bottom.equalTo(weakSelf.bottomView);
            make.height.width.mas_equalTo(45);
            
        }];
        
        [self.leftTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.bottomView.mas_leading).offset(10);
            make.bottom.equalTo(weakSelf.bottomView.mas_bottom).offset(-5);
            make.height.mas_equalTo(15);
            
        }];
        
        [self.rightTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.height.equalTo(weakSelf.leftTimeLabel);
            make.trailing.equalTo(weakSelf.screenButton.mas_leading);
        }];
        
        
        [self.bottomView addSubview:self.cacheProgress];
        [self.bottomView addSubview:self.scheduleSlider];

        [self.scheduleSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.leftTimeLabel.mas_leading);
            make.trailing.equalTo(weakSelf.rightTimeLabel.mas_trailing);
            make.bottom.equalTo(weakSelf.leftTimeLabel.mas_top).offset(-5);
        }];
        
        [self.cacheProgress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(weakSelf.scheduleSlider);
            make.height.mas_equalTo(1);
            make.centerY.equalTo(weakSelf.scheduleSlider);
        }];
        
        
        
        
        
        
        
        
        
    }
    return self;
}



@end
