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

- (void)loadView
{
    self.title = @"Twitter";
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 436.0)];
    webView.delegate = self;
    
    self.view = webView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    self.progressHUD = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Create the progress HUD.
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHUD.delegate = self;
    self.progressHUD.removeFromSuperViewOnHide = YES;
    
    // Add the progress HUD.
    [self.view addSubview:self.progressHUD];
    
    // Show the progress HUD.
    [self.progressHUD show:YES];

    // Load the Twitter page.
    [(UIWebView *)self.view loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://twitter.com/#!/massimoperi"]]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.progressHUD hide:YES];
}

#pragma mark - Web view delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // Hide the progress HUD.
    [self.progressHUD hide:YES];
}

#pragma mark - Progress HUD delegate

- (void)hudWasHidden
{
    self.progressHUD = nil;
}

@end
