#import "Astolfo.h"

BOOL enabled;

%group Astolfo

%hook SiriUIBackgroundBlurViewController

- (void)viewDidLoad { // add astolfo

	%orig;

	if (!astolfoImageView) astolfoImageView = [UIImageView new];

	if (!fillScreenSwitch)
		[astolfoImageView setContentMode:UIViewContentModeScaleAspectFit];
	else
		[astolfoImageView setContentMode:UIViewContentModeScaleAspectFill];

	if (!useCustomAstolfoImageSwitch)
		[astolfoImageView setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AstolfoPrefs.bundle/astolfo.png"]];
	else
		[astolfoImageView setImage:[GcImagePickerUtils imageFromDefaults:@"love.litten.astolfopreferences" withKey:@"astolfoImage"]];
		
	[astolfoImageView setAlpha:0.0];
	[[self view] addSubview:astolfoImageView];

	[astolfoImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[astolfoImageView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width].active = YES;
	[astolfoImageView.heightAnchor constraintEqualToConstant:self.view.bounds.size.height].active = YES;
	[astolfoImageView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:[astolfoXPositionValue doubleValue]].active = YES;
	[astolfoImageView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:[astolfoYPositionValue doubleValue]].active = YES;

}

- (void)viewWillAppear:(BOOL)animated { // fade astolfo when siri appears

	%orig;

	[UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		[astolfoImageView setAlpha:[astolfoAlphaValue doubleValue]];
	} completion:nil];

}

%end

%hook SiriPresentationViewController

- (void)viewWillDisappear:(BOOL)animated { // fade astolfo when siri disappears

	%orig;

	[UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		[astolfoImageView setAlpha:0.0];
	} completion:nil];

}

%end

%end

%group Astolfo13

%hook AFUISiriViewController

- (void)viewDidLoad { // add astolfo

	%orig;

	if (!astolfoImageView) astolfoImageView = [UIImageView new];

	if (!fillScreenSwitch)
		[astolfoImageView setContentMode:UIViewContentModeScaleAspectFit];
	else
		[astolfoImageView setContentMode:UIViewContentModeScaleAspectFill];

	if (!useCustomAstolfoImageSwitch)
		[astolfoImageView setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AstolfoPrefs.bundle/astolfo.png"]];
	else
		[astolfoImageView setImage:[GcImagePickerUtils imageFromDefaults:@"love.litten.astolfopreferences" withKey:@"astolfoImage"]];
		
	[astolfoImageView setAlpha:0.0];
	[[self view] addSubview:astolfoImageView];

	[astolfoImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[astolfoImageView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width].active = YES;
	[astolfoImageView.heightAnchor constraintEqualToConstant:self.view.bounds.size.height].active = YES;
	[astolfoImageView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:[astolfoXPositionValue doubleValue]].active = YES;
	[astolfoImageView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:[astolfoYPositionValue doubleValue]].active = YES;

}

- (void)viewWillAppear:(BOOL)animated { // fade astolfo when siri appears

	%orig;

	[UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		[astolfoImageView setAlpha:[astolfoAlphaValue doubleValue]];
	} completion:nil];

}

- (void)viewWillDisappear:(BOOL)animated { // fade astolfo when siri disappears

	%orig;

	[UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		[astolfoImageView setAlpha:0.0];
	} completion:nil];

}

%end

%end

%ctor {

	preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.astolfopreferences"];

	[preferences registerBool:&enabled default:nil forKey:@"Enabled"];

	// Image Customization
	[preferences registerBool:&useCustomAstolfoImageSwitch default:NO forKey:@"useCustomAstolfoImage"];
	[preferences registerBool:&fillScreenSwitch default:NO forKey:@"fillScreen"];
	[preferences registerObject:&astolfoXPositionValue default:@"0.0" forKey:@"astolfoXPosition"];
	[preferences registerObject:&astolfoYPositionValue default:@"150.0" forKey:@"astolfoYPosition"];
	[preferences registerObject:&astolfoAlphaValue default:@"1.0" forKey:@"astolfoAlpha"];

	if (enabled) {
		if (!SYSTEM_VERSION_LESS_THAN(@"14")) %init(Astolfo);
		else if (SYSTEM_VERSION_LESS_THAN(@"14")) %init(Astolfo13);
	}

}