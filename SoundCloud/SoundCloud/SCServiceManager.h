//
//  SCServiceManager.h
//  SoundCloud
//
//  Created by David Lashkhi on 21/06/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Const.h"

@interface SCServiceManager : NSObject

- (void)fetchDataForAlbumCovers:(void (^)(NSArray * albums))success failure:(void (^)(NSError *error))failure;

- (NSArray *)createRandomizedAlbumsArray:(NSArray *)albums;

@end
