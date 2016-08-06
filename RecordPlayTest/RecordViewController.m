//
//  RecordViewController.m
//  RecordPlayTest
//
//  Created by David Swaintek on 8/5/16.
//  Copyright © 2016 David Swaintek. All rights reserved.
//

#import "RecordViewController.h"

@interface RecordViewController ()

@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _playButton.enabled = NO;
    _stopButton.enabled = NO;
    
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    NSString *soundFilePath = [docsDir stringByAppendingPathComponent:@"sound.caf"];
    NSLog(@"%@", soundFilePath);
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    NSDictionary *recordSettings  = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInt:AVAudioQualityMin],
                                     AVEncoderAudioQualityKey,
                                     [NSNumber numberWithInt:16],
                                     AVEncoderBitRateKey,
                                     [NSNumber numberWithInt:2],
                                     AVNumberOfChannelsKey,
                                     [NSNumber numberWithFloat:44100.0],
                                     AVSampleRateKey,
                                     nil];
    
    NSError *error = nil;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    _audioRecorder = [[AVAudioRecorder alloc]initWithURL:soundFileURL settings:recordSettings error:&error];
    
    if (error) {
        NSLog (@"error: %@", [error localizedDescription]);
    } else {
        [_audioRecorder prepareToRecord];
    }
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    _recordButton.enabled = YES;
    _stopButton.enabled = YES;
}

- (void) audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    NSLog(@"Decode error occurred");
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
}

- (void) audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error{
    NSLog(@"Encode error occurred");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)recordAudio:(id)sender {
    if (!_audioRecorder.recording) {
        _playButton.enabled = NO;
        _stopButton.enabled = YES;
        [_audioRecorder record];
    }
}

- (IBAction)playAudio:(id)sender {
    if (!_audioRecorder.recording) {
        _stopButton.enabled = YES;
        _recordButton.enabled = NO;
        
        NSError *error;
        
        _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:_audioRecorder.url error:&error];
        
        _audioPlayer.delegate = self;
        if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
        } else {
            [_audioPlayer play];
        }
    }
}

- (IBAction)stopAudio:(id)sender {
    _stopButton.enabled = NO;
    _playButton.enabled = YES;
    _recordButton.enabled = YES;
    
    if (_audioRecorder.recording){
        [_audioRecorder stop];
    } else if (_audioPlayer.playing) {
        [_audioPlayer stop];
    }
}
@end




























