//
//  AchievementsViewController.m
//  Smokeless
//
//  Created by Massimo Peri on 02/04/12.
//  Copyright (c) 2012 Massimo Peri. All rights reserved.
//

#import "AchievementsViewController.h"

#import "Achievement.h"


@interface AchievementsViewController ()

@property (nonatomic, retain) NSArray *achievements;

@end

@implementation AchievementsViewController

@synthesize achievements = _achievements;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        Achievement *step1 = [[Achievement alloc] init];
        step1.days = 2;
        step1.text = @"All nicotine will have left your body. Your sense of taste and smell will return to a normal level.";
        
        Achievement *step2 = [[Achievement alloc] init];
        step2.days = 3;
        step2.text = @"Your bronchial tubes will relax, and your over-all energy will rise.";
        
        Achievement *step3 = [[Achievement alloc] init];
        step3.weeks = 2;
        step3.text = @"Your circulation will increase, and it will continue improving for the next 10 weeks.";
        
        Achievement *step4 = [[Achievement alloc] init];
        step4.months = 9;
        step4.text = @"Coughs, wheezing and breathing problems will dissipate as your lung capacity improves by 10%.";
        
        Achievement *step5 = [[Achievement alloc] init];
        step5.years = 1;
        step5.text = @"Your risk of having a heart attack will have now dropped by half.";
        
        Achievement *step6 = [[Achievement alloc] init];
        step6.years = 5;
        step6.text = @"Your risk of having a stroke returns to that of a non-smoker.";
        
        Achievement *step7 = [[Achievement alloc] init];
        step7.years = 10;
        step7.text = @"Your risk of lung cancer will have returned to that of a non-smoker.";
        
        Achievement *step8 = [[Achievement alloc] init];
        step8.years = 15;
        step8.text = @"Your risk of heart attack will have returned to that of a non-smoker.";
        
        // create achievements
        self.achievements = [NSArray arrayWithObjects:
                             step1,
                             step2,
                             step3,
                             step4,
                             step5,
                             step6,
                             step7,
                             step8,
                             nil];
        
        // relase objects
        [step1 release];
        [step2 release];
        [step3 release];
        [step4 release];
        [step5 release];
        [step6 release];
        [step7 release];
        [step8 release];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// set background
	self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
	self.view.backgroundColor = [UIColor clearColor];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.achievements count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
