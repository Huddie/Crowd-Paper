//
//  ViewController.m
//  Crowd Paper
//
//  Created by Ehud Adler on 2/2/15.
//  Copyright (c) 2015 Ehud Adler. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end


@implementation ViewController{
	
	NSMutableArray *array;
	NSMutableArray *name;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	array = [[NSMutableArray alloc]init];
	name = [[NSMutableArray alloc]init];

	
	[array addObject:[UIColor redColor]];
	[array addObject:[UIColor blueColor]];
	[array addObject:[UIColor greenColor]];
	[array addObject:[UIColor purpleColor]];
	[array addObject:[UIColor yellowColor]];
	
	[name addObject:@"Red"];
	[name addObject:@"Blue"];
	[name addObject:@"Green"];
	[name addObject:@"Purple"];
	[name addObject:@"Yellow"];

}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];


}




-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
	return 1;
}
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
	return [name count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
	
	UILabel *label = (UILabel *)[cell viewWithTag:100];
	
	label.text = [name objectAtIndex:indexPath.row];
	
	
	[cell.layer setCornerRadius:cell.frame.size.height/2];

	
		UIColor *color = [array objectAtIndex:indexPath.row];
	
		cell.backgroundColor = color;
	
	return cell;
}
@end
