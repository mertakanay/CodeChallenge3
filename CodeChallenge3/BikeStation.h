//
//  BikeStation.h
//  CodeChallenge3
//
//  Created by Mert Akanay on 27.03.2015.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol BikeStationDelegate <NSObject>

-(void)stations:(NSArray *)stationsArray;

@end

@interface BikeStation : NSObject

@property id<BikeStationDelegate>delegate;

@property NSString *stationName;
@property NSNumber *availableDocks;
@property NSNumber *latitude;
@property NSNumber *longitude;

@property CLLocationDistance distance;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
+(NSArray *)stationArrayFromDictionaryArray:(NSArray *)dictionaryArray;
-(void)pullStationsFromAPI;

@end
