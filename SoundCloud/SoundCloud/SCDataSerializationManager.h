//
//  SCDataSerializationManager.h
//  SoundCloud
//
//  Created by David Lashkhi on 21/06/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class SCAlbum;

typedef void (^SCCompletionBlock)();

@interface SCDataSerializationManager : NSObject

- (void)createAlbumModelsFromJsonDictionary:(NSDictionary *)jsonDictionary withSuccess:(void (^)(NSArray * albumModels))success;

- (void)createAlbumCoversFromImage:(NSData *)imageData forAlbum:(SCAlbum *)album andCompletion:(SCCompletionBlock)completionBlock;
@end
