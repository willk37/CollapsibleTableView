//
//  CollapsibleTVButton.m
//  CollapsibleTableView
//
//  Created by Will on 3/18/13.
//  Copyright (c) 2013 Will. All rights reserved.
//

#import "CollapsibleTVButton.h"

@implementation CollapsibleTVButton

@synthesize section = _section;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setSection:(NSInteger)section
{
    if(_section != section){
        _section = section;
    }
}

- (void)setRow:(NSInteger)row
{
    if(_row != row){
        _row = row;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
