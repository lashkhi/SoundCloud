//
//  SCServiceManager.m
//  SoundCloud
//
//  Created by David Lashkhi on 21/06/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//

#import "SCServiceManager.h"
#import "SCNetworkManager.h"
#import "SCDataSerializationManager.h"
#import "SCAlbum.h"


@interface SCServiceManager ()

@property (nonatomic, strong) SCNetworkManager *networkManager;
@property (nonatomic, strong) SCDataSerializationManager *dataSerializationManager;

@end

@implementation SCServiceManager

- (instancetype)init {
    if (self = [super init]) {
        _networkManager = [SCNetworkManager new];
        _dataSerializationManager = [SCDataSerializationManager new];
    }
    return self;
}



- (void)fetchDataForAlbumCovers:(void (^)(NSArray * albums))success failure:(void (^)(NSError *error))failure {
    [self.networkManager fetchImageAdressesForURLString:SCAPIURL withSuccess:^(NSDictionary *jsonDictionary) {
        [self serializeAlbumCoverModelsFromJsonDictionary:jsonDictionary withSuccess:^(NSArray *albums) {
            if (success) {
                success(albums);
            }
        }];
        
    } failure:^(NSError *error) {
        //
    }];

}

- (void)serializeAlbumCoverModelsFromJsonDictionary:(NSDictionary *)jsonDictionary withSuccess:(void (^)(NSArray * albums))success {
    [self.dataSerializationManager createAlbumModelsFromJsonDictionary:jsonDictionary withSuccess:^(NSArray *albums) {
        [self fetchImageForAlbumModels:albums withSuccess:^(NSArray *albums) {
            if (success) {
                success(albums);
            }
        }];
    }];
}

- (void)fetchImageForAlbumModels:(NSArray *)albumModels withSuccess:(void (^)(NSArray * albums))success {
    dispatch_group_t downloadGroup = dispatch_group_create();
    for (SCAlbum *album in albumModels) {
        dispatch_group_enter(downloadGroup);
        [self.networkManager fetchImageFromUrl:album.coverURL onDidLoad:^(NSData *imageData) {
            [self.dataSerializationManager createAlbumCoversFromImage:imageData
                                                             forAlbum:album
                                                        andCompletion:^{
                                                            dispatch_group_leave(downloadGroup);
                                                        }];
        }];
    }
    dispatch_group_notify(downloadGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (success) {
            success(albumModels);
        }
    });
}


#pragma mark - Randomize Albums Array

- (NSArray *)createRandomizedAlbumsArray:(NSArray *)albums {
    NSInteger albumCovers = albums.count * 2;
    NSInteger itemsCountToLeave = albumCovers - NumberOfCells;
    NSArray *randomizedArray;
    if (albumCovers > NumberOfCells) {
        NSMutableArray *albumCoverCutted = [[albums subarrayWithRange: NSMakeRange(0, itemsCountToLeave)] mutableCopy];
        [albumCoverCutted addObjectsFromArray:albumCoverCutted];
        for (NSInteger i = 0; i < NumberOfCells; ++i) {
            NSInteger nElements = NumberOfCells - i;
            NSInteger n = (arc4random() % nElements) + i;
            [albumCoverCutted exchangeObjectAtIndex:i withObjectAtIndex:n];
            randomizedArray = albumCoverCutted;
        }
    }
    return randomizedArray;
}



@end
