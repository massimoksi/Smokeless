//
//  CreditsViewController.m
//  Smokeless
//
//  Created by Massimo Peri on 01/05/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import "CreditsViewController.h"


#define LABEL_WIDTH     300.0
#define LABEL_HEIGHT    20.0
#define LABEL_PADDING   10.0
#define SECTION_PADDING 15.0


@implementation CreditsViewController

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark View lifecycle

- (void)loadView
{
	// create view
	self.view = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
	// set background color
	self.view.backgroundColor = [UIColor clearColor];
	// set the title
	self.title = MPString(@"Credits");
    
    UILabel *dndTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0,
                                                                  LABEL_PADDING,
                                                                  320.0,
                                                                  LABEL_HEIGHT)];
    dndTitle.backgroundColor = [UIColor clearColor];
    dndTitle.textAlignment = UITextAlignmentCenter;
    dndTitle.textColor = [UIColor colorWithWhite:0.000 alpha:0.750];
    dndTitle.shadowColor = [UIColor colorWithWhite:0.710 alpha:0.750];
    dndTitle.shadowOffset = (CGSize){ 0.0, 1.0 };
    dndTitle.font = [UIFont boldSystemFontOfSize:15.0];
    dndTitle.text = MPString(@"Design & Development");

    UILabel *dndCredit = [[UILabel alloc] initWithFrame:CGRectMake(0.0,
                                                                   LABEL_HEIGHT + LABEL_PADDING,
                                                                   320.0,
                                                                   LABEL_HEIGHT)];
    dndCredit.backgroundColor = [UIColor clearColor];
    dndCredit.textAlignment = UITextAlignmentCenter;
    dndCredit.textColor = [UIColor colorWithWhite:0.000 alpha:0.750];
    dndCredit.shadowColor = [UIColor colorWithWhite:0.710 alpha:0.750];
    dndCredit.shadowOffset = (CGSize){ 0.0, 1.0 };
    dndCredit.font = [UIFont systemFontOfSize:15.0];
    dndCredit.text = MPString(@"Massimo Peri");
    
    UILabel *locTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0,
                                                                  2*LABEL_HEIGHT + LABEL_PADDING + SECTION_PADDING,
                                                                  320.0,
                                                                  LABEL_HEIGHT)];
    locTitle.backgroundColor = [UIColor clearColor];
    locTitle.textAlignment = UITextAlignmentCenter;
    locTitle.textColor = [UIColor colorWithWhite:0.000 alpha:0.750];
    locTitle.shadowColor = [UIColor colorWithWhite:0.710 alpha:0.750];
    locTitle.shadowOffset = (CGSize){ 0.0, 1.0 };
    locTitle.font = [UIFont boldSystemFontOfSize:15.0];
    locTitle.text = MPString(@"Localization");

    UILabel *locCredit = [[UILabel alloc] initWithFrame:CGRectMake(0.0,
                                                                   3*LABEL_HEIGHT + LABEL_PADDING + SECTION_PADDING,
                                                                   320.0,
                                                                   LABEL_HEIGHT)];
    locCredit.backgroundColor = [UIColor clearColor];
    locCredit.textAlignment = UITextAlignmentCenter;
    locCredit.textColor = [UIColor colorWithWhite:0.000 alpha:0.750];
    locCredit.shadowColor = [UIColor colorWithWhite:0.710 alpha:0.750];
    locCredit.shadowOffset = (CGSize){ 0.0, 1.0 };
    locCredit.font = [UIFont systemFontOfSize:15.0];
    locCredit.text = MPString(@"Maria Giulia Morini");
    
    UILabel *thanksTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0,
                                                                     4*LABEL_HEIGHT + LABEL_PADDING + 2*SECTION_PADDING,
                                                                     320.0,
                                                                     LABEL_HEIGHT)];
    thanksTitle.backgroundColor = [UIColor clearColor];
    thanksTitle.textAlignment = UITextAlignmentCenter;
    thanksTitle.textColor = [UIColor colorWithWhite:0.000 alpha:0.750];
    thanksTitle.shadowColor = [UIColor colorWithWhite:0.710 alpha:0.750];
    thanksTitle.shadowOffset = (CGSize){ 0.0, 1.0 };
    thanksTitle.font = [UIFont boldSystemFontOfSize:15.0];
    thanksTitle.text = MPString(@"Special Thanks");

    UILabel *thanksCredit1 = [[UILabel alloc] initWithFrame:CGRectMake(0.0,
                                                                       5*LABEL_HEIGHT + LABEL_PADDING + 2*SECTION_PADDING,
                                                                       320.0,
                                                                       LABEL_HEIGHT)];
    thanksCredit1.backgroundColor = [UIColor clearColor];
    thanksCredit1.textAlignment = UITextAlignmentCenter;
    thanksCredit1.textColor = [UIColor colorWithWhite:0.000 alpha:0.750];
    thanksCredit1.shadowColor = [UIColor colorWithWhite:0.710 alpha:0.750];
    thanksCredit1.shadowOffset = (CGSize){ 0.0, 1.0 };
    thanksCredit1.font = [UIFont systemFontOfSize:15.0];
    thanksCredit1.text = MPString(@"Yummigum for iconSweets 2");

    UILabel *thanksCredit2 = [[UILabel alloc] initWithFrame:CGRectMake(0.0,
                                                                       6*LABEL_HEIGHT + LABEL_PADDING + 2*SECTION_PADDING,
                                                                       320.0,
                                                                       LABEL_HEIGHT)];
    thanksCredit2.backgroundColor = [UIColor clearColor];
    thanksCredit2.textAlignment = UITextAlignmentCenter;
    thanksCredit2.textColor = [UIColor colorWithWhite:0.000 alpha:0.750];
    thanksCredit2.shadowColor = [UIColor colorWithWhite:0.710 alpha:0.750];
    thanksCredit2.shadowOffset = (CGSize){ 0.0, 1.0 };
    thanksCredit2.font = [UIFont systemFontOfSize:15.0];
    thanksCredit2.text = MPString(@"Matej Bukovinski for MBProgressHUD");

    UILabel *thanksCredit3 = [[UILabel alloc] initWithFrame:CGRectMake(0.0,
                                                                       7*LABEL_HEIGHT + LABEL_PADDING + 2*SECTION_PADDING,
                                                                       320.0,
                                                                       LABEL_HEIGHT)];
    thanksCredit3.backgroundColor = [UIColor clearColor];
    thanksCredit3.textAlignment = UITextAlignmentCenter;
    thanksCredit3.textColor = [UIColor colorWithWhite:0.000 alpha:0.750];
    thanksCredit3.shadowColor = [UIColor colorWithWhite:0.710 alpha:0.750];
    thanksCredit3.shadowOffset = (CGSize){ 0.0, 1.0 };
    thanksCredit3.font = [UIFont systemFontOfSize:15.0];
    thanksCredit3.text = MPString(@"Matt Gallagher for ShadowedTableView");

    // create view hierarchy
    [self.view addSubview:dndTitle];
    [self.view addSubview:dndCredit];
    [self.view addSubview:locTitle];
    [self.view addSubview:locCredit];
    [self.view addSubview:thanksTitle];
    [self.view addSubview:thanksCredit1];
    [self.view addSubview:thanksCredit2];
    [self.view addSubview:thanksCredit3];
    
    // release labels
    [dndTitle release];
    [dndCredit release];
    [locTitle release];
    [locCredit release];
    [thanksTitle release];
    [thanksCredit1 release];
    [thanksCredit2 release];
    [thanksCredit3 release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
