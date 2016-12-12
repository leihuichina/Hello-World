//
//  SoundTouchObj.m
//  SoundTouchDemo
//
//  Created by chuliangliang on 14-5-19.
//  Copyright (c) 2014年 ios. All rights reserved.
//
#import <AudioToolbox/AudioToolbox.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#define kNumberAudioQueueBuffers 3
#define kBufferDurationSeconds 0.1f


@interface Recorder : NSObject
{
    AudioQueueRef				_audioQueue;
    AudioQueueBufferRef			_audioBuffers[kNumberAudioQueueBuffers];
    AudioStreamBasicDescription	_recordFormat;
    
}

@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, assign) NSMutableArray *recordQueue;


- (void) startRecording;
- (void) stopRecording;


@end
