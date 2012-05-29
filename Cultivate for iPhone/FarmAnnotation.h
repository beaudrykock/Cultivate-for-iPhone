//
//  FarmAnnotation.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 5/29/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FarmAnnotation : NSObject <MKAnnotation>
{
    NSString *farmName;
    NSString *farmAddress;
    CLLocationCoordinate2D _coordinate;
}

@property (copy) NSString *farmName;
@property (copy) NSString *farmAddress;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;

@end
