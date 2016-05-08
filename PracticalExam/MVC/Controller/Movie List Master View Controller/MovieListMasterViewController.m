//
//  MovieListMasterViewController.m
//  PracticalExam
//
//  Created by Mel Bryan Villegas on 5/6/16.
//  Copyright (c) 2016 Mel Bryan Villegas. All rights reserved.
//

#import "MovieListMasterViewController.h"
#import "MovieDetailsViewController.h"

@interface MovieListMasterViewController ()
@end

@implementation MovieListMasterViewController

@synthesize movieListTableView;

@synthesize movieDataDictionaryArray = _movieDataDictionaryArray;


#pragma mark - OVERRIDEN GETTER
//Implements a GETTER method for the movieDataDictionaryArray in order to avoid NIL / NULL initialization
- (NSMutableArray *)movieDataDictionaryArray
{
    if (!_movieDataDictionaryArray) {
        
        _movieDataDictionaryArray = [NSMutableArray array];
    }
    
    return _movieDataDictionaryArray;
}

#pragma mark - OVERRIDEN SETTER
//Overrides the default SET command used by the movieDataDictionaryArray.
- (void)setMovieDataDictionaryArray:(NSMutableArray *)newMovieDataDictionaryArray
{

    if (newMovieDataDictionaryArray) {
        
        [self.movieDataDictionaryArray removeAllObjects];
        [self.movieDataDictionaryArray addObjectsFromArray:newMovieDataDictionaryArray];
        
        
        //Implemented an enumerator method in order to convert the Array of Dictionary Objects passed to mutable copies.
        [self.movieDataDictionaryArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:obj];
            
            [self.movieDataDictionaryArray replaceObjectAtIndex:idx withObject:mutableDictionary];

            if (idx == self.movieDataDictionaryArray.count - 1) {
                
                //Sets the default value to be used by the DETAILS VIEW CONTROLLER when running the app on an iPAD device.
                if (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)) {
                    
                    [self performSegueWithIdentifier:@"showMovieDetails" sender:self];
                    
                    self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
                }
                
                
                [self.movieListTableView reloadData];
            }
        }];
    }
}

#pragma mark - INITIALIZATION

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Resets the Movie List Selection Index saved whenever the MASTER CONTROLLER is shown back to the active screen (e.g BACK BUTTON was pressed).
    [[NSUserDefaults standardUserDefaults] setObject:@(-1) forKey:@"movieListSelectedIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    firstLoad = TRUE;
    
    movieListTableView.dataSource = self;
    movieListTableView.delegate = self;
    
    self.detailViewController = (MovieDetailsViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

#pragma mark - DEALLOCATION

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showMovieDetails"]) {

        MovieDetailsViewController *controller = (MovieDetailsViewController *)[[segue destinationViewController] topViewController];
        
        controller.movieDetailDictionary = self.movieDataDictionaryArray[self.movieListTableView.indexPathForSelectedRow.row];
    
        [[NSUserDefaults standardUserDefaults] setObject:@(self.movieListTableView.indexPathForSelectedRow.row) forKey:@"movieListSelectedIndex"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        
        if (firstLoad) {
            
            firstLoad = FALSE;
            
            controller.movieDetailDictionary = [self.movieDataDictionaryArray firstObject];
            
            [[NSUserDefaults standardUserDefaults] setObject:@(-1) forKey:@"movieListSelectedIndex"];
            [[NSUserDefaults standardUserDefaults] synchronize];

        }
        
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        
        controller.navigationItem.leftItemsSupplementBackButton = YES;
        
        if (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) && ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait)) {
            
            self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryHidden;
        }
        
        else if (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) && ([[UIApplication sharedApplication] statusBarOrientation] != UIInterfaceOrientationPortrait)) {
            
            controller.navigationItem.leftBarButtonItem = nil;
            
            controller.navigationItem.leftItemsSupplementBackButton = NO;

        }
    }
}

#pragma mark - UITABLEVIEW DATASOURCE

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.movieDataDictionaryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   __weak UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"movieListCell" forIndexPath:indexPath];
    
    
    UIImageView *targetMovieBackgroundImageView = (UIImageView *)[cell viewWithTag:1];
    UILabel *targetMovieLabel = (UILabel *)[cell viewWithTag:2];
    UILabel *targetMovieReleaseYear = (UILabel *)[cell viewWithTag:3];

    //Creates a weak pointer to the targetMovieBackgroundImageView;
    __weak UIImageView *imageBackground = targetMovieBackgroundImageView;
    
    //Performs an asynchronous URL loading for the designated movie backdrop should no values is saved yet inside the Data Source Dictionary.
    if ([[self.movieDataDictionaryArray objectAtIndex:indexPath.row] valueForKey:@"movieBackdropImage"] == nil) {
        
        NSString *movieImageURLString = [NSString stringWithFormat:@"%@%@-backdrop.jpg", movieImageDataURL, [[self.movieDataDictionaryArray objectAtIndex:indexPath.row] valueForKey:@"slug"]];
        
        [targetMovieBackgroundImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:movieImageURLString]] placeholderImage:[UIImage imageNamed:@"placeholder"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            
            if (image) {
                
                NSMutableDictionary *movieDictionary = [self.movieDataDictionaryArray objectAtIndex:indexPath.row];
                
                [movieDictionary setObject:image forKey:@"movieBackdropImage"];
                
                [imageBackground setImage:image];
                
            }
            
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            
        }];
    }
    
    else {
        
        [targetMovieBackgroundImageView setImage:[[self.movieDataDictionaryArray objectAtIndex:indexPath.row] objectForKey:@"movieBackdropImage"]];
    }

    targetMovieLabel.text = [[self.movieDataDictionaryArray objectAtIndex:indexPath.row] valueForKey:@"title_long"];
    targetMovieReleaseYear.text = [NSString stringWithFormat:@"%@", [[self.movieDataDictionaryArray objectAtIndex:indexPath.row] valueForKey:@"year"]];
    
    return cell;
}


@end
