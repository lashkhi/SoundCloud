//
//  SCFooterCollectionReusableView.h
//  SoundCloud
//
//  Created by David Lashkhi on 19/06/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCFooterCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *topScoreLabel;

@end
