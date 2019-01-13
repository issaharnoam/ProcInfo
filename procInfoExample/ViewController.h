//
//  ViewController.h
//  procInfoExample
//
//  Created by Cynet Mac OSX on 13/01/2019.
//  Copyright © 2019 Objective-See. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ViewController : NSViewController<NSTableViewDelegate, NSTableViewDataSource>

@property (nonatomic, strong) IBOutlet NSTableView *processesTblView;
- (IBAction)onProcessesTableView:(NSTableView *)sender;

@end

