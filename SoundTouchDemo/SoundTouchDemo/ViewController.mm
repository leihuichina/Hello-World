//
//  SoundTouchObj.m
//  SoundTouchDemo
//
//  Created by chuliangliang on 14-5-19.
//  Copyright (c) 2014年 ios. All rights reserved.
//

#import "ViewController.h"
#import "SoundTouchClient.h"

@interface ViewController () <AVAudioPlayerDelegate, SoundTouchClientDelegate>
{
    SoundTouchClient *soundTouchClient;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    sayBeginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sayBeginBtn.backgroundColor = [UIColor redColor];
    [sayBeginBtn setTitle:@"开始录音" forState:UIControlStateNormal];
    sayBeginBtn.frame = CGRectMake(10, screenRect.size.height-60, 300, 30);
    [sayBeginBtn addTarget:self action:@selector(buttonSayBegin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sayBeginBtn];
    
    sayEndBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sayEndBtn.backgroundColor = [UIColor greenColor];
    [sayEndBtn setTitle:@"停止录音" forState:UIControlStateNormal];
    sayEndBtn.frame = CGRectMake(10, screenRect.size.height-60, 300, 30);
    [sayEndBtn addTarget:self action:@selector(buttonSayEnd:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sayEndBtn];
    sayEndBtn.hidden = YES;
    
    playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.backgroundColor = [UIColor blueColor];
    [playBtn setTitle:@"播放效果" forState:UIControlStateNormal];
    playBtn.frame = CGRectMake(10, screenRect.size.height-60, 300, 30);
    [playBtn addTarget:self action:@selector(buttonPlay:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
    playBtn.hidden = YES;
    
    UIButton *audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    audioBtn.backgroundColor = [UIColor blueColor];
    [audioBtn setTitle:@"播放文件" forState:UIControlStateNormal];
    audioBtn.frame = CGRectMake(10, screenRect.size.height-110, 300, 30);
    [audioBtn addTarget:self action:@selector(buttonPlayFlie:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:audioBtn];
    
    audioDataArray= [[NSMutableArray alloc] init];
    
    
    soundTouchClient = [[SoundTouchClient alloc] init];
    soundTouchClient.delegate = self;
 
    _soundTouchObj = [[SoundTouchObj alloc] init];
    [_soundTouchObj setDelegate:self];

    tempoChangeNum = 0;
    pitchSemiTonesNum= 0;
    rateChangeNum = 0;
    
    timeManager = [DotimeManage DefaultManage];
    [timeManager setDelegate:self];
    
    [self.actView stopAnimating];
    [self.actView setHidden:YES];
}

//处理音频文件
- (void)buttonPlayFlie:(UIButton *)btn
{
    [self.actView setHidden:NO];
    [self.actView startAnimating];

    if (audioPalyer) {
        [audioPalyer stop];
    }
    //注意: 由于未做多线程处理请耐心等待,因为处理的时间长度和传入的音频采样率相关
    NSLog(@"播放录音文件");
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"第一夫人-铃声" ofType:@"wav"];

    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (!isExist) {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"文件不存在" message:@"由于一些原因未能做多多格式兼容 请手动导入一个WAV格式的音频" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerView show];
        [alerView release];
        return;
    }
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    NSArray *Arr = @[data];
    _soundTouchObj.dataArr = Arr;
    [_soundTouchObj updataAudioSampleRate:44100 tempoChangeValue:tempoChangeNum pitchSemiTones:pitchSemiTonesNum rateChange:rateChangeNum];

    
}

 //时间改变
- (void)TimerActionValueChange:(int)time
{
    
    
    if (time == 30) {
        
        [timeManager stopTimer];
        
        sayBeginBtn.hidden = YES;
        sayEndBtn.hidden = YES;
        playBtn.hidden = NO;
        
        [soundTouchClient stop];
        [audioDataArray addObjectsFromArray:[soundTouchClient getAudioData]];
    }
    if (time > 30) time = 30;
    
    self.countDownLabel.text = [NSString stringWithFormat:@"时间: %02d",time];

}

- (void)buttonSayBegin:(id)sender
{
    sayBeginBtn.hidden = YES;
    sayEndBtn.hidden = NO;
    playBtn.hidden = YES;
    
    [timeManager setTimeValue:30];
    [timeManager startTime];
    
    [soundTouchClient start];
}

- (void)buttonSayEnd:(id)sender
{
    [timeManager stopTimer];
    
    sayBeginBtn.hidden = YES;
    sayEndBtn.hidden = YES;
    playBtn.hidden = NO;
  
    [soundTouchClient stop];
    
    [audioDataArray addObjectsFromArray:[soundTouchClient getAudioData]];
}

- (void)saveFileSuccess
{
}

- (void)playWave
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"soundtouch.wav"];
    
    if (audioPalyer) {
        [audioPalyer release];
        audioPalyer = nil;
    }
    
    NSURL *url = [NSURL URLWithString:filePath];
    audioPalyer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    audioPalyer.delegate = self;
    [audioPalyer prepareToPlay];
    [audioPalyer play];
}


- (void)buttonPlay:(UIButton *)sender
{
    
    [sender setEnabled:NO];
    
    NSLog(@"播放音效");
    
    
    [self.actView setHidden:NO];
    [self.actView startAnimating];

    _soundTouchObj.dataArr = audioDataArray;
    [_soundTouchObj updataAudioSampleRate:8000 tempoChangeValue:tempoChangeNum pitchSemiTones:pitchSemiTonesNum rateChange:rateChangeNum];
    
}

- (void)didSaveAndPlay
{
    [self playWave];
    
    [self.actView stopAnimating];
    [self.actView setHidden:YES];

}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [playBtn setEnabled:YES];
        NSLog(@"回复音效按钮");

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_tempoChangeLabel release];
    [_tempoChangeSlide release];
    [_pitchSemitonesLabel release];
    [_pitchSemitonesSlide release];
    [_rateChangeLabel release];
    [_rateChangeSlide release];
    [_countDownLabel release];
    [_actView release];
    [super dealloc];
    [soundTouchClient release];
    [audioPalyer release];
}

- (void)viewDidUnload {
    [self setTempoChangeLabel:nil];
    [self setTempoChangeSlide:nil];
    [self setPitchSemitonesLabel:nil];
    [self setPitchSemitonesSlide:nil];
    [self setRateChangeLabel:nil];
    [self setRateChangeSlide:nil];
    [self setCountDownLabel:nil];
    [self setActView:nil];
    [super viewDidUnload];
}
- (IBAction)tempoChangeValue:(UISlider *)sender {
    int value = (int)sender.value;
    NSLog(@"tempoChangeValue : %d",value);
    self.tempoChangeLabel.text = [NSString stringWithFormat:@"setTempoChange: %d",value];
    tempoChangeNum = value;
}


- (IBAction)pitchSemitonesValue:(UISlider *)sender {
    int value = (int)sender.value;
    NSLog(@"pitchSemitonesValue : %d",value);
    self.pitchSemitonesLabel.text = [NSString stringWithFormat:@"setPitchSemiTones: %d",value];
    pitchSemiTonesNum = value;

}
- (IBAction)rateChangeValue:(UISlider *)sender {
    
    int value = (int)sender.value;
    NSLog(@"rateChangeValue : %d",value);
    self.rateChangeLabel.text = [NSString stringWithFormat:@"setRateChange: %d",value];
    rateChangeNum = value;

}
@end
