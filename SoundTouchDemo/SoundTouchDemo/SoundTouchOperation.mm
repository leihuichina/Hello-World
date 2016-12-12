//
//  SoundTouchObj.m
//  SoundTouchDemo
//
//  Created by chuliangliang on 14-5-19.
//  Copyright (c) 2014年 ios. All rights reserved.
//

#import "SoundTouchOperation.h"
#import "SoundTouch.h"
#import "WaveHeader.h"

@implementation SoundTouchOperation

@synthesize delegate = _delegate;


- (void)main
{
    /* 1.男: {setTempoChange:0   setPitchSemiTones: -8 setRateChange 0}
     * 2.女: {setTempoChange:12   setPitchSemiTones: 12 setRateChange 0}
     * 3.机器人:
     *
     *
     *
     *****/
    
    soundtouch::SoundTouch mSoundTouch;
    mSoundTouch.setSampleRate(8000); //setSampleRate
    mSoundTouch.setChannels(1);       //设置声音的声道
    mSoundTouch.setTempoChange(12);    //这个就是传说中的变速不变调
    mSoundTouch.setPitchSemiTones(12); //设置声音的pitch (集音高变化semi-tones相比原来的音调) //男: -8 女:8
    mSoundTouch.setRateChange(0);     //设置声音的速率
    mSoundTouch.setSetting(SETTING_SEQUENCE_MS, 40);
    mSoundTouch.setSetting(SETTING_SEEKWINDOW_MS, 16);
    mSoundTouch.setSetting(SETTING_OVERLAP_MS, 8);
    
    NSMutableData *soundTouchDatas = [[NSMutableData alloc] init];
    
    while (true) {
        
        NSData *audioData = nil;
        @synchronized(_recordQueue){// begin @synchronized
            
            if (_recordQueue.count > 0) {
                // 获取队头数据
                audioData = [[_recordQueue objectAtIndex:0] retain];
                [_recordQueue removeObjectAtIndex:0];
                NSLog(@"获取队头数据_recordQueue");
            }
        }// end @synchronized
        
        if (audioData != nil) {
            
            char *pcmData = (char *)audioData.bytes;
            int pcmSize = audioData.length;
            int nSamples = pcmSize / 2;
            
            mSoundTouch.putSamples((short *)pcmData, nSamples);
            
            short *samples = new short[pcmSize];
            int numSamples = 0;            
            do {
                
                memset(samples, 0, pcmSize);
                //short samples[nSamples];
                numSamples = mSoundTouch.receiveSamples(samples, pcmSize);
                [soundTouchDatas appendBytes:samples length:numSamples*2];
                
            } while (numSamples > 0);
            
            delete [] samples;
            
            [audioData release];
            
        }else{
            if (_setToStopped) {
                NSLog(@"break");
                break;
            }else{
                [NSThread sleepForTimeInterval:0.05];
                NSLog(@"sleep");
            }
        }
        
    }
    
    NSMutableData *wavDatas = [[NSMutableData alloc] init];
    
    int fileLength = soundTouchDatas.length;
    void *header = createWaveHeader(fileLength, 1, 8000, 16);
    [wavDatas appendBytes:header length:44];
    
    [wavDatas appendData:soundTouchDatas];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"soundtouch.wav"];
    [wavDatas writeToFile:filePath atomically:YES];
    
    [soundTouchDatas release];
    [wavDatas release];
    
    [_delegate onSaveFileEnd];
}


@end
