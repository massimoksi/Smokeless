//
//  TwitterViewController.m
//  Smokeless
//
//  Created by Massimo Peri on 26/04/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import "TwitterViewController.h"


@implementation TwitterViewController

- (void)dealloc
{
    [progressHUD release];
    
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
    self.title = @"Twitter";
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 436.0)];
    webView.delegate = self;
    
    self.view = webView;
    [webView release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [progressHUD release];
    progressHUD = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // create progress HUD
    progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    progressHUD.delegate = self;
    progressHUD.removeFromSuperViewOnHide = YES;
    
    // add progress HUD
    [self.view addSubview:progressHUD];
    
    // show progress HUD
    [progressHUD show:YES];

    // load twitter page
    [(UIWebView *)self.view loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://twitter.com/#!/SmokelessCode"]]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [progressHUD hide:YES];
}

#pragma mark -
#pragma mark Web view delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [progressHUD hide:YES];
}

#pragma mark -
#pragma mark Progress HUD delegate

- (void)hudWasHidden
{
    [progressHUD release];
    progressHUD = nil;
}

@end
