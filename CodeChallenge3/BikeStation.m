//
//  BikeStation.m
//  CodeChallenge3
//
//  Created by Mert Akanay on 27.03.2015.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import "BikeStation.h"

@implementation BikeStation

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    self.stationName = [dictionary objectForKey:@"stationName"];
    self.availableDocks = [dictionary objectForKey:@"availableDocks"];
    self.latitude = [dictionary objectForKey:@"latitude"];
    self.longitude = [dictionary objectForKey:@"longitude"];

    return self;
}

+(NSArray *)stationArrayFromDictionaryArray:(NSArray *)dictionaryArray
{
    NSMutableArray *newArray = [NSMutableArray new];
    for (NSDictionary *dict in dictionaryArray) {
        BikeStation *station = [[BikeStation alloc]initWithDictionary:dict];
        [newArray addObject:station];
    }
    return [NSArray arrayWithArray:newArray];
}

-(void)pullStationsFromAPI
{
    NSURL *url = [NSURL URLWithString:@"http://www.bayareabikeshare.com/stations/json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        NSDictionary *bikeStations = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

        NSArray *stationBeanList = [BikeStation stationArrayFromDictionaryArray:bikeStations[@"stationBeanList"]];
        [self.delegate stations:stationBeanList];

    }];
}

@end
