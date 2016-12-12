//
//  SoundTouchObj.m
//  SoundTouchDemo
//
//  Created by chuliangliang on 14-5-19.
//  Copyright (c) 2014年 ios. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SoundTouchOperationDelegate <NSObject>

- (void) onSaveFileEnd;

@end


@interface SoundTouchOperation : NSOperation

@property (nonatomic, assign) NSMutableArray *recordQueue;
@property (nonatomic, assign) BOOL setToStopped;
@property (nonatomic, assign) id<SoundTouchOperationDelegate> delegate;

@end
