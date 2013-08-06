//
//  EvernoteNoteStore+SSPatch.m
//  EvernoteSDKPatch
//
//  Created by syshen on 8/5/13.
//  Copyright (c) 2013 syshen. All rights reserved.
//

#import "EvernoteNoteStore+SSPatch.h"
#import <objc/runtime.h>

@interface SSEvernoteHelper : NSObject  <NSURLConnectionDataDelegate, NSURLConnectionDelegate>
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, copy) void (^onComplete)(NSError *error, NSData *data);
@end

@implementation SSEvernoteHelper

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
  if (httpResponse.statusCode != 200) {
    
    NSAssert(self.onComplete, @"You need to specify the completion handler");
    self.onComplete([NSError errorWithDomain:@"" code:-1 userInfo:@{@"httpStatus": @(httpResponse.statusCode)}], nil);
    [connection cancel];
    self.data = nil;
  }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  if (!self.data) {
    self.data = [NSMutableData data];
  }
  
  [self.data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  NSAssert(self.onComplete, @"You need to specify the completion handler");
  self.onComplete(error, nil);
  self.data = nil;
  [connection cancel];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  NSAssert(self.onComplete, @"You need to specify the completion handler");
  if (self.data) {
    self.onComplete(nil, self.data);
    self.data = nil;
  } else {
    self.onComplete(nil, nil);
  }
}

@end
@interface EvernoteNoteStore (Private)
@property (nonatomic, readwrite) SSEvernoteHelper *helper;
@end

@implementation EvernoteNoteStore (Private)

static NSString * const kHelperKey = @"helperKey";

- (void) setHelper:(SSEvernoteHelper *)helper {
  objc_setAssociatedObject(self, &kHelperKey, helper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SSEvernoteHelper *)helper {
  return  (SSEvernoteHelper*)objc_getAssociatedObject(self, &kHelperKey);
}

@end
@implementation EvernoteNoteStore (SSPatch)

- (void) getNoteThumbnailWithGuid:(EDAMGuid)guid
                             size:(NSInteger)size
                          success:(void(^)(NSData *thmData))successHandler
                          failure:(void(^)(NSError *error))errorHandler {
  
  [self getThumbnailForType:@"note"
                   WithGuid:guid
                       size:size
                    success:successHandler
                    failure:errorHandler];
  
}

- (void) getResourceThumbnailWithGuid:(EDAMGuid)guid
                                 size:(NSInteger)size
                              success:(void(^)(NSData *thmData))successHandler
                              failure:(void(^)(NSError *error))errorHandler {
  
  [self getThumbnailForType:@"res"
                   WithGuid:guid
                       size:size
                    success:successHandler
                    failure:errorHandler];
  
}

- (void) getThumbnailForType:(NSString*)type
                    WithGuid:(EDAMGuid)guid
                         size:(NSInteger)size
                      success:(void(^)(NSData *thmData))successHandler
                      failure:(void(^)(NSError *error))errorHandler {
  
  EvernoteSession *session = [EvernoteSession sharedSession];
  NSString *shardId = [[[session userStore] getUser:[session authenticationToken]] shardId];
  NSString *urlString = [NSString stringWithFormat:@"https://%@/shard/%@/thm/%@/%@", session.host, shardId, type, guid];
  if (size != 0) {
    urlString = [NSString stringWithFormat:@"%@?size=%d", urlString, size];
  }
  
  NSLog(@"request URL: %@", urlString);
  NSURL *requestURL = [NSURL URLWithString:urlString];
  
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL
                                           cachePolicy:NSURLCacheStorageAllowed
                                       timeoutInterval:60];
  
  [request setHTTPMethod:@"POST"];
  NSString *authOptions = [NSString stringWithFormat:@"auth=%@",
                           CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                   (CFStringRef)session.authenticationToken,
                                                                   NULL,
                                                                   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                   kCFStringEncodingUTF8)];
  [request setHTTPBody:[authOptions dataUsingEncoding:NSUTF8StringEncoding]];
  
  self.helper = [[SSEvernoteHelper alloc] init];
  self.helper.onComplete = ^(NSError *error, NSData *data) {
    if (error) {
      if (errorHandler)
        errorHandler(error);
    } else {
      if (successHandler)
        successHandler(data);
    }
  };
  
  NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self.helper];
  [connection start];

}
@end
