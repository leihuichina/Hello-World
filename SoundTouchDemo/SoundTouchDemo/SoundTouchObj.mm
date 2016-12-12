//
//  SoundTouchObj.m
//  SoundTouchDemo
//
//  Created by chuliangliang on 14-5-19.
//  Copyright (c) 2014年 ios. All rights reserved.
//

#import "SoundTouchObj.h"
#include "SoundTouch.h"
#include "WaveHeader.h"

using namespace soundtouch;


@implementation SoundTouchObj

- (void)updataAudioSampleRate:(int)sampleRate tempoChangeValue:(int)tempoChange pitchSemiTones:(int)pitch rateChange:(int)rate

{
    soundtouch::SoundTouch mSoundTouch;
    mSoundTouch.setSampleRate(sampleRate); //setSampleRate
    mSoundTouch.setChannels(1);       //设置声音的声道
    mSoundTouch.setTempoChange(tempoChange);    //这个就是传说中的变速不变调
    mSoundTouch.setPitchSemiTones(pitch); //设置声音的pitch (集音高变化semi-tones相比原来的音调) //男: -8 女:8
    mSoundTouch.setRateChange(rate);     //设置声音的速率
    mSoundTouch.setSetting(SETTING_SEQUENCE_MS, 40);
    mSoundTouch.setSetting(SETTING_SEEKWINDOW_MS, 15); //寻找帧长
    mSoundTouch.setSetting(SETTING_OVERLAP_MS, 6);  //重叠帧长

    
    NSMutableData *soundTouchDatas = [[NSMutableData alloc] init];
    
    for (int i = 0; i < self.dataArr.count; i++) {
        
        NSData *audioData = [self.dataArr objectAtIndex:i];
        
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

        }
    }
    
    
    NSMutableData *wavDatas = [[NSMutableData alloc] init];
    int fileLength = soundTouchDatas.length;
    void *header = createWaveHeader(fileLength, 1, sampleRate, 16);
    [wavDatas appendBytes:header length:44];
    [wavDatas appendData:soundTouchDatas];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"soundtouch.wav"];
    BOOL isSave = [wavDatas writeToFile:filePath atomically:YES];
    [soundTouchDatas release];
    [wavDatas release];
    if (isSave) {
        if ([_delegate respondsToSelector:@selector(didSaveAndPlay)]) {
            [_delegate didSaveAndPlay];
        }
    }
}

@end
