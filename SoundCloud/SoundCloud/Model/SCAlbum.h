//
//  SCAlbum.h
//  SoundCloud
//
//  Created by David Lashkhi on 22/06/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCAlbum : NSObject

@property (nonatomic, strong) NSString *coverURL;
@property (nonatomic, strong) NSString *imageStorageURL;
@property (nonatomic, strong) NSNumber *albumId;

@end
