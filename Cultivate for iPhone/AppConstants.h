//
//  AppConstants.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/24/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#define METERS_PER_MILE 1609.344
//#define kDownloadProfileImage // uncomment if want to use Twitter profile image from Cultivate feed

// TWEETING
#define kTweet 0
#define kReply 1
#define kUserRepliesKey @"userRepliesKey"
#define kUserRepliesFilename @"userReplies"
#define kUserProfileImageFilename @"userProfileImage"
#define kMaxTweetLabelSize 220.0f

// UIVIEW TAGS
#define kInternetOverlayViewTag 3
#define kContainerViewTag 100

// ARCHIVING
#define kXmlDataFile @"xmlDataFile"

// FONTS
#define kTitleFont @"Calibri"//@"Euphemia UCAS"
#define kTextFont @"Calibri"
#define kTextFontBold @"Calibri-Bold"

// COLORS
#define kCultivateGreenColor @"#639939"
#define kButtonBackgroundColor @"#639939" 
#define kButtonBorderColor @"#192E0E"
#define kCultivateGrayColor @"#242424"

// USER DEFAULTS
#define kDefaultSecondsBeforeKey @"defaultSecondsBeforeKey"
#define kDefaultRepeatPatternKey @"defaultRepeatPatternKey"
#define kPostcodeKey @"postcodeKey"
#define kLocalNotificationsEnabledKey @"localNotificationsEnabledKey"
#define kFirstLaunchRecorded @"firstLaunchRecorded"
#define kVolunteerDatesKey @"volunteerDatesKey"
#define kOldTweetsKey @"oldTweetsKey"
#define kNotificationHashesKey @"notificationHashesKey"

// SETTINGS BUNDLE
#define pref_showRemindersID @"pref_showReminders"
#define pref_repeatPatternID @"pref_repeatPattern"
#define kRepeatPatternOneOff 0
#define kRepeatPatternWeekly 1
#define kRepeatPatternMonthly 2
#define pref_timeBeforeID @"pref_timeBefore"
#define pref_applySettingsToAllRemindersID @"pref_applySettingsToAllReminders"
#define kCultiRideDetailsSet @"cultiRideDetailsSet"
#define pref_nameID @"pref_name"
#define pref_mobileID @"pref_mobile"
#define pref_emailID @"pref_email"
#define pref_postcodeID @"pref_postcode"
#define pref_resetDetailsID @"pref_resetDetails"
#define kCultiRideName @"name"
#define kCultiRideMobile @"mobile"
#define kCultiRidePostcode @"postcode"
#define kCultiRideDetails @"cultiRideDetails"


// MAILCHIMP
#define kMailChimpAPIKey @"8bb725580c704b42106c4fcedfa2a9c1-us4"
#define kJoinMainMailingList @"Join mailing list"
#define kJoinVolunteerMailingList @"Join volunteer mailing list"
#define kMainMailingListID @"cb1b5af66c"
#define kVolunteerMailingListID @"0aaf2ad64f"
#define kMainMailingListGroupQuestion @"I'm interested in being..."
#define kVolunteerMailingListGroupQuestion @"I would like to volunteer..."
#define kMainMailingListType 0
#define kVolunteerMailingListType 1
#define kWeekly @"Weekly"
#define kMonthly @"Monthly"
#define kOnceInABlueMoon @"Once in a blue moon"
#define kCustomer @"group[397][1]"
#define kLocalChampion @"group[397][4]"
#define kMember @"group[397][8]"
#define kVolunteer @"group[397][16]"
#define kInformed @"group[397][32]"

// MAPS
#define kPostcodeRegex @"^(([gG][iI][rR] {0,}0[aA]{2})|((([a-pr-uwyzA-PR-UWYZ][a-hk-yA-HK-Y]?[0-9][0-9]?)|(([a-pr-uwyzA-PR-UWYZ][0-9][a-hjkstuwA-HJKSTUW])|([a-pr-uwyzA-PR-UWYZ][a-hk-yA-HK-Y][0-9][abehmnprv-yABEHMNPRV-Y]))) {0,}[0-9][abd-hjlnp-uw-zABD-HJLNP-UW-Z]{2}))$"
#define kNoPostcodeStored @"No postcode stored"

// GEOMETRY
#define kScreenWidthPortrait 320
#define kScreenWidthLandscape 480
#define kScreenHeightPortrait 480
#define kScreenHeightLandscape 320
#define kDropdownActive_y 40

// XML PARSING
#define kVegVanStopXMLURL @"http://www.cultivateoxford.org/ipr/VegVanStops.xml"
#define kVegVanStopElement @"stop"
#define kNameElement @"name"
#define kAreaElement @"area"
#define kLongitudeElement @"longitude"
#define kLatitudeElement @"latitude"
#define kStreetNumberElement @"streetNumber"
#define kStreetNameElement @"streetName"
#define kPostcodeElement @"postcode"
#define kPhotoURLElement @"photoURL"
#define kBlurbElement @"blurb"
#define kManagerElement @"manager"
#define kScheduleItemsElement @"scheduleItems"
#define kScheduleItemElement @"scheduleItem"
#define kStopNameElement @"stopName"
#define kStopFrequencyElement @"stopFrequency"
#define kStopDayElement @"stopDay"
#define kStopTimeElement @"stopTime"
#define kStopDurationElement @"stopDuration"
#define kContactElement @"contact"
#define kActiveElement @"active"

// LATEST NEWS XML PARSING
#define kUpdateElement @"update"

// NOTIFICATIONS
#define kNewTweetCountGenerated @"New tweet count generated"
#define kTweetsLoaded @"Tweets loaded"
#define kScheduleItemRefKey @"scheduleItemRefKey"
#define kTweetTabIndex 2
#define kRemoveCultiRideDetailsView @"removeCultiRideDetailsView"
#define kTweetsLoadingFailed @"tweetsLoadingFailed"
#define kScheduleItemDayKey @"scheduleItemDayKey"
#define kScheduleItemTimeKey @"scheduleItemTimeKey"
#define kScheduleItemNameKey @"scheduleItemNameKey"

// GOOGLE ANALYTICS
// Dispatch period in seconds - every 5 mins only
static const NSInteger kGANDispatchPeriodSec = 300;
#define kGoogleAnalyticsKey @"UA-27507588-1"
#define kAppNavigationEvent @"App navigation"
#define kMapInteractionEvent @"Map interaction"
#define kFeedbackEvent @"Feedback"
#define kSharingEvent @"Sharing"
#define kNotificationEvent @"Notifications"
#define kContentInteractionEvent @"Content interaction"