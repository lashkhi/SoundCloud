//
//  SCCollectionViewController.m
//  SoundCloud
//
//  Created by David Lashkhi on 19/06/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//

#import "SCCollectionViewController.h"
#import "SCCollectionViewCell.h"
#import "SCHeaderCollectionReusableView.h"
#import "SCFooterCollectionReusableView.h"
#import "SCServiceManager.h"
#import "SCAlbum.h"
#import "SCGameService.h"

@interface SCCollectionViewController ()
@property (nonatomic, strong) SCServiceManager *serviceManager;
@property (nonatomic, strong) SCGameService *gameService;
@property (nonatomic, strong) NSArray *albums;
@property (nonatomic, assign) BOOL blockSelecting;
@property (nonatomic, weak) SCHeaderCollectionReusableView *timerView;
@property (nonatomic, weak) SCFooterCollectionReusableView *scoreView;
@property (nonatomic, assign) NSInteger previousTopScore;
@property (nonatomic, assign) NSInteger previousTopTime;

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
    [self createObservers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameFinished:) name:GameFinishedNotification object:nil];
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

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return !self.blockSelecting;
}

#pragma mark -  Timer

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView;
    if (kind == UICollectionElementKindSectionHeader) {
        self.timerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SCHeaderCollectionReusableView" forIndexPath:indexPath];
        reusableView = self.timerView;
    } else {
        self.scoreView =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"SCFooterCollectionReusableView" forIndexPath:indexPath];
        reusableView = self.scoreView;
    }
    return reusableView;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SCCollectionViewCell *cell = (SCCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [cell hideImage:NO];
    SCAlbum *album = self.albums[indexPath.row];
    [self.gameService didSelectAlbum:album atIndexPath:indexPath];
    [self scoreUp];
    [self reloadCellsIfNeeded];
}


- (void)startGame {
    self.gameService = [SCGameService new];
    self.gameService.albums = self.albums;
    [self startTimer];
    self.scoreView.scoreLabel.text = [@(0) stringValue];
    [self.collectionView reloadData];
}

- (void)restartGame {
    NSArray *albums = [self.albums copy];
    self.albums = nil;
    [self.collectionView reloadData];
    dispatch_time_t waitTime = dispatch_time(DISPATCH_TIME_NOW, DelayForHidingAlbums*NSEC_PER_SEC);
    dispatch_after(waitTime, dispatch_get_main_queue(), ^{
        self.albums = [self.serviceManager createRandomizedAlbumsArray:albums];
        [self startGame];
    });    
}

- (void)reloadCellsIfNeeded {
    if (self.gameService.cellsToReload.count >=2) {
        self.blockSelecting = YES;
        dispatch_time_t waitTime = dispatch_time(DISPATCH_TIME_NOW, DelayForHidingAlbums*NSEC_PER_SEC);
        dispatch_after(waitTime, dispatch_get_main_queue(), ^{
            for (NSIndexPath *indexPath in self.gameService.cellsToReload) {
                SCCollectionViewCell *cell = (SCCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                [cell hideImage:YES];
            }
            self.blockSelecting = NO;
        });
    }
}

- (void)startTimer {
    [self.timerView start];
}

- (void)scoreUp {
    NSInteger score = self.gameService.score;
    self.scoreView.scoreLabel.text = [@(score) stringValue];
}

- (void)calculateTopScore {
    if (self.previousTopTime < self.timerView.timerCount) {
        self.previousTopTime = self.timerView.timerCount;
        self.timerView.topTimerLabel.text = [@(self.previousTopTime) stringValue];
    }
    if (self.previousTopScore < self.gameService.score) {
        self.previousTopScore = self.gameService.score;
        self.scoreView.topScoreLabel.text = [@(self.previousTopScore) stringValue];
    }
}

- (void)gameFinished:(NSNotification *)notification {
    [self.timerView stopTimer];
    [self calculateTopScore];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Congratulations"
                                                                             message:@"You have finished game!"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self restartGame];
    }]; //You can use a block here to handle a press on this button
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
