//
//  EvernoteNoteStore+SSPatch.h
//  EvernoteSDKPatch
//
//  Created by syshen on 8/5/13.
//  Copyright (c) 2013 syshen. All rights reserved.
//

#import "EvernoteNoteStore.h"

@interface EvernoteNoteStore (SSPatch)

- (void) getResourceThumbnailWithGuid:(EDAMGuid)guid
                                 size:(NSInteger)size
                              success:(void(^)(NSData *thmData))success
                              failure:(void(^)(NSError *error))error;

- (void) getNoteThumbnailWithGuid:(EDAMGuid)guid
                             size:(NSInteger)size
                          success:(void(^)(NSData *thmData))success
                          failure:(void(^)(NSError *error))error;

@end
