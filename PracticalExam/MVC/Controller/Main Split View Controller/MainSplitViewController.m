//
//  MainSplitViewController.m
//  PracticalExam
//
//  Created by Mel Bryan Villegas on 5/5/16.
//  Copyright (c) 2016 Mel Bryan Villegas. All rights reserved.
//

#import "MainSplitViewController.h"
#import "MovieDetailsViewController.h"
#import "MovieListMasterViewController.h"

@interface MainSplitViewController ()
{
    
    MovieListMasterViewController *movieListViewController;
}
@end

@implementation MainSplitViewController
    

#pragma mark - OVERRIDEN GETTER
    


#pragma mark - OVERRIDEN SETTER

#pragma mark - INITIALIZATION

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.delegate = self;
    self.presentsWithGesture = NO;
    
    self.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;

    movieListViewController = (MovieListMasterViewController *)[[self.viewControllers firstObject]topViewController];

    //Initializes the AFNetwork Session Manager to acquire the corresponding Movie Data from the designated web-service address.
    
    movieDataDownloadManager = [AFHTTPSessionManager manager];
    
    //Specifies that the web-service address will be returning a data type with text/plain return type.
    movieDataDownloadManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];

    //Calls the download manager function that will use the created AFHTTPSessionManager object.
    [self downloadMovieListParameters];
    
    movieDataDownloadTimer = [NSTimer scheduledTimerWithTimeInterval:30.00f target:self selector:@selector(downloadManagerDidTimeOut:) userInfo:nil repeats:NO];

}

#pragma mark - FUNCTIONS

/*!
 
 @define: Function called in order to initialize the AFNetworking HTTP Session Manager GET function.
 
 */

- (void)downloadMovieListParameters
{
    
    [movieDataDownloadManager GET:movieMetaDataURL parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        if ([NSJSONSerialization isValidJSONObject:responseObject]) {
            
            [movieDataDownloadTimer invalidate];
            movieDataDownloadTimer = nil;
            
            //Sends the Response Object to the Split-View Controller's Master View Controller
            [movieListViewController setMovieDataDictionaryArray:[[responseObject valueForKey:@"data"] valueForKey:@"movies"]];
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        
        //Should there be an error in the acquired JSON response, show an Alert View Controller to notify the user that a download error have occured.
        [movieDataDownloadTimer invalidate];
        movieDataDownloadTimer = nil;
        
        UIAlertView *targetAlertView = [[UIAlertView alloc] initWithTitle:@"Movie List Download Fail" message:@"It appears there was an issue downloading the movie list.  Please make sure that your device is connected to the internet and try again." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try Again", nil];
        
        [targetAlertView show];
    }];
}

/*!
 
 @define: A fall-back function that is called when no data had been received from the AFHTTPSession Manager after 30 seconds have elapsed.
 
 @param: triggerTimer = A NSTimer Variable that is indicates the timer variable that triggered the function Selector.
 
 */

- (void)downloadManagerDidTimeOut: (NSTimer *)triggerTimer
{
    [movieDataDownloadTimer invalidate];
    movieDataDownloadTimer = nil;
    
    UIAlertView *targetAlertView = [[UIAlertView alloc] initWithTitle:@"Movie List Download Fail" message:@"It appears there was an issue downloading the movie list.  Please make sure that your device is connected to the internet and try again." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try Again", nil];
    
    [targetAlertView show];
}

#pragma mark - UIALERTVIEW DELEGATE

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    // If the TRY AGAIN button is pressed, this will retry the Movie Data Download Manager
    if (buttonIndex != 0) {
        
        movieDataDownloadTimer = [NSTimer scheduledTimerWithTimeInterval:30.00f target:self selector:@selector(downloadManagerDidTimeOut:) userInfo:nil repeats:NO];
        
         [self downloadMovieListParameters];
    }
    
}


#pragma mark - DEALLOCATION

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[MovieDetailsViewController class]] && ([(MovieDetailsViewController *)[(UINavigationController *)secondaryViewController topViewController] movieDetailDictionary] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return NO;
    } else {
        return YES;
    }
}



#pragma mark - ROTATION

- (BOOL)shouldAutorotate {

    self.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryHidden;

    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    //Shows the MASTER CONTROLLER if the device detects a landscape orientation rotation
    
    if (orientation != UIInterfaceOrientationPortrait) {

        self.maximumPrimaryColumnWidth = 360.00f;
        self.preferredPrimaryColumnWidthFraction = UISplitViewControllerAutomaticDimension;
        self.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
        
        MovieDetailsViewController *targetViewControler = (MovieDetailsViewController *)[[self.viewControllers lastObject]topViewController];
        
        //Hides the Details View Controller BACK / Menu buttons when in LANDSCAPE orientation
        targetViewControler.navigationItem.leftBarButtonItem = nil;
        
        targetViewControler.navigationItem.leftItemsSupplementBackButton = NO;
    }
    
    else {

        // Sets the MASTER VIEW CONTROLLER to occupy the whole screen on Portrait Orientation
        self.maximumPrimaryColumnWidth = self.view.bounds.size.width;
        self.preferredPrimaryColumnWidthFraction = 1.0f;
        
        MovieDetailsViewController *targetViewControler = (MovieDetailsViewController *)[[self.viewControllers lastObject]topViewController];

        targetViewControler.navigationItem.leftBarButtonItem = nil;
        
        targetViewControler.navigationItem.leftItemsSupplementBackButton = YES;
        
        if (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)) {
            
            //Should there is still an active Details View Controller after the orientation change, hides the MASTER VIEW CONTROLLER.
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"movieListSelectedIndex"] integerValue] != -1) {
                
                self.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryHidden;
                
                targetViewControler.navigationItem.leftBarButtonItem = self.displayModeButtonItem;
            }
            
            //Should there the DETAILS VIEW CONTROLLER was dismissed using the BACK BUTTON, sets the MASTER VIEW CONTROLLER to occupy the screen again on Portrait Orientation.
            else {
                
                self.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
            }
        }
    }
    
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
    
    

@end
