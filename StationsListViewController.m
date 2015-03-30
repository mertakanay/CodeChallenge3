//
//  StationsListViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "StationsListViewController.h"
#import "BikeStation.h"
#import "MapViewController.h"

@interface StationsListViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property NSArray *bikeArray;
@property NSDictionary *bikeDictionary;
@property BikeStation *station;
@property NSMutableArray *secondBikeArray;
@property NSArray *sortedBikeArray;

@end

@implementation StationsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    BikeStation *apiCall = [[BikeStation alloc]init];
    apiCall.delegate = self;
    [apiCall pullStationsFromAPI];

    

}

-(void)stations:(NSArray *)stationsArray;
{
    self.bikeArray = stationsArray;

    //sorting the bikes
    self.sortedBikeArray = [self.bikeArray sortedArrayUsingComparator:^NSComparisonResult(BikeStation *obj1, BikeStation *obj2) {
        if (obj1.distance > obj2.distance)
        {
            return NSOrderedDescending;
        }else
        {
            return NSOrderedAscending;
        }
    }];

    [self.tableView reloadData];
}


#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // TODO:
    return self.sortedBikeArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    self.station = [self.sortedBikeArray objectAtIndex:indexPath.row];
    cell.textLabel.text = self.station.stationName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %.2f",[self.station.availableDocks stringValue],self.station.distance];


    return cell;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.secondBikeArray isEqualToArray:self.bikeArray];

    NSString *search = [NSString stringWithFormat:@"%@",searchBar.text];
    for (BikeStation *newStation in self.bikeArray)
    {
        if (![search isEqualToString:self.station.stationName])
        {
            [self.secondBikeArray removeObject:newStation];
        }

    }
    [searchBar resignFirstResponder];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MapViewController *mapVC = [segue destinationViewController];
    mapVC.station = self.station;
}

@end
