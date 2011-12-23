//
//  LXTableColumn.h
//  TableViewHeaderMenu
//
//  Created by liam on 10-03-15.
//  Copyright 2010 __Beyondcow Inc__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LXTableColumn : NSTableColumn {
	BOOL hidden;
}
-(BOOL)isHidden;
-(void)setHidden:(BOOL)s;
@end
