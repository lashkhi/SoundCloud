//
//  SCHeaderCollectionReusableView.m
//  SoundCloud
//
//  Created by David Lashkhi on 19/06/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//

#import "SCHeaderCollectionReusableView.h"

@interface SCHeaderCollectionReusableView ()
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger timerCount;
@end

@implementation SCHeaderCollectionReusableView

- (void)start {
    self.timerCount = 0;
     self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(increaseTimerCount) userInfo:nil repeats:YES];
}

- (void)increaseTimerCount
{
    self.timerCount++;
    self.timerLabel.text = [@(self.timerCount) stringValue];
}

- (void)stopTimer {
    [self.timer invalidate];
}

@end
