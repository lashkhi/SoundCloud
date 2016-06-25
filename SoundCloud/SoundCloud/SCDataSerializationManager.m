//
//  SCDataSerializationManager.m
//  SoundCloud
//
//  Created by David Lashkhi on 21/06/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//

#import "SCDataSerializationManager.h"
#import "SCAlbum.h"

@implementation SCDataSerializationManager

- (void)createAlbumModelsFromJsonDictionary:(NSDictionary *)jsonDictionary withSuccess:(void (^)(NSArray * albumModels))success {
    NSMutableArray *albumModels = [NSMutableArray new];
    NSArray *tracks = jsonDictionary[@"tracks"];
    NSInteger albumId = 0;
    for (NSDictionary *track in tracks) {
        albumId ++;
        NSString *artworkURLstring = track[@"artwork_url"];
        SCAlbum * album = [self createAlbumWithArtworkURLstring:artworkURLstring andId:albumId];
        [albumModels addObject:album];
    }
    success(albumModels);
}

- (void)createAlbumCoversFromImage:(NSData *)imageData forAlbum:(SCAlbum *)album andCompletion:(SCCompletionBlock)completionBlock {
    NSString *imagePath = [self cachePathForFileName:[NSString stringWithFormat:@"image%@.jpg", album.albumId]];
    [imageData writeToFile:imagePath atomically:NO];
    album.imageStorageURL = imagePath;
    completionBlock();
}

- (NSString *)cachePathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name];
}

- (SCAlbum *)createAlbumWithArtworkURLstring:(NSString *)artworkURLstring andId:(NSInteger)albumId {
    SCAlbum *album = [SCAlbum new];
    album.coverURL = artworkURLstring;
    album.albumId = @(albumId);
    return album;
}

@end
