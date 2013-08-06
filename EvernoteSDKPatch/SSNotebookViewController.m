//
//  SSNotebookViewController.m
//  EvernoteSDKPatch
//
//  Created by syshen on 8/5/13.
//  Copyright (c) 2013 syshen. All rights reserved.
//

#import "SSNotebookViewController.h"
#import "SSNoteViewController.h"
#import <Evernote-SDK-iOS/EvernoteSDK.h>

@interface SSNotebookViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *notes;
@end

@implementation SSNotebookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  EDAMNoteFilter *filter = [[EDAMNoteFilter alloc]
                            initWithOrder:NoteSortOrder_CREATED
                            ascending:YES
                            words:nil
                            notebookGuid:self.notebook.guid
                            tagGuids:nil
                            timeZone:nil
                            inactive:NO
                            emphasized:nil];
  
  [[EvernoteNoteStore noteStore] findNotesWithFilter:filter offset:0 maxNotes:300 success:^(EDAMNoteList *list) {
    self.notes = [NSArray arrayWithArray:list.notes];
    [self.tableView reloadData];
  } failure:^(NSError *error) {
    NSLog(@"Unable to get notes: %@", error
          );
  }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.notes.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *identifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
  }
  
  EDAMNote *note = self.notes[indexPath.row];
  
  cell.textLabel.text = note.title;
  
  return cell;

}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  SSNoteViewController *vc = [[SSNoteViewController alloc] initWithNibName:nil bundle:nil];
  
  vc.note = self.notes[indexPath.row];
  [self.navigationController pushViewController:vc animated:YES];
  
}
@end
