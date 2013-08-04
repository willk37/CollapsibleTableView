//
//  CollapsibleTVSection.h
//  CollapsibleTableView
//
//  Created by Will on 3/18/13.
//  Copyright (c) 2013 Will. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollapsibleTVSection : NSObject

@property (nonatomic) BOOL sectionCollapsed;
@property (nonatomic, strong) NSString *sectionTitle;
@property (nonatomic, strong) NSArray *sectionData;

@end
