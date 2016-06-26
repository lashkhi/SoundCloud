//
//  SCCollectionViewController.m
//  SoundCloud
//
//  Created by David Lashkhi on 19/06/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//

#import "SCCollectionViewController.h"
#import "SCCollectionViewCell.h"
#import "SCServiceManager.h"
#import "SCAlbum.h"
#import "SCGameService.h"

@interface SCCollectionViewController ()
@property (nonatomic, strong) SCServiceManager *serviceManager;
@property (nonatomic, strong) SCGameService *gameService;
@property (nonatomic, strong) NSArray *albums;
@property (nonatomic, strong) NSIndexPath *prevoiuslySelectedIndexPath;

@end

@implementation SCCollectionViewController

static NSString * const reuseIdentifier = @"SCCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.serviceManager = [SCServiceManager new];
        [self.serviceManager fetchDataForAlbumCovers:^(NSArray *albums) {
            self.albums = [self.serviceManager createRandomizedAlbumsArray:albums];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self startGame];
            });
        } failure:^(NSError *error) {
            //
        }];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return NumberOfCells;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SCCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (!self.albums) {
        [cell setupCellWithImage:nil withId:nil];
    } else {
        SCAlbum *album = self.albums[indexPath.row];
        NSData *retrievedData = [NSData dataWithContentsOfFile:album.imageStorageURL];
        [cell setupCellWithImage:[UIImage imageWithData:retrievedData] withId:album.albumId];
    }
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SCCollectionViewCell *cell = (SCCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [cell hideImage:NO];
    SCAlbum *album = self.albums[indexPath.row];
    [self.gameService didSelectAlbum:album atIndexPath:indexPath];

    dispatch_time_t waitTime = dispatch_time(DISPATCH_TIME_NOW, DelayForHidingAlbums);
    dispatch_after(waitTime, dispatch_get_main_queue(), ^{
        [self reloadCellsIfNeeded];
    });
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

- (void)startGame {
    self.gameService = [SCGameService new];
    self.gameService.albums = self.albums;
    [self.collectionView reloadData];
}

- (void)reloadCellsIfNeeded {
    if (self.gameService.cellsToReload.count >=2) {
        for (NSIndexPath *indexPath in self.gameService.cellsToReload) {
            SCCollectionViewCell *cell = (SCCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            [cell hideImage:YES];
        }
    }
}

@end
