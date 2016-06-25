//
//  Album+CoreDataProperties.h
//  SoundCloud
//
//  Created by David Lashkhi on 22/06/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Album.h"

NS_ASSUME_NONNULL_BEGIN

@interface Album (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *coverURL;
@property (nullable, nonatomic, retain) NSString *imageStorageURL;
@property (nullable, nonatomic, retain) NSNumber *albumId;

@end

NS_ASSUME_NONNULL_END
