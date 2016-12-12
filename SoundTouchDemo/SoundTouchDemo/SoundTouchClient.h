//
//  SoundTouchObj.m
//  SoundTouchDemo
//
//  Created by chuliangliang on 14-5-19.
//  Copyright (c) 2014年 ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recorder.h"
#import "SoundTouchOperation.h"

@protocol SoundTouchClientDelegate <NSObject>

- (void)saveFileSuccess;

@end


@interface SoundTouchClient : NSObject <SoundTouchOperationDelegate>
{
    Recorder *recorder;
    NSMutableArray *recordingQueue;
    SoundTouchOperation *soundTouchOperation;
    NSOperationQueue *opetaionQueue;
}

@property (nonatomic, assign) id<SoundTouchClientDelegate> delegate;


- (void)start;

- (void)stop;

- (NSArray *)getAudioData;
@end
