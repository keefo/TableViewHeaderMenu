//
//  LXTableColumn.m
//  TableViewHeaderMenu
//
//  Created by liam on 10-03-15.
//  Copyright 2010 __Beyondcow Inc__. All rights reserved.
//

#import "LXTableColumn.h"


@implementation LXTableColumn
- (id)init
{
	self = [super init];
	return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(BOOL)isHidden
{
	return hidden;
}

-(void)setHidden:(BOOL)s
{
	hidden=s;
}

@end
