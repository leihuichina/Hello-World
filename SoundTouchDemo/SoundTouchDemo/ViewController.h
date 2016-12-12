//
//  SoundTouchObj.m
//  SoundTouchDemo
//
//  Created by chuliangliang on 14-5-19.
//  Copyright (c) 2014年 ios. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SoundTouchObj.h"
#import "DotimeManage.h"


@interface ViewController : UIViewController<SoundTouchObjDelegate,DotimeManageDelegate>
{
    UIButton *sayBeginBtn;
    UIButton *sayEndBtn;
    UIButton *playBtn;
    
    AVAudioPlayer *audioPalyer;

    NSMutableArray *audioDataArray;
    SoundTouchObj *_soundTouchObj;
    
    /*
     * 初始值 均为0
     */
    int tempoChangeNum;
    int pitchSemiTonesNum;
    int rateChangeNum;
    DotimeManage *timeManager;
}

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *actView;

@property (retain, nonatomic) IBOutlet UILabel *tempoChangeLabel;
@property (retain, nonatomic) IBOutlet UISlider *tempoChangeSlide;
- (IBAction)tempoChangeValue:(id)sender;


@property (retain, nonatomic) IBOutlet UILabel *pitchSemitonesLabel;
@property (retain, nonatomic) IBOutlet UISlider *pitchSemitonesSlide;
- (IBAction)pitchSemitonesValue:(id)sender;


@property (retain, nonatomic) IBOutlet UILabel *rateChangeLabel;
@property (retain, nonatomic) IBOutlet UISlider *rateChangeSlide;
- (IBAction)rateChangeValue:(id)sender;


@property (retain, nonatomic) IBOutlet UILabel *countDownLabel;
@end
