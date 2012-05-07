//
//  AppConstants.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/24/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#define METERS_PER_MILE 1609.344

// COLORS
#define kCultivateGreenColor @"#639939" 
#define kCultivateGrayColor @"#242424"

// USER DEFAULTS
#define kDefaultMinutesBeforeKey @"defaultMinutesBeforeKey"
#define kDefaultRepeatPatternKey @"defaultRepeatPatternKey"
#define kPostcodeKey @"postcodeKey"

// SETTINGS
#define kRepeatPatternOneOff 0
#define kRepeatPatternWeekly 1
#define kRepeatPatternMonthly 2
#define kCultiRideDetailsSet @"cultiRideDetailsSet"

// MAILCHIMP
#define kMailChimpAPIKey @"8bb725580c704b42106c4fcedfa2a9c1-us4"
#define kJoinMainMailingList @"Join mailing list"
#define kJoinVolunteerMailingList @"Join volunteer mailing list"
#define kMainMailingListID @"cb1b5af66c"
#define kVolunteerMailingListID @"0aaf2ad64f"

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
// TODO: implement NSDateComponents