//
//  ViewController.m
//  AudioUtils
//
//  Created by jianqiangzhang on 2016/11/2.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import "ViewController.h"
#import "AudioEncode.h"
#import "AudioDecoder.h"

@interface ViewController ()<AudioEncodeDelegate>
{
    AudioEncode *audioEncode;
    AudioDecoder *audioDecoder;
}
@property (nonatomic) int channelCount;
@property (nonatomic) int sampleRate;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"开始" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 100, 50);
    button.center= self.view.center;
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    audioEncode = [[AudioEncode alloc] init];
    audioEncode.delegate = self;
    
    audioDecoder = [[AudioDecoder alloc] init];

}



- (void)buttonEvent:(UIButton*)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setTitle:@"关闭" forState:UIControlStateNormal];
        [audioEncode start];
    }else{
        [sender setTitle:@"开始" forState:UIControlStateNormal];
         [audioEncode stop];
    }
}
#pragma mark - 
- (void)encodeData:(NSData *)data error:(NSError*)error {
     NSLog(@"Audio data (%lu):%@", (unsigned long)data.length,data.description);
    if (audioDecoder && !error) {
        [audioDecoder sendData:data];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
