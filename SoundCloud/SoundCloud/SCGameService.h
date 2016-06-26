//
//  SCGameService.h
//  SoundCloud
//
//  Created by David Lashkhi on 26/06/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SCAlbum;

@interface SCGameService : NSObject

@property (nonatomic, strong) NSArray *albums;
@property (nonatomic, strong) NSMutableArray *cellsToReload;
@property (nonatomic, assign) NSInteger score;

- (void)didSelectAlbum:(SCAlbum *)album atIndexPath:(NSIndexPath *)indexPath;

@end
