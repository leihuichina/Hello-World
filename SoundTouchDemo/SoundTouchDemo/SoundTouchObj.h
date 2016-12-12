//
//  SoundTouchObj.m
//  SoundTouchDemo
//
//  Created by chuliangliang on 14-5-19.
//  Copyright (c) 2014年 ios. All rights reserved.
//

@class SoundTouchObj;
@protocol SoundTouchObjDelegate <NSObject>

- (void)didSaveAndPlay;

@end

#import <Foundation/Foundation.h>


@interface SoundTouchObj : NSObject
@property (nonatomic,retain)NSArray *dataArr;
@property (nonatomic,assign)id <SoundTouchObjDelegate> delegate;
- (void)updataAudioSampleRate:(int)sampleRate tempoChangeValue:(int)tempoChange pitchSemiTones:(int)pitch rateChange:(int)rate;
@end
