//
//  AudioEncode.h
//  AudioUtils
//
//  Created by jianqiangzhang on 2016/11/2.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AudioEncodeDelegate <NSObject>

- (void)encodeData:(NSData *)data error:(NSError*)error;

@end

@interface AudioEncode : NSObject

- (void)start;

- (void)stop;

@property (nonatomic, assign) id<AudioEncodeDelegate>delegate;

@end
