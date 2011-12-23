//
//  TableViewHeaderMenuAppDelegate.m
//  TableViewHeaderMenu
//
//  Created by liam on 10-03-15.
//  Copyright 2010 __Beyondcow Inc__. All rights reserved.
//

#import "TableViewHeaderMenuAppDelegate.h"

#define FULLSIZE (NSViewMinXMargin | NSViewWidthSizable | NSViewMaxXMargin | NSViewMinYMargin | NSViewHeightSizable | NSViewMaxYMargin)

@implementation TableViewHeaderMenuAppDelegate

- (void)awakeFromNib
{
	
	NSRect frame=[window frame];
	
	frame.origin.y+=25;
	frame.size.height-=25;
	
	tableData=[[NSMutableArray alloc] init];
	
	NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
	[dic setObject:@"hahah" forKey:@"1"];
	[dic setObject:@"125" forKey:@"2"];
	[dic setObject:@"10" forKey:@"3"];
	[dic setObject:@"10/125" forKey:@"4"];
	[tableData addObject:dic];
	[dic release];
	dic=[[NSMutableDictionary alloc] init];
	[dic setObject:@"Hello" forKey:@"1"];
	[dic setObject:@"150" forKey:@"2"];
	[dic setObject:@"20" forKey:@"3"];
	[dic setObject:@"20/150" forKey:@"4"];
	[tableData addObject:dic];
	[dic release];
	
	NSScrollView *scrollView=[[NSScrollView alloc] initWithFrame:frame];
	[scrollView setAutoresizingMask:FULLSIZE];
	[scrollView setBackgroundColor:[NSColor redColor]];
	
	frame.size.height-=16;
	tableView = [[NSTableView alloc] initWithFrame:frame];
	[tableView setAutosaveName:@"downloadTableView"];
	
	frame.origin.y=frame.size.height;
	frame.size.height=17;
	
	NSTableHeaderView *tableHeadView=[[NSTableHeaderView alloc] initWithFrame:frame];
	[tableView setHeaderView:tableHeadView];
	[tableHeadView release];
	
	[tableView setAutoresizesSubviews:FULLSIZE];
	[tableView setBackgroundColor:[NSColor whiteColor]];
	[tableView setGridColor:[NSColor lightGrayColor]];
	[tableView setGridStyleMask: NSTableViewSolidHorizontalGridLineMask];
	[tableView setUsesAlternatingRowBackgroundColors:YES];
	[tableView setAutosaveTableColumns:YES];
	[tableView setAllowsEmptySelection:YES];
	[tableView setAllowsColumnSelection:YES];
	
	[self addColumn:@"1" withTitle:@"Name"];
	[self addColumn:@"2" withTitle:@"Size"];
	[self addColumn:@"3" withTitle:@"Get"];
	[self addColumn:@"4" withTitle:@"Bar"];
	[self addColumn:@"5" withTitle:@"ABc"];
	
	[tableView setDataSource:self];
	[scrollView setDocumentView:tableView];
	
	[window setContentView:scrollView];
	[scrollView release];
	
	[self setupTableHeaderMenu];
}


- (void)addColumn:(NSString*)newid withTitle:(NSString*)title
{
	LXTableColumn *column=[[LXTableColumn alloc] initWithIdentifier:newid];
	[[column headerCell] setStringValue:title];
	[[column headerCell] setAlignment:NSCenterTextAlignment];
	[column setWidth:100.0];
	[column setMinWidth:50];
	[column setEditable:NO];
	[column setResizingMask:NSTableColumnAutoresizingMask | NSTableColumnUserResizingMask];
	[tableView addTableColumn:column];
	[column release];
}

-(void)setupTableHeaderMenu
{
	headerContextMenu = [[NSMenu alloc] initWithTitle:[NSString stringWithFormat:@"LX_HeaderContextMenu"]];
	int visibleTableColumns = 0;
	int menuIndex = 0;
	//NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"identifier" ascending:YES];
	//NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	//[sortDescriptor release];
	
	//NSEnumerator *e=[[[tableView tableColumns] sortedArrayUsingDescriptors: sortDescriptors] objectEnumerator];
	[self readTableViewHeader];
	
	NSEnumerator *e=[[tableView tableColumns] objectEnumerator];
	int i=0;
	LXTableColumn *col;
	NSMutableDictionary *fontattribs = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSFont systemFontOfSize:11.0], NSFontAttributeName, nil];
	while (col=[e nextObject]) 
	{
		NSString *title;
		title = [[col headerCell] title];
		NSMenuItem *contextMenuItem = [[NSMenuItem alloc] init];
		[contextMenuItem setAttributedTitle:[[NSAttributedString alloc] initWithString:title attributes:fontattribs]];
		[contextMenuItem setTarget:self];
		[contextMenuItem setAction:@selector(toggleColumn:)];
		[contextMenuItem setRepresentedObject:col];
		[contextMenuItem setState:([col isHidden] ? NSOffState : NSOnState)];
		visibleTableColumns += ![col isHidden];
		[headerContextMenu insertItem:contextMenuItem atIndex:menuIndex];
		[contextMenuItem release];
		menuIndex++;
		i++;
	}
	
	if (visibleTableColumns == 0) {
		NSEnumerator *e=[[tableView tableColumns] objectEnumerator];
		LXTableColumn *col;
		while (col=[e nextObject]) {
			[col setHidden:NO];
		}
	}
	
	[[tableView headerView] setMenu:headerContextMenu];
}

- (IBAction)toggleColumn:(id)sender
{
	LXTableColumn *tc = [sender representedObject];
	NSLog(@"TC=%@",tc);
	NSLog(@"self=%@",self);
	if ([sender state] == NSOffState)
	{
		[sender setState:NSOnState];
		[tc setHidden: NO];
	}
	else
	{
		[sender setState:NSOffState];
		[tc setHidden: YES];
	}
	[tableView reloadData];
}


-(void)readTableViewHeader
{
	NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
	
	NSEnumerator *e=[[tableView tableColumns] objectEnumerator];
	LXTableColumn *col;
	while (col=[e nextObject]) 
	{
		BOOL isHidden=[defaults boolForKey:[NSString stringWithFormat:@"LX_%@",[col identifier]]];
		[col setHidden:isHidden];
	}
}

-(void)saveTableViewHeader
{
	NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
	NSEnumerator *e=[[tableView tableColumns] objectEnumerator];
	LXTableColumn *col;
	while (col=[e nextObject]) 
	{
		[defaults setBool:[col isHidden] forKey:[NSString stringWithFormat:@"LX_%@",[col identifier]]];
	}
	
}

#pragma mark NSTableViewDataSource Delegate

- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
	return [tableData count];
}

- (id)tableView: (NSTableView *)theTableView objectValueForTableColumn: (NSTableColumn *)theColumn row: (int)rowIndex
{
	NSParameterAssert(rowIndex >= 0 && rowIndex < [tableData count]);
	return [[tableData objectAtIndex:rowIndex] objectForKey:[theColumn identifier]];
}

#pragma mark NSApplication Delegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
}

- (void)applicationWillTerminate:(NSNotification*)notification
{
	[self saveTableViewHeader];
}

- (void)dealloc
{
	[headerContextMenu release];
	[tableView release];
	[tableData release];
    [super dealloc];
}
@end
