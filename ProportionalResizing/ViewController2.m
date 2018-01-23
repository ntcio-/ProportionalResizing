//
//  ViewController2.m
//  ProportionalResizing
//
//  Created by Nikolaos Tsiolas on 17/01/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "ViewController2.h"
#import "AFSEDemoTableViewCell.h"
#import "UIView+ProportionalResizing.h"

@interface ViewController2 () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.tableView.rowHeight = 60;
	
	[self adaptForAllDevices];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	AFSEDemoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"AFSEDemoTableViewCell" forIndexPath:indexPath];
	
	cell.itemLabel.text = [NSString stringWithFormat:@"Item %li", indexPath.row+1];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	return cell;
}

@end
