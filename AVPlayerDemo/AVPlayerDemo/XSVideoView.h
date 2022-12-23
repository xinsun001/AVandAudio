//
//  XSVideoView.h
//  mineDemo
//
//  Created by xin sun on 2018/11/7.
//  Copyright © 2018年 xin sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XSVideoView : UIView


@property(nonatomic,strong)UIView *videoBgView;

@property(nonatomic,strong)UIView *topBgview;
@property(nonatomic,strong)UIButton *videoBackButton;
@property(nonatomic,strong)UILabel *topTitleLabel;


@property(nonatomic,copy)void(^videoBackButtonBlock)(void);

@property(nonatomic,strong)UIButton *playerButton;
@property(nonatomic,copy)void(^playerButtonBlock)(void);


@property(nonatomic,strong)UIView *bottomView;

@property(nonatomic,strong)UIProgressView *cacheProgress;
@property(nonatomic,strong)UISlider *scheduleSlider;
@property(nonatomic,copy)void(^sliderChangeBlock)(void);
@property(nonatomic,copy)void(^sliderInsideBlock)(void);


@property(nonatomic,strong)UILabel *leftTimeLabel;
@property(nonatomic,strong)UILabel *rightTimeLabel;

@property(nonatomic,strong)UIButton *screenButton;
@property(nonatomic,copy)void(^screenButtonBlock)(void);


-(void)playerButtonAction;

-(void)screenButtonAction;





@end
