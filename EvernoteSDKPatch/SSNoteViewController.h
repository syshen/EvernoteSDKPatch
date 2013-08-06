//
//  SSNoteViewController.h
//  EvernoteSDKPatch
//
//  Created by syshen on 8/5/13.
//  Copyright (c) 2013 syshen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Evernote-SDK-iOS/EvernoteSDK.h>

@interface SSNoteViewController : UIViewController
@property (nonatomic, strong) EDAMNote *note;
@end
