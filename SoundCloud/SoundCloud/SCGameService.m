//
//  SCGameService.m
//  SoundCloud
//
//  Created by David Lashkhi on 26/06/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//

#import "SCGameService.h"
#import "SCAlbum.h"
#import "Const.h"

@interface SCGameService ()

@property (nonatomic, strong) NSMutableArray *selectedAlbums;
@property (nonatomic, strong) SCAlbum *previouslySelectedAlbum;
@property (nonatomic, strong) NSIndexPath *firstSelectedIndexPath;
@end

@implementation SCGameService

- (instancetype)init {
    if (self = [super init]) {
        self.cellsToReload = [NSMutableArray new];
        self.selectedAlbums = [NSMutableArray new];
        self.score = 0;
    }
    return self;
}


- (void)didSelectAlbum:(SCAlbum *)album atIndexPath:(NSIndexPath *)indexPath {
    if ([self.selectedAlbums containsObject:album]) {
        return;
    }
    if (self.firstSelectedIndexPath) {
        [self compareAlbums:album withIndexPath:(NSIndexPath *)indexPath];
    } else {
        self.previouslySelectedAlbum = album;
        self.firstSelectedIndexPath = indexPath;
        [self.cellsToReload removeAllObjects];
    }
}

- (void)compareAlbums:(SCAlbum *)album withIndexPath:(NSIndexPath *)indexPath {
    if ([album isEqual:self.previouslySelectedAlbum]) {
        [self pairFoundForAlbum:album atIndexPath:indexPath];
    } else {
        [self pairNotFoundAtIndexPath:indexPath];
    }
}

- (void)pairFoundForAlbum:(SCAlbum *)album atIndexPath:(NSIndexPath *)indexPath {
    [self.cellsToReload removeAllObjects];
    [self.selectedAlbums addObject:album];
    self.firstSelectedIndexPath = nil;
    self.score =self.score + 10;
    [self checkIfGameFinished];
}

- (void)pairNotFoundAtIndexPath:(NSIndexPath *)indexPath {
    [self.cellsToReload addObject:self.firstSelectedIndexPath];
    self.firstSelectedIndexPath = nil;
    self.previouslySelectedAlbum = nil;
    self.score = self.score - 5;
    [self.cellsToReload addObject:indexPath];
}

- (void)checkIfGameFinished {
    if (self.selectedAlbums.count == NumberOfCells/2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GameFinishedNotification object:nil];
    }
}

@end
