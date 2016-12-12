//
//  SoundTouchObj.m
//  SoundTouchDemo
//
//  Created by chuliangliang on 14-5-19.
//  Copyright (c) 2014年 ios. All rights reserved.
//

#import "SoundTouchClient.h"

@implementation SoundTouchClient

@synthesize delegate = _delegate;

- (id)init
{
    self = [super init];
    if (self) {
        recordingQueue = [[NSMutableArray alloc] init];
        opetaionQueue = [[NSOperationQueue alloc] init];
        recorder = [[Recorder alloc] init];
        recorder.recordQueue = recordingQueue;
    }
    return self;
}
- (NSArray *)getAudioData
{
    return  recorder.recordQueue;
}


- (void)start
{
    [recordingQueue removeAllObjects];
    [recorder startRecording];
}

- (void)stop
{
    [recorder stopRecording];
}


- (void)onSaveFileEnd
{
    [_delegate saveFileSuccess];
}


- (void)dealloc
{
    [super dealloc];
    [recorder release];
    [soundTouchOperation release];
    [recordingQueue release];
    [opetaionQueue release];
}

@end
