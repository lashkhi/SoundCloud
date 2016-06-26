//
//  SCCollectionViewCell.m
//  SoundCloud
//
//  Created by David Lashkhi on 19/06/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//

#import "SCCollectionViewCell.h"

@interface SCCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *displayImage;
@property (strong, nonatomic) NSNumber *albumId;
@property (strong, nonatomic) UIImage *image;
@end

@implementation SCCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setupCellWithImage:(UIImage *)image withId:(NSNumber *)albumId {
    if (image && albumId) {
        self.image = image;
        self.albumId = albumId;
        //[self hideImage:NO];
    } else {
        [self hideImage:YES];
    }
    
}

- (void)hideImage:(BOOL)hide {
    if (hide) {
        self.displayImage.image = [UIImage imageNamed:@"placeholder"];
    } else {
        self.displayImage.image = self.image;
    }
}

@end
