//
//  CollapsibleTVViewController.m
//  CollapsibleTableView
//
//  Created by Will on 3/18/13.
//  Copyright (c) 2013 Will. All rights reserved.
//

#import "CollapsibleTVViewController.h"
#import "CollapsibleTVButton.h" 
#import "CollapsibleTVSection.h"

@interface CollapsibleTVViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation CollapsibleTVViewController

@synthesize tableViewData = _tableViewData;

- (NSArray *)tableViewData{
    if(!_tableViewData){
        _tableViewData = [[NSArray alloc] init];
    }
    return _tableViewData;
}

- (void)setTableViewData:(NSArray *)tableViewData
{
    if(_tableViewData != tableViewData){
        _tableViewData = tableViewData;
        [self.tableView reloadData];
    }
}

#pragma mark - Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //hard coded for testing
    CollapsibleTVSection *data = [[CollapsibleTVSection alloc] init];
    data.sectionCollapsed = YES;
    data.sectionTitle = @"Data set 1";
    data.sectionData = @[@"x", @"y", @"z"];
    
    CollapsibleTVSection *data2 = [[CollapsibleTVSection alloc] init];
    data2.sectionCollapsed = YES;
    data2.sectionTitle = @"Data set 2";
    data2.sectionData = @[@"a", @"b", @"c"];
    
    
    CollapsibleTVSection *section = [[CollapsibleTVSection alloc] init];
    section.sectionCollapsed = NO;
    section.sectionTitle = @"Section 1";
    section.sectionData = @[data, @"Data 1.1", @"Data 1.2"];
    
    CollapsibleTVSection *section2 = [[CollapsibleTVSection alloc] init];
    section2.sectionCollapsed = NO;
    section2.sectionTitle = @"Section 2";
    section2.sectionData = @[@"Data 2.1", @"Data 2.2", data2];
    
    self.tableViewData = [self.tableViewData arrayByAddingObject:section];
    self.tableViewData = [self.tableViewData arrayByAddingObject:section2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - collapse/expand section

- (void)collapsePressed:(CollapsibleTVButton *)button
{
    //NSLog(@"Button: %@", button);
    NSMutableArray *myArray = [self.tableViewData mutableCopy];
    CollapsibleTVSection *mySection = [self.tableViewData objectAtIndex:button.section];
    
    if([button.titleLabel.text isEqualToString:@"Collapse"]){
        [button setTitle:@"Expand" forState:UIControlStateNormal];
        mySection.sectionCollapsed = YES;
    }
    else{
        [button setTitle:@"Collapse" forState:UIControlStateNormal];
        mySection.sectionCollapsed = NO;
    }
    
    [myArray replaceObjectAtIndex:button.section withObject:mySection];
    self.tableViewData = myArray;
}

- (void)cellCollapsePressed:(CollapsibleTVButton *)button
{
    NSArray *temp = [self allObjectsInSection:button.section];
    CollapsibleTVSection *mySection = [temp objectAtIndex:button.row];
    
    if([button.titleLabel.text isEqualToString:@"Collapse"]){
        [button setTitle:@"Expand" forState:UIControlStateNormal];
        mySection.sectionCollapsed = YES;
    }
    else{
        [button setTitle:@"Collapse" forState:UIControlStateNormal];
        mySection.sectionCollapsed = NO;
    }
    
    [self.tableView reloadData];
    
}

- (NSArray *)allObjectsInSection:(NSInteger)section;
{
    NSMutableArray *myArray = [[NSMutableArray alloc] init];
    
    for (id object in [[self.tableViewData objectAtIndex:section] sectionData]){
        //if collapsible
        if([object isKindOfClass:[CollapsibleTVSection class]]){
            if(![object sectionCollapsed]){
                [myArray addObject:object];
                for(id dataObject in [object sectionData]){
                    [myArray addObject:dataObject];
                }
            }
            else{
                [myArray addObject:object];
            }
        }
        else
        {
            //add single object
            [myArray addObject:object];
        }
        
    }
    
    return myArray;
}

#pragma mark - UITableViewDataSource Methodos

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tableViewData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRowsInSection = 0;
    
    if(![[self.tableViewData objectAtIndex:section] sectionCollapsed]){
        for(id objectInSection in [[self.tableViewData objectAtIndex:section] sectionData]){
            if([objectInSection isKindOfClass:[CollapsibleTVSection class]]){
                if(![objectInSection sectionCollapsed]){
                    numberOfRowsInSection += [[objectInSection sectionData] count] + 1;
                }
                else{
                    numberOfRowsInSection += 1;
                }
            }
            else{
                numberOfRowsInSection += 1;
            }
            
        }
    }
    else{
        numberOfRowsInSection = 0;
    }
    
    return numberOfRowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    NSArray *temp = [self allObjectsInSection:indexPath.section];
    
    if([[temp objectAtIndex:indexPath.row] isKindOfClass:[CollapsibleTVSection class]]){
        cell.textLabel.text = [[temp objectAtIndex:indexPath.row] sectionTitle];
        CollapsibleTVButton *button = [[CollapsibleTVButton alloc] init];
        //button.section = section;
        button.frame = CGRectMake(self.view.bounds.size.width-110, 5, 100, 34);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if([[temp objectAtIndex:indexPath.row] sectionCollapsed]){
            [button setTitle:@"Expand" forState:UIControlStateNormal];
        }
        else{
            [button setTitle:@"Collapse" forState:UIControlStateNormal];
        }
        button.section = indexPath.section;
        button.row = indexPath.row;
        [button addTarget:self action:@selector(cellCollapsePressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:button];
    }
    else{
        cell.textLabel.text = [temp objectAtIndex:indexPath.row];
    }

    
    return cell;
}

#pragma mark - UITableViewDelegate Methodos

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //do something
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(self.view.bounds.size.width, 0, 100, 44);
    label.backgroundColor = [UIColor lightGrayColor];
    label.textColor = [UIColor whiteColor];
    label.text = [[self.tableViewData objectAtIndex:section] sectionTitle];
    
    CollapsibleTVButton *button = [[CollapsibleTVButton alloc] init];
    button.section = section;
    button.frame = CGRectMake(self.view.bounds.size.width-110, 5, 100, 34);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if(![[self.tableViewData objectAtIndex:section] sectionCollapsed]){
        [button setTitle:@"Collapse" forState:UIControlStateNormal];
    }
    else{
        [button setTitle:@"Expand" forState:UIControlStateNormal];
    }
    [button addTarget:self action:@selector(collapsePressed:) forControlEvents:UIControlEventTouchUpInside];
    
    label.userInteractionEnabled = YES;
    [label addSubview:button];
    
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
 

@end
