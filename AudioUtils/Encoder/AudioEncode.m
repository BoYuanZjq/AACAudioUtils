//
//  AudioEncode.m
//  AudioUtils
//
//  Created by jianqiangzhang on 2016/11/2.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import "AudioEncode.h"
#import <AVFoundation/AVFoundation.h>
#import "AACEncoder.h"

@interface AudioEncode()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AACEncoder                 *aacEncoder;

// 负责输如何输出设备之间的数据传递
@property (nonatomic, strong) AVCaptureSession           *session;
@property (nonatomic, strong) dispatch_queue_t           AudioQueue;
@property (nonatomic, strong) AVCaptureConnection        *audioConnection;

@property (nonatomic, strong) NSMutableData              *data;

@end

@implementation AudioEncode

- (instancetype)init
{
    self = [super init];
    if (self) {
        _data = [NSMutableData new];
        //初始化AVCaptureSession
        _session = [AVCaptureSession new];
        [self setupAudioCapture];
    }
    return self;
}
#pragma mark - 设置音频
- (void)setupAudioCapture {
    
    self.aacEncoder = [AACEncoder new];
    
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    
    NSError *error = nil;
    
    AVCaptureDeviceInput *audioInput = [[AVCaptureDeviceInput alloc]initWithDevice:audioDevice error:&error];
    
    if (error) {
        
        NSLog(@"Error getting audio input device:%@",error.description);
    }
    
    if ([self.session canAddInput:audioInput]) {
        
        [self.session addInput:audioInput];
    }
    
    self.AudioQueue = dispatch_queue_create("Audio Capture Queue", DISPATCH_QUEUE_SERIAL);
    
    AVCaptureAudioDataOutput *audioOutput = [AVCaptureAudioDataOutput new];
    [audioOutput setSampleBufferDelegate:self queue:self.AudioQueue];
    
    if ([self.session canAddOutput:audioOutput]) {
        
        [self.session addOutput:audioOutput];
    }
    
    self.audioConnection = [audioOutput connectionWithMediaType:AVMediaTypeAudio];
}
#pragma mark - 
#pragma mark - 实现 AVCaptureOutputDelegate：
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if (connection == _audioConnection) {  // Audio
        
        //NSLog(@"这里获得audio sampleBuffer，做进一步处理（编码AAC）");
        [self.aacEncoder encodeSampleBuffer:sampleBuffer completionBlock:^(NSData *encodedData, NSError *error) {
            
            if (encodedData) {
                if (_delegate) {
                    [_delegate encodeData:encodedData error:error];
                }
               // NSLog(@"Audio data (%lu):%@", (unsigned long)encodedData.length,encodedData.description);
#pragma mark -  音频数据(encodedData)
                [self.data appendData:encodedData];
            }else {
                
                NSLog(@"Error encoding AAC: %@", error);
                
            }
            
        }];
        
    }
}
- (void)start {
    if (self.session) {
        [self.session commitConfiguration];
        [self.session startRunning];
    }
}

- (void)stop {
    if (self.session) {
         [self.session stopRunning];
    }
    // 获取程序Documents目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSMutableString * path = [[NSMutableString alloc]initWithString:documentsDirectory];
    [path appendString:@"/AACFile"];
    
    [_data writeToFile:path atomically:YES];
}

@end
