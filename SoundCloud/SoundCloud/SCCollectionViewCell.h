//
//  SCCollectionViewCell.h
//  SoundCloud
//
//  Created by David Lashkhi on 19/06/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCCollectionViewCell : UICollectionViewCell
@property (assign, nonatomic) BOOL isHidden;

- (void)setupCellWithImage:(UIImage *)image withId:(NSNumber *)albumId;
- (void)hideImage:(BOOL)hide;

@end
