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
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	// Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Kittens";
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
	kittenViewCell.url = @"http://placekitten.com/g/310/200";

	return kittenViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 200;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//	[super scrollViewDidScroll:scrollView];
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//	[super scrollViewDidEndDecelerating:scrollView];
//}


@end
