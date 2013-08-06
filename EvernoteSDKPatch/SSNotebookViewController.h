//
//  SSNotebookViewController.h
//  EvernoteSDKPatch
//
//  Created by syshen on 8/5/13.
//  Copyright (c) 2013 syshen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Evernote-SDK-iOS/EvernoteSDK.h>

@interface SSNotebookViewController : UIViewController
@property (nonatomic, strong) EDAMNotebook *notebook;
@end
