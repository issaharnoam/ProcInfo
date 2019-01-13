//
//  ViewController.m
//  procInfoExample
//
//  Created by Cynet Mac OSX on 13/01/2019.
//  Copyright © 2019 Objective-See. All rights reserved.
//

#import "ViewController.h"
#import "procInfo.h"


@interface ViewController ()

@property (atomic, strong) NSMutableDictionary* runningProcesses;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.processesTblView setDelegate:self];
    [self.processesTblView setDataSource:self];
    
    _runningProcesses = [NSMutableDictionary dictionary];
    
    //init proc info object
    // YES: skip (CPU-intensive) generation of code-signing info
    // NO:  automatically generate code-signing info for each process
    ProcInfo* procInfo = [[ProcInfo alloc] init:NO];
    
    //dump process info for process 1337
    NSLog(@"process: %@", [[Process alloc] init:1337]);
    
    //dump process info for all processes
    for(Process* process in [procInfo currentProcesses]){
        [_runningProcesses setObject:process forKey:[NSNumber numberWithInt: process.pid]];
    }
    
    //block for process events
    ProcessCallbackBlock block = ^(Process* process)
    {
        if(process.type != EVENT_EXIT)
        {
            [self->_runningProcesses setObject:process forKey:[NSNumber numberWithInt: process.pid]];
        }
        else
        {
            [self->_runningProcesses removeObjectForKey:[NSNumber numberWithInt:process.pid]];
        }
        [self->_processesTblView reloadData];
    };
             
    //start monitoring
    // ->block will be invoke upon process events!
    [procInfo start:block];
    [_processesTblView reloadData];
}
        
- (NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    
    Process *process = _runningProcesses.allValues[row];
    if ([tableColumn.identifier isEqualToString:@"pid"]) {
        cellView.textField.integerValue = process.pid;
    }
    else if ([tableColumn.identifier isEqualToString:@"path"]) {
        cellView.textField.stringValue = process.path;
    }
    
    return cellView;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
 
 - (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
     return _runningProcesses.count;
 }


- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    Process* proc = _runningProcesses.allValues[row];
    if(proc!=nil){
        [proc generateSigningInfoByPath:kSecCSDefaultFlags];
    }
    return YES;
}

- (IBAction)onProcessesTableView:(NSTableView *)sender {
    
}
 @end
