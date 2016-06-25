//
//  SCNetworkManager.m
//  SoundCloud
//
//  Created by David Lashkhi on 19/06/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//

#import "SCNetworkManager.h"

@interface SCNetworkManager ()
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@end

@implementation SCNetworkManager

#pragma mark Image downloader


- (void)fetchImageAdressesForURLString:(NSString *)urlString withSuccess:(void (^)(NSDictionary * jsonDictionary))success failure:(void (^)(NSError *error))failure {
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    self.dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if (jsonDictionary) {
                success (jsonDictionary);
            } else {
                failure(error);// no downloading
            }
            
        } else if (error) {
            //handle error
        }
    }];
    [self.dataTask resume];
}


-(void)fetchImageFromUrl:(NSString*)urlString onDidLoad:(ImageDidLoadBlock)onImageDidLoad {
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:URL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSData *imageData = [NSData dataWithContentsOfURL:location];
        onImageDidLoad(imageData);
    }];
    [task resume];
}

@end
