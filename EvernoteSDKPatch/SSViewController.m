//
//  SSViewController.m
//  EvernoteSDKPatch
//
//  Created by syshen on 8/5/13.
//  Copyright (c) 2013 syshen. All rights reserved.
//

#import "SSViewController.h"
#import "SSNotebookViewController.h"
#import <Evernote-SDK-iOS/EvernoteSDK.h>

@interface SSViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *notebooks;
@end

@implementation SSViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
}

- (void) fetchNotebookList {
  
  [[EvernoteNoteStore noteStore] listNotebooksWithSuccess:^(NSArray *notebooks) {
    self.notebooks = notebooks;
    [self.tableView reloadData];
  } failure:^(NSError *error) {
    NSLog(@"Unable to fetch notebooks: %@",error);
  }];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  if([[EvernoteSession sharedSession] isAuthenticated]) {
    [self fetchNotebookList];
  } else {
    [[EvernoteSession sharedSession] authenticateWithViewController:self completionHandler:^(NSError *error) {
      if (error) {
        NSLog(@"Authenticate fail: %@", error);
      } else {
        [self fetchNotebookList];
      }
    }];
  }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.notebooks.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *identifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
  }

  EDAMNotebook *notebook = self.notebooks[indexPath.row];
  
  cell.textLabel.text = notebook.name;
  
  return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  SSNotebookViewController *vc = [[SSNotebookViewController alloc] initWithNibName:nil bundle:nil];
  
  vc.notebook = self.notebooks[indexPath.row];
  
  [self.navigationController pushViewController:vc animated:YES];
}


@end
