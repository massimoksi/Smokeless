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
#define MAIL_ADDRESS	@"massimo.peri@me.com"


@interface AboutViewController ()

@property (nonatomic, strong) UINavigationController *twitterNavController;

- (void)sendEmail;
- (void)followOnTwitter;
- (void)closeTwitterModalView;

@end


@implementation AboutViewController

- (void)viewDidLoad
{
	// set the title
	self.title = MPString(@"About");

	// set background color
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // create logo
	UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TitleAbout"]];
	logoView.frame = CGRectMake(0.0,
								LOGO_PADDING,
								logoView.frame.size.width,
								logoView.frame.size.height);
    self.tableView.tableHeaderView = logoView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    self.twitterNavController = nil;
}

#pragma mark Actions

- (void)sendEmail
{
	if ([MFMailComposeViewController canSendMail]) {
		// create mail composer
		MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
		mailComposer.mailComposeDelegate = self;
		mailComposer.navigationBar.barStyle = UIBarStyleDefault;
		[mailComposer setToRecipients:@[MAIL_ADDRESS]];
        [mailComposer setSubject:MPString(@"Smokeless support")];
		
		// show mail composer
		[self presentModalViewController:mailComposer
								animated:YES];
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
    self.twitterNavController = [[UINavigationController alloc] initWithRootViewController:twitterController];
    
    // create cancel bar button
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                     target:self
                                                                                     action:@selector(closeTwitterModalView)];
    self.twitterNavController.navigationBar.topItem.leftBarButtonItem = cancelBarButton;
    
    // create done bar button
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                   target:self
                                                                                   action:@selector(closeTwitterModalView)];
    self.twitterNavController.navigationBar.topItem.rightBarButtonItem = doneBarButton;
    
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

#pragma mark - Table view data source

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
		cell = [[MPTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
		
		// customize cells appearence
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
		cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.710
                                                     alpha:1.000];
        cell.textLabel.highlightedTextColor = [UIColor whiteColor];
        cell.textLabel.shadowColor = [UIColor colorWithWhite:0.000
                                                       alpha:1.000];
        cell.textLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.710
                                                           alpha:1.000];
        cell.detailTextLabel.shadowColor = [UIColor colorWithWhite:0.000
                                                             alpha:1.000];
        cell.detailTextLabel.shadowOffset = CGSizeMake(0.0, 1.0);

        
        cell.backgroundView.style = MPCellStyleColorFill;
        cell.backgroundView.cornerRadius = 5.0;
        cell.backgroundView.borderColor = [UIColor colorWithWhite:0.710
                                                            alpha:0.750];
        cell.backgroundView.fillColor = [UIColor colorWithWhite:0.000
                                                          alpha:0.750];
        
        cell.selectedBackgroundView.cornerRadius = 5.0;
        cell.selectedBackgroundView.borderColor = [UIColor colorWithWhite:0.710
                                                                    alpha:0.750];
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
										 [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"],
										 [[[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"] intValue]];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// perform cell action
	switch (indexPath.section) {
        case AboutSectionCredits:
			[self.navigationController pushViewController:[[CreditsViewController alloc] init]
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

#pragma mark - Mail compose delegate

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
			break;
		}
	}
	
	// dismiss mail composer
	[self dismissModalViewControllerAnimated:YES];
}
	
@end
