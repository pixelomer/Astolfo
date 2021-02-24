#import <Preferences/PSListController.h>
#import <Preferences/PSListItemsController.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>

@interface AFOAppearanceSettings : HBAppearanceSettings
@end

@interface AFOContributorsSubPrefsListController : HBListController
@property(nonatomic, retain)UILabel* titleLabel;
@end