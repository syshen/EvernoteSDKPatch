### Description
A simple wrapper of Evernote iOS SDK to allow you to download thumbnails of a note or a resource image.

For detail protocol information, you may refer to this document:
http://dev.evernote.com/documentation/cloud/chapters/thumbnails.php

### Limitations:
- You can only grab the thumbnail in square dimension, this is a limitation from Evernote

### Installation

* Cocoapods: Search and install with SSEvernoteSDKPatch
* Manual: Drag EvernoteNoteStore+SSPatch.h and EvernoteNoteStore+SSPatch.m into your project

### How to use (Sample)

* Fetch resource thumbnail image in original resolution

       [[EvernoteNoteStore noteStore]
        getResourceThumbnailWithGuid:resource.guid
        size:0
        success:^(NSData *resource) {
          
          NSLog(@"response size: %d", resource.length);
          
          UIImage *image = [UIImage imageWithData:resource];
          dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
          });
          
        } failure:^(NSError *error) {
          NSLog(@"error: %@", error);
        }];


* Fetch thumbnail image of note specified with its GUID in 300x300 square dimension

       [[EvernoteNoteStore noteStore]
        getNoteThumbnailWithGuid:note.guid
        size:150
        success:^(NSData *thmData) {
          UIImage *image = [UIImage imageWithData:thmData];
          dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
          });
        } failure:^(NSError *error) {
          NSLog(@"error: %@", error);
        }];
