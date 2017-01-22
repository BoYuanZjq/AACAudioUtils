#import <Foundation/Foundation.h>

@interface OpenALAudioPlay : NSObject

+(id)sharePaly;
-(void)openAudioFromQueue:(uint8_t *)data dataSize:(size_t)dataSize samplerate:(int)samplerate channels:(int)channels aBit:(int)bit;;
-(void)stopSound;
@end
