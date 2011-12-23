//
//  TableViewHeaderMenuAppDelegate.h
//  TableViewHeaderMenu
//
//  Created by liam on 10-03-15.
//  Copyright 2010 __Beyondcow Inc__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LXTableColumn.h"

@interface TableViewHeaderMenuAppDelegate : NSObject{
   	IBOutlet NSWindow	*window;
	NSTableView			*tableView;
	NSMutableArray		*tableData;
	NSMenu				*headerContextMenu;
}

- (void)readTableViewHeader;
- (void)saveTableViewHeader;
- (void)setupTableHeaderMenu;
- (void)addColumn:(NSString*)newid withTitle:(NSString*)title;
- (IBAction)toggleColumn:(id)sender;
- (int)numberOfRowsInTableView:(NSTableView *)aTableView;
- (id)tableView: (NSTableView *)theTableView objectValueForTableColumn: (NSTableColumn *)theColumn row: (int)rowIndex;

@end
