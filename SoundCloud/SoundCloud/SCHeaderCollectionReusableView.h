//
//  SCHeaderCollectionReusableView.h
//  SoundCloud
//
//  Created by David Lashkhi on 19/06/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCHeaderCollectionReusableView : UICollectionReusableView

@property (assign, nonatomic) NSInteger timerCount;
@property (weak, nonatomic) IBOutlet UILabel *topTimerLabel;

- (void)start;
- (void)stopTimer;

@end
