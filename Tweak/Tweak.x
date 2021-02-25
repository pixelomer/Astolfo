#import "Astolfo.h"

BOOL enabled;

static void LoadAstolfo(__kindof UIViewController *self) {
	if (!astolfoImageView) astolfoImageView = [Astolfo_FLAnimatedImageView new];

	if (!fillScreenSwitch)
		[astolfoImageView setContentMode:UIViewContentModeScaleAspectFit];
	else
		[astolfoImageView setContentMode:UIViewContentModeScaleAspectFill];

	if (!useCustomAstolfoImageSwitch) {
		static dispatch_once_t token;
		static UIImage *defaultImage;
		dispatch_once(&token, ^{
			defaultImage = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AstolfoPrefs.bundle/astolfo.png"];
			if (!defaultImage) {
				[NSException raise:NSGenericException format:@"Could not load the default image. Have you modified the tweak files? Reinstalling the tweak should fix this issue."];
			}
		});
		astolfoImageView.image = defaultImage;
	}
	else {
		NSData *data = [preferences objectForKey:@"astolfoImage"];
		if (!data) {
			// Huh, the custom image doesn't exist in the preferences. Maybe the
			// user didn't use the new image picker yet.
			data = [NSData dataWithContentsOfFile:@"/var/mobile/Library/Preferences/love.litten.astolfopreferences/astolfoImage-IMG"];
		}
		if (data) {
			// We have the data. Let's try creating an image object with it.
			Astolfo_FLAnimatedImage *animatedImage = [Astolfo_FLAnimatedImage animatedImageWithGIFData:data];
			if (animatedImage) {
				// It is a valid image! It may or may not be a GIF.
				// Astolfo_FLAnimatedImage handles both animated and static images.
				astolfoImageView.animatedImage = animatedImage;
			}
			else {
				// Error handling code: Not sure what this data contains.
			}
		}
		else {
			// Error handling code: The image is not set.
		}
	}

	[astolfoImageView setAlpha:0.0];
	[[self view] addSubview:astolfoImageView];

	[astolfoImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[astolfoImageView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width].active = YES;
	[astolfoImageView.heightAnchor constraintEqualToConstant:self.view.bounds.size.height].active = YES;
	[astolfoImageView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:[astolfoXPositionValue doubleValue]].active = YES;
	[astolfoImageView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:[astolfoYPositionValue doubleValue]].active = YES;
}

static void FadeAstolfo(BOOL fadeIn) {
	[UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		[astolfoImageView setAlpha:(fadeIn ? [astolfoAlphaValue doubleValue] : 0.0)];
	} completion:^(BOOL fullyAnimated){
		if (fullyAnimated) {
			astolfoImageView.image = nil;
			astolfoImageView.animatedImage = nil;
		}
	}];
}

%group Astolfo

%hook SiriUIBackgroundBlurViewController

- (void)viewDidLoad { // add astolfo
	%orig;
	LoadAstolfo(self);
}

- (void)viewWillAppear:(BOOL)animated { // fade astolfo when siri appears
	%orig;
	FadeAstolfo(YES);
}

%end

%hook SiriPresentationViewController

- (void)viewWillDisappear:(BOOL)animated { // fade astolfo when siri disappears
	%orig;
	FadeAstolfo(NO);
}

%end

%end

%group Astolfo13

%hook AFUISiriViewController

- (void)viewDidLoad { // add astolfo
	%orig;
	LoadAstolfo(self);
}

- (void)viewWillAppear:(BOOL)animated { // fade astolfo when siri appears
	%orig;
	FadeAstolfo(YES);
}

- (void)viewWillDisappear:(BOOL)animated { // fade astolfo when siri disappears
	%orig;
	FadeAstolfo(NO);
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