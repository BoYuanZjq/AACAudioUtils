//
//  AudioDecoder.m
//  AudioUtils
//
//  Created by jianqiangzhang on 2016/11/2.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import "AudioDecoder.h"
#include <stdio.h>
#include <memory.h>
#include "neaacdec.h"
#import "OpenALAudioPlay.h"
#import "pluginaac.h"

@interface AudioDecoder()
{
    
    OpenALAudioPlay *audioPlay;
  
    aac_dec_t decoder;
    uint32_t		aac_sample_hz_;
    uint8_t			aac_channels_;
    int				a_cache_len_;
}
@end

@implementation AudioDecoder

- (instancetype)init
{
    self = [super init];
    if (self) {
        audioPlay = [OpenALAudioPlay sharePaly];
    }
    return self;
}

- (void)sendData:(NSData*)audioData {
    if (!audioData || audioData.length == 0) {
        return;
    }
     unsigned char *inbuf =  (unsigned char*)[audioData bytes];
    if (decoder == NULL) {
        decoder = aac_decoder_open(inbuf, audioData.length, &aac_channels_, &aac_sample_hz_);
        if (aac_channels_ == 0)
            aac_channels_ = 1;
    }
    unsigned int outlen = 0;
    uint8_t	audio_cache_[8192];
    if (aac_decoder_decode_frame(decoder, inbuf, audioData.length, audio_cache_+				a_cache_len_, &outlen) > 0) {
        [audioPlay openAudioFromQueue:audio_cache_ dataSize:outlen samplerate:aac_sample_hz_ channels:aac_channels_ aBit:16];
    }
}

@end
