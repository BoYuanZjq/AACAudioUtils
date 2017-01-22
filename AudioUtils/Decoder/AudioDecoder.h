//
//  AudioDecoder.h
//  AudioUtils
//
//  Created by jianqiangzhang on 2016/11/2.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioDecoder : NSObject

- (void)sendData:(NSData*)audioData;

@end
