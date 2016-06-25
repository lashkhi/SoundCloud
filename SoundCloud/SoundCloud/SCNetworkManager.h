//
//  SCNetworkManager.h
//  SoundCloud
//
//  Created by David Lashkhi on 19/06/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface SCNetworkManager : NSObject

typedef void (^ImageDidLoadBlock)(NSData *imageData);


- (void)fetchImageAdressesForURLString:(NSString *)urlString withSuccess:(void (^)(NSDictionary * jsonDictionary))success failure:(void (^)(NSError *error))failure;

- (void)fetchImageFromUrl:(NSString*)urlString onDidLoad:(ImageDidLoadBlock)onImageDidLoad;

@end
