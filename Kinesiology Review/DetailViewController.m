//
//  DetailViewController.m
//  Kinesiology Review
//
//  Created by Devin Burke on 4/11/12.
//

#import "DetailViewController.h"
#import "AppDelegate.h"
@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController
@synthesize playButton = _playButton;
@synthesize currentCard = _currentCard;
@synthesize largeView = _largeView;
@synthesize nextButton = _nextButton;
@synthesize previousButton = _previousButton;
@synthesize answerButton = _answerButton;
@synthesize setTitle = _setTitle;
@synthesize workingTitle = _workingTitle;
@synthesize aboutButton = _aboutButton;

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize activityTitle = _activityTitle;
@synthesize activitiesList = _activitiesList;
@synthesize description = _description;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize selectedActivities = _selectedActivities;
@synthesize previousActivities;
@synthesize selectedListTitle = _selectedListTitle;
@synthesize imageView = _imageView;




//LOCAL VARIABLES



//Holds previous list titles, including current one
NSMutableArray *previousListTitles;

//A limited list of previous activities, which should not be repeated yet
NSMutableArray *recentActivities;

//The center of the display area
CGPoint displayCenter;

//The center of the card after it's thrown off-screen
CGPoint leftCenter;

//The center of the card before it's thrown on-screen
CGPoint rightCenter;

//The amount of time for an animation to take
NSTimeInterval animationTime = .3;

//Activity current being displayed
Activity *currentActivity;


#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
	
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.
	
	if (self.detailItem) {
	    self.detailDescriptionLabel.text = [self.detailItem description];
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	_activitiesList.text = @"";
	_playButton.hidden = TRUE;
    _answerButton.hidden = TRUE;
    _imageView.hidden = TRUE;
	previousActivities = [NSMutableArray new];
	recentActivities = [NSMutableArray new];
	previousListTitles = [NSMutableArray new];
    UIBarButtonItem *rbi = [[UIBarButtonItem alloc]initWithTitle:@"About" style:UIBarButtonItemStyleBordered target:self action:@selector(showAbout:)];
    _workingTitle.rightBarButtonItem = rbi;
    _workingTitle.rightBarButtonItem.tintColor = [UIColor blackColor];
	[self configureView];
}

- (void)viewDidUnload
{
	[self setActivityTitle:nil];
	[self setActivitiesList:nil];
	[self setDescription:nil];
	[self setPreviousButton:nil];
	[self setNextButton:nil];
    [self setCurrentCard:nil];
	[self setLargeView:nil];
	[self setPlayButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	self.detailDescriptionLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:NO];
    self.masterPopoverController = nil;
}


- (IBAction)showAbout:(UIButton *)sender
{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"About" message:nil delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: @"Details", nil];
    alert.message = @"This app was developed in collaboration with students in CS, UW-Madison. More details about the development team and additional resources and help with using this app is available by clicking 'Details' below (redirect to Safari)";
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex==1){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.cs.wisc.edu/wings/projects/quiztime"]];
    }   
    
}

//When user hits "Next!" button, load and display the next activity
- (IBAction)nextActivity:(UIBarButtonItem *)sender {
	
	if (displayCenter.y == 0) {
		displayCenter = _currentCard.center;
		leftCenter = CGPointMake(_largeView.bounds.origin.x - _currentCard.bounds.size.width, displayCenter.y);
		rightCenter = CGPointMake(_largeView.bounds.origin.x + _largeView.bounds.size.width + _currentCard.bounds.size.width, displayCenter.y);
	}
	if (_selectedActivities.count != 0) {
		
		//If only activity in the selected list is already showing, display an alert
		if (_selectedActivities.count == 1) {
			Activity *nextActivity = [_selectedActivities objectAtIndex:currentPos];
            _nextButton.enabled = NO;
            _previousButton.enabled = NO;

            [self displayActivity:nextActivity];
            
            _currentCard.center = rightCenter;
            
            [UIView animateWithDuration:animationTime animations:^{
                _currentCard.center = displayCenter;
            }];
			
		} else {
			
			[UIView animateWithDuration:animationTime animations:^{
				_currentCard.center = leftCenter;
			} completion:^(BOOL finished){
				if (finished) {
					
					//The activity to be displayed
                    _previousButton.enabled = YES;
                    currentPos++;
                    NSLog(@"detail currentPos %d", currentPos);
                    if (currentPos == _selectedActivities.count - 1){
                        //currentPos--;
                        _nextButton.enabled = NO;
                        _previousButton.enabled = YES;
                    }
                    NSLog(@"detail currentPos %d", currentPos);
                    Activity *nextActivity = [_selectedActivities objectAtIndex:currentPos];
					[self displayActivity:nextActivity];
					
					_currentCard.center = rightCenter;
					
					[UIView animateWithDuration:animationTime animations:^{
						_currentCard.center = displayCenter;
					}];
					
				}
			}];
		}
		
	} else {
		UIAlertView *alert = [[UIAlertView new] initWithTitle:@"Nothing there!" message:@"There aren't any questions of both the level and domain chosen." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
}

//Displays the passed in activity
- (void)displayActivity:(Activity *)activity
{	
	//_activitiesList.text = [_selectedActivities objectAtIndex:currentPos].title;
	_description.text = activity.description;
	_playButton.hidden = activity.videoURL == nil;
    _imageView.hidden = activity.imageURL == nil;

	
	currentActivity = activity;
    _answerButton.hidden = currentActivity.answer == nil;
    if (activity.imageURL != nil){
        _imageView.image = [UIImage imageWithData: currentActivity.imageData];
    }
}

//Displays the previous activity when button is pressed
- (IBAction)backToPrevious:(UIBarButtonItem *)sender {
    currentPos--;
    if (currentPos <= 0){
        currentPos = 0;
        _previousButton.enabled = NO;
        if (_selectedActivities.count == 1){
            _nextButton.enabled = NO;
        }
        if (_selectedActivities.count > 1){
            _nextButton.enabled = YES;
        }
    } else {
        _nextButton.enabled = YES;
    }
	[UIView animateWithDuration:animationTime animations:^{
		_currentCard.center = rightCenter;
	} completion:^(BOOL finished){
		if (finished) {
			[self displayActivity:[_selectedActivities objectAtIndex:currentPos]];
			
			_currentCard.center = leftCenter;
			
			[UIView animateWithDuration:animationTime animations:^{
				_currentCard.center = displayCenter;
			}];
		}
	}];
}
- (IBAction)playVideo:(UIButton *)sender {
	//Messes up if lack of connectivity.  So sue me.
	[self.view addSubview: currentActivity.video.view];
	[currentActivity.video setCurrentPlaybackTime:0];
	[currentActivity.video setFullscreen:YES animated:YES];
	[currentActivity.video play];
	//TODO Return after playing is done
}

- (IBAction)showAnswer:(UIButton *)sender {
            if (currentActivity.answer != nil){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Answer" message:nil delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                alert.message = currentActivity.answer;
                [alert show];
            }
}
@end
