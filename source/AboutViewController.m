//
//  AboutViewController.m
//  Smokeless
//
//  Created by Massimo Peri on 16/10/10.
//  Copyright 2010 Massimo Peri. All rights reserved.
//

#import "AboutViewController.h"


#define LOGO_PADDING	27.0
#define TABLE_PADDING	8.0
#define MAIL_ADDRESS	@"massimoperi@gmail.com"


@implementation AboutViewController

- (void)loadView
{
	// create view
	self.view = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
	// set background color
	self.view.backgroundColor = [UIColor clearColor];
	// set the title
	self.title = MPString(@"About");
}

- (void)viewDidLoad
{
	// create logo
	UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TitleAbout"]];
	logoView.frame = CGRectMake(0.0,
								LOGO_PADDING,
								logoView.frame.size.width,
								logoView.frame.size.height);

	// create table view
	self.infosTable = [[[UITableView alloc] initWithFrame:CGRectMake(0.0,
                                                                     logoView.frame.origin.y + logoView.frame.size.height + TABLE_PADDING,
                                                                     320.0,
                                                                     320.0)
                                                    style:UITableViewStyleGrouped] autorelease];
	self.infosTable.scrollEnabled = NO;
	self.infosTable.backgroundColor = [UIColor clearColor];
	self.infosTable.separatorColor = [UIColor darkGrayColor];
	self.infosTable.delegate = self;
	self.infosTable.dataSource = self;
	
	// add subviews
	[self.view addSubview:logoView];
	[self.view addSubview:self.infosTable];
	
	// release subviews
	[logoView release];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.twitterNavController = nil;
    self.infosTable = nil;
}

- (void)dealloc
{
    self.twitterNavController = nil;
    self.infosTable = nil;
	
    [super dealloc];
}

#pragma mark Accessors

@synthesize infosTable;
@synthesize twitterNavController;

#pragma mark Actions

- (void)sendEmail
{
	if ([MFMailComposeViewController canSendMail]) {
		// create mail composer
		MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
		mailComposer.mailComposeDelegate = self;
		mailComposer.navigationBar.barStyle = UIBarStyleDefault;
		[mailComposer setToRecipients:[NSArray arrayWithObject:MAIL_ADDRESS]];
		
		// show mail composer
		[self presentModalViewController:mailComposer
								animated:YES];
		[mailComposer release];
	}
	else {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"mailto:" stringByAppendingString:MAIL_ADDRESS]]];
	}
}

- (void)followOnTwitter
{
    // create twitter web view controller
    TwitterViewController *twitterController = [[TwitterViewController alloc] init];
    
    // create twitter navigation controller
    self.twitterNavController = [[[UINavigationController alloc] initWithRootViewController:twitterController] autorelease];
    [twitterController release];
    
    // create cancel bar button
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                     target:self
                                                                                     action:@selector(closeTwitterModalView)];
    self.twitterNavController.navigationBar.topItem.leftBarButtonItem = cancelBarButton;
    [cancelBarButton release];
    
    // create done bar button
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                   target:self
                                                                                   action:@selector(closeTwitterModalView)];
    self.twitterNavController.navigationBar.topItem.rightBarButtonItem = doneBarButton;
    [doneBarButton release];    
    
    // present twitter navigation controller
    [self presentModalViewController:self.twitterNavController
                            animated:YES];
}

- (void)closeTwitterModalView
{
    // dismiss twitter navigation controller
    [self dismissModalViewControllerAnimated:YES];
    
    self.twitterNavController = nil;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return AboutNoOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger rows = 0;
	
	switch (section) {
		case AboutSectionVersion:
			rows = 1;
			break;
			
		case AboutSectionCredits:
			rows = 1;
			break;

		case AboutSectionContacts:
			rows = ContactsNoOfRows;
			break;
	}
	
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	
	MPTableViewCell *cell = (MPTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[MPTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
									   reuseIdentifier:CellIdentifier] autorelease];
		
		// customize cells appearence
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
		cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.710 alpha:1.000];
        cell.textLabel.highlightedTextColor = [UIColor whiteColor];
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.710 alpha:1.000];
        
        cell.backgroundView.style = MPCellStyleColorFill;
        cell.backgroundView.cornerRadius = 5.0;
        cell.backgroundView.borderColor = [UIColor colorWithWhite:0.710 alpha:0.750];
        cell.backgroundView.fillColor = [UIColor colorWithWhite:0.000 alpha:0.750];
        
        cell.selectedBackgroundView.cornerRadius = 5.0;
        cell.selectedBackgroundView.borderColor = [UIColor colorWithWhite:0.710 alpha:0.750];
	}
	
	// set cells content
	switch (indexPath.section) {
		case AboutSectionVersion:
            cell.position = MPTableViewCellPositionSingle;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.textLabel.text = MPString(@"Version");
#ifdef DEBUG
			cell.detailTextLabel.text = [NSString stringWithFormat:
										 @"%@ (%d)",
										 [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
										 [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] intValue]];
#else
			cell.detailTextLabel.text = [NSString stringWithFormat:
										 @"%@",
										 [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
#endif
			break;
		
		case AboutSectionCredits:
            cell.position = MPTableViewCellPositionSingle;
			cell.textLabel.text = MPString(@"Credits");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            ((MPDisclosureIndicator *)cell.accessoryView).orientation = MPDisclosureIndicatorOrientationRight;
            ((MPDisclosureIndicator *)cell.accessoryView).highlighted = NO;
            ((MPDisclosureIndicator *)cell.accessoryView).normalColor = [UIColor colorWithWhite:0.710 alpha:1.000];
            ((MPDisclosureIndicator *)cell.accessoryView).highlightedColor = [UIColor whiteColor];
			break;
	
		case AboutSectionContacts:
			switch (indexPath.row) {
				case ContactsRowEmail:
                    cell.position = MPTableViewCellPositionTop;
					cell.textLabel.text = MPString(@"Send e-mail");
					break;
					
				case ContactsRowTwitter:
                    cell.position = MPTableViewCellPositionBottom;
					cell.textLabel.text = MPString(@"Follow on Twitter");
					break;
			}
			break;
	}
	
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	// editing rows is not enabled
    return NO;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// perform cell action
	switch (indexPath.section) {
        case AboutSectionCredits:
			[self.navigationController pushViewController:[[[CreditsViewController alloc] init] autorelease]
												 animated:YES];
            break;
            
		case AboutSectionContacts:
			switch (indexPath.row) {
				case ContactsRowEmail:
					[self sendEmail];
					break;
					
				case ContactsRowTwitter:
                    // launch twitter
                    [self followOnTwitter];
					break;
			}
			break;
	}
	
	// deselect row
	[tableView deselectRowAtIndexPath:indexPath
							 animated:YES];
}

#pragma mark -
#pragma mark Mail compose delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	switch (result) {
		case MFMailComposeResultCancelled:
		case MFMailComposeResultSaved:
		case MFMailComposeResultSent:
		case MFMailComposeResultFailed:
			break;
			
		default:
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:MPString(@"E-mail")
															message:MPString(@"Sending Failed - Unknown Error")
														   delegate:self
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
			break;
		}
	}
	
	// dismiss mail composer
	[self dismissModalViewControllerAnimated:YES];
}
	
@end
