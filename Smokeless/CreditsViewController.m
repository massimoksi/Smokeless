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

- (void)loadView
{
	// create view
	self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
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
    dndTitle.textColor = [UIColor blackColor];
    dndTitle.shadowColor = [UIColor colorWithWhite:0.850
                                             alpha:1.000];
    dndTitle.shadowOffset = CGSizeMake(0.0, 1.0);
    dndTitle.font = [UIFont boldSystemFontOfSize:15.0];
    dndTitle.text = MPString(@"Design & Development");

    UILabel *dndCredit = [[UILabel alloc] initWithFrame:CGRectMake(0.0,
                                                                   LABEL_HEIGHT + LABEL_PADDING,
                                                                   320.0,
                                                                   LABEL_HEIGHT)];
    dndCredit.backgroundColor = [UIColor clearColor];
    dndCredit.textAlignment = UITextAlignmentCenter;
    dndCredit.textColor = [UIColor blackColor];
    dndCredit.shadowColor = [UIColor colorWithWhite:0.850
                                              alpha:1.000];
    dndCredit.shadowOffset = CGSizeMake(0.0, 1.0);
    dndCredit.font = [UIFont systemFontOfSize:15.0];
    dndCredit.text = MPString(@"Massimo Peri");
    
    UILabel *locTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0,
                                                                  2*LABEL_HEIGHT + LABEL_PADDING + SECTION_PADDING,
                                                                  320.0,
                                                                  LABEL_HEIGHT)];
    locTitle.backgroundColor = [UIColor clearColor];
    locTitle.textAlignment = UITextAlignmentCenter;
    locTitle.textColor = [UIColor blackColor];
    locTitle.shadowColor = [UIColor colorWithWhite:0.850
                                             alpha:1.000];
    locTitle.shadowOffset = CGSizeMake(0.0, 1.0);
    locTitle.font = [UIFont boldSystemFontOfSize:15.0];
    locTitle.text = MPString(@"Localization");

    UILabel *locCredit1 = [[UILabel alloc] initWithFrame:CGRectMake(0.0,
                                                                    3*LABEL_HEIGHT + LABEL_PADDING + SECTION_PADDING,
                                                                    320.0,
                                                                    LABEL_HEIGHT)];
    locCredit1.backgroundColor = [UIColor clearColor];
    locCredit1.textAlignment = UITextAlignmentCenter;
    locCredit1.textColor = [UIColor blackColor];
    locCredit1.shadowColor = [UIColor colorWithWhite:0.850
                                               alpha:1.000];
    locCredit1.shadowOffset = CGSizeMake(0.0, 1.0);
    locCredit1.font = [UIFont systemFontOfSize:15.0];
    locCredit1.text = MPString(@"Maria Giulia Morini");

    UILabel *locCredit2 = [[UILabel alloc] initWithFrame:CGRectMake(0.0,
                                                                    4*LABEL_HEIGHT + LABEL_PADDING + SECTION_PADDING,
                                                                    320.0,
                                                                    LABEL_HEIGHT)];
    locCredit2.backgroundColor = [UIColor clearColor];
    locCredit2.textAlignment = UITextAlignmentCenter;
    locCredit2.textColor = [UIColor blackColor];
    locCredit2.shadowColor = [UIColor colorWithWhite:0.850
                                               alpha:1.000];
    locCredit2.shadowOffset = CGSizeMake(0.0, 1.0);
    locCredit2.font = [UIFont systemFontOfSize:15.0];
    locCredit2.text = MPString(@"Jens Wagner");
    
    UILabel *thanksTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0,
                                                                     5*LABEL_HEIGHT + LABEL_PADDING + 2*SECTION_PADDING,
                                                                     320.0,
                                                                     LABEL_HEIGHT)];
    thanksTitle.backgroundColor = [UIColor clearColor];
    thanksTitle.textAlignment = UITextAlignmentCenter;
    thanksTitle.textColor = [UIColor blackColor];
    thanksTitle.shadowColor = [UIColor colorWithWhite:0.850
                                                alpha:1.000];
    thanksTitle.shadowOffset = CGSizeMake(0.0, 1.0);
    thanksTitle.font = [UIFont boldSystemFontOfSize:15.0];
    thanksTitle.text = MPString(@"Special Thanks");

    UILabel *thanksCredit1 = [[UILabel alloc] initWithFrame:CGRectMake(0.0,
                                                                       6*LABEL_HEIGHT + LABEL_PADDING + 2*SECTION_PADDING,
                                                                       320.0,
                                                                       LABEL_HEIGHT)];
    thanksCredit1.backgroundColor = [UIColor clearColor];
    thanksCredit1.textAlignment = UITextAlignmentCenter;
    thanksCredit1.textColor = [UIColor blackColor];
    thanksCredit1.shadowColor = [UIColor colorWithWhite:0.850
                                                  alpha:1.000];
    thanksCredit1.shadowOffset = CGSizeMake(0.0, 1.0);
    thanksCredit1.font = [UIFont systemFontOfSize:15.0];
    thanksCredit1.text = MPString(@"Yummigum for iconSweets 2");

    UILabel *thanksCredit2 = [[UILabel alloc] initWithFrame:CGRectMake(0.0,
                                                                       7*LABEL_HEIGHT + LABEL_PADDING + 2*SECTION_PADDING,
                                                                       320.0,
                                                                       LABEL_HEIGHT)];
    thanksCredit2.backgroundColor = [UIColor clearColor];
    thanksCredit2.textAlignment = UITextAlignmentCenter;
    thanksCredit2.textColor = [UIColor blackColor];
    thanksCredit2.shadowColor = [UIColor colorWithWhite:0.850
                                                  alpha:1.000];
    thanksCredit2.shadowOffset = CGSizeMake(0.0, 1.0);
    thanksCredit2.font = [UIFont systemFontOfSize:15.0];
    thanksCredit2.text = MPString(@"Matej Bukovinski for MBProgressHUD");

    // create view hierarchy
    [self.view addSubview:dndTitle];
    [self.view addSubview:dndCredit];
    [self.view addSubview:locTitle];
    [self.view addSubview:locCredit1];
    [self.view addSubview:locCredit2];
    [self.view addSubview:thanksTitle];
    [self.view addSubview:thanksCredit1];
    [self.view addSubview:thanksCredit2];
}

@end
