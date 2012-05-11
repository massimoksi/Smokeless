//
//  TwitterViewController.m
//  Smokeless
//
//  Created by Massimo Peri on 26/04/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import "TwitterViewController.h"


@interface TwitterViewController ()

@property (nonatomic, strong) MBProgressHUD *progressHUD;

@end


@implementation TwitterViewController

@synthesize progressHUD = _progressHUD;

#pragma mark View lifecycle

- (void)loadView
{
    self.title = @"Twitter";
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 436.0)];
    webView.delegate = self;
    
    self.view = webView;
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.progressHUD = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // create progress HUD
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHUD.delegate = self;
    self.progressHUD.removeFromSuperViewOnHide = YES;
    
    // add progress HUD
    [self.view addSubview:self.progressHUD];
    
    // show progress HUD
    [self.progressHUD show:YES];

    // load twitter page
    [(UIWebView *)self.view loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://twitter.com/#!/massimoperi"]]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.progressHUD hide:YES];
}

#pragma mark - Web view delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.progressHUD hide:YES];
}

#pragma mark - Progress HUD delegate

- (void)hudWasHidden
{
    self.progressHUD = nil;
}

@end
