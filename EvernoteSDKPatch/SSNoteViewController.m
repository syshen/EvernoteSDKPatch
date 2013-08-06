//
//  SSNoteViewController.m
//  EvernoteSDKPatch
//
//  Created by syshen on 8/5/13.
//  Copyright (c) 2013 syshen. All rights reserved.
//

#import "SSNoteViewController.h"
#import <Evernote-SDK-iOS/ENMLUtility.h>
#import "EvernoteNoteStore+SSPatch.h"

@interface SSNoteViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@end

@implementation SSNoteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad {
  [super viewDidLoad];
  
  self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  self.indicatorView.frame = CGRectMake(0, 0, 320, 100);
  self.indicatorView.hidesWhenStopped = YES;
  [self.indicatorView startAnimating];
  [self.view addSubview:self.indicatorView];
  
  
  [[EvernoteNoteStore noteStore]
   getNoteWithGuid:self.note.guid
   withContent:YES
   withResourcesData:YES
   withResourcesRecognition:NO
   withResourcesAlternateData:NO
   success:^(EDAMNote *note) {
     
     if (note.resources.count) {
       EDAMResource *resource = note.resources[0];
       [[EvernoteNoteStore noteStore]
        getResourceThumbnailWithGuid:resource.guid
        size:0
        success:^(NSData *resource) {
          
          NSLog(@"response size: %d", resource.length);
          
          UIImage *image = [UIImage imageWithData:resource];
          dispatch_async(dispatch_get_main_queue(), ^{
            [self.indicatorView stopAnimating];
            self.imageView.image = image;
          });
          
        } failure:^(NSError *error) {
          dispatch_async(dispatch_get_main_queue(), ^{
            [self.indicatorView stopAnimating];
          });
          NSLog(@"error: %@", error);
        }];
     } else {
       
       [[EvernoteNoteStore noteStore]
        getNoteThumbnailWithGuid:note.guid
        size:150
        success:^(NSData *thmData) {
          UIImage *image = [UIImage imageWithData:thmData];
          dispatch_async(dispatch_get_main_queue(), ^{
            [self.indicatorView stopAnimating];
            self.imageView.image = image;
          });
        } failure:^(NSError *error) {
          dispatch_async(dispatch_get_main_queue(), ^{
            [self.indicatorView stopAnimating];
          });
          NSLog(@"error: %@", error);
        }];
     }
     
   }
   failure:^(NSError *error) {
     dispatch_async(dispatch_get_main_queue(), ^{
       [self.indicatorView stopAnimating];
     });
     NSLog(@"Unable to fetch note: %@", error);
   }];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
