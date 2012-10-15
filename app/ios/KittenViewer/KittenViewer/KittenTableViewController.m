//
//  KittenTableViewController.m
//  KittenViewer
//
//  Created by Somya Jain on 9/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KittenTableViewController.h"
#import "KittenViewCell.h"

@interface KittenTableViewController ()

@end

@implementation KittenTableViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	// Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Kittens";
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
	forRowAtIndexPath:(NSIndexPath *)indexPath
{

	if ( [cell isKindOfClass:[KittenViewCell class]] )
	{
		[((KittenViewCell *) cell) loadImages];
	};
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
	cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

	KittenViewCell *kittenViewCell = [tableView dequeueReusableCellWithIdentifier:@"kittenCell"];

	if ( !kittenViewCell )
	{
		kittenViewCell = [[[KittenViewCell alloc]
			initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kittenCell"]
			autorelease];
	}



	return kittenViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 150 + (arc4random() % (int) 150);
}


@end
